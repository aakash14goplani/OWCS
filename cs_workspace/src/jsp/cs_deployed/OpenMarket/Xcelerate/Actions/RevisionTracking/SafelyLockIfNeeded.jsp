<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<%
//
// OpenMarket/Xcelerate/Actions/RevTracking/SafelyLockIfNeeded
//
// INPUT
//
// CurrentUserID (ics variable) - the user ID of the current user
// CurrentUserName (ics variable) - the user NAME of the current user
// AssetType (ics variable) - the type of asset this is
// id (ics variable) - the id of the asset to lock
// Function (ics variable) - the name of the function being performed, if implicit lock is
// 	to be created, or empty/null, if not.
//
// OUTPUT
//
// Errno (ics variable) - Set to a negative error code if something went wrong (other
//	than inability to lock the asset).
// LockStatus (ics variable) - Set to one of the following strings: "newlock", "oldlock", "failure".
//	"newlock" means that we needed to create a new lock for this asset for this user.
//	"oldlock" means that the user already had a lock on this asset.
//	If "failure", the current lock holder is returned in the ics variable
//	"CurrentLockHolder".
//  If "" means none of the above status applies for example in case of not authorized.
//
// DESCRIPTION
//
// In preparation for editing, deleting, etc., lock an asset.
// Furthermore, lock it in such a way as to prohibit other simultaneous lockers
// from succeeding.
//
// Since this element must be used in many situations, input variables
// are used to signal exactly what this element should do - e.g., whether or
// not the checkout (if it even occurs) should be flagged as an implicit checkout
// or not.
//
// This element should ONLY be called if rev tracking is enabled on the asset type
// in question.  If used in any other way, an error will be returned.
//
%>

<cs:ftcs>

<%

// Construct the lock name and the lock manager handle
String lockName = "ui-asset-lock-"+ics.GetVar("id");
com.openmarket.xcelerate.interfaces.ILockManager lockManager = com.openmarket.xcelerate.interfaces.LockManagerFactory.make(ics);
// Enter a write lock on this key (exclusive lock). 
lockManager.enterWriteLock(lockName);
try
{
	// Pre-initialize our return variables
	ics.SetVar("LockStatus","newlock");
	ics.SetVar("CurrentLockHolder","");
	
	// Flag indicating that we need to lock this asset
	boolean needToLock = false;
	COM.FutureTense.Interfaces.FTValList list;
	
	COM.FutureTense.Interfaces.IList historyList = ics.RTHistory(ics.GetVar("AssetType"),ics.GetVar("id"),null,null,null,null,"ItsHistory");
	
	// Any rows?
	if (historyList.numRows() > 0)
	{
		// There is some lock history.  The first row is the most recent lock/checkout
		historyList.moveToRow(COM.FutureTense.Interfaces.IList.gotorow,1);
		String value = historyList.getValue("lockedby");
		if (value == null || value.length() == 0)
			needToLock = true;
		else
		{
			ics.SetVar("CurrentLockHolder",value);

			if (!value.equalsIgnoreCase(ics.GetVar("CurrentUserName")))
			{
				// It's locked by someone else, so signal this to the caller.
				ics.SetVar("LockStatus","failure");
			}
			else
			{
				// It's locked by us already
				ics.SetVar("LockStatus","oldlock");
			}
		}
	}
	else
		needToLock = true;

	// If we need to lock, do it now.
	if (needToLock)
	{
		%>
		<!-- check whether we can perform this function on this asset -->
		<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/AccessCheck">
			<ics:argument name="assetObjectName" value="theCurrentAsset"/>
			<ics:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
			<ics:argument name="id" value='<%=ics.GetVar("id")%>'/>
			<ics:argument name="Function" value='checkout'/>
		</ics:callelement>
		<%
		if(!"IllegalTransition".equals(ics.GetVar("error"))){
			list = new COM.FutureTense.Interfaces.FTValList();
			list.setValString("OBJECTTYPE",ics.GetVar("AssetType"));
			list.setValString("OBJECTID",ics.GetVar("id"));
			ics.runTag("ASSET.CHECKOUT",list);
			// Preserve the error codes!
			int errno = ics.GetErrno();
			if (errno >= 0)
			{
				// Attempt to note this activity in the implicit lock table, if requested.
				String implicitFunction = ics.GetVar("Function");
				if (implicitFunction != null && implicitFunction.length() > 0)
				{
					// <implicitcheckout.logimplicitcheckout ASSETTYPE="Variables.AssetType"
					//	ASSETID="Variables.id"
					//	USER="Variables.userID"
					//	FUNCTION="Edit"/>
					list = new COM.FutureTense.Interfaces.FTValList();
					list.setValString("ASSETTYPE",ics.GetVar("AssetType"));
					list.setValString("ASSETID",ics.GetVar("id"));
					list.setValString("USER",ics.GetVar("CurrentUserID"));
					list.setValString("FUNCTION",implicitFunction);
					ics.runTag("IMPLICITCHECKOUT.LOGIMPLICITCHECKOUT",list);
					// Once again, preserve any error codes...
				}

			}
		} else {
		ics.SetVar("LockStatus","");
		%>
			<xlat:lookup key="dvin/UI/PermissionsIssueAssetNotCheckedOut" varname="_XLAT_"/>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
                 <ics:argument name="msgtext" value="Variables._XLAT_"/>
		         <ics:argument name="severity" value="warning"/>	
            </ics:callelement>
		<%	
		}
	}
	else
	{
		// No new lock is needed.  No implicit lock table write will be needed either.  Just clear the error and return.
		ics.SetErrno(0);
	}
}
catch (NoSuchFieldException e)
{
	ics.SetErrno(-100);
	ics.LogMsg("Unexpected UI error: "+e.getMessage());
}
finally
{
	lockManager.leaveWriteLock(lockName);
}
%>
</cs:ftcs>

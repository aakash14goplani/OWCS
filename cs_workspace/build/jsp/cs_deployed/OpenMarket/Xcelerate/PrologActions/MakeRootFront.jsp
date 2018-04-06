<%@ page
        import="COM.FutureTense.Interfaces.ICS, COM.FutureTense.Interfaces.IList, COM.FutureTense.Util.IterableIListWrapper, com.fatwire.assetapi.data.AssetId, com.openmarket.xcelerate.asset.AssetIdImpl, java.util.ArrayList, java.util.List" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%
    //
// OpenMarket/Xcelerate/PrologActions/MakeRootFront
//
// INPUT
//
// OUTPUT
//
%>
<cs:ftcs>
    <ics:setvar name="doproceed" value="true"/>

    <ics:setvar name="assetname" value="theCurrentAsset"/>
    <%--To be removed when conversion to assetObjectName is complete--%>
    <ics:setvar name="assetObjectName" value="theCurrentAsset"/>

    <%-- check to make sure the input asset actually exists --%>
    <asset:load type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("id")%>'
                name='<%=ics.GetVar("assetObjectName")%>' editable="true"/>
    <ics:if condition="<%=ics.GetErrno() < 0%>">
        <ics:then>
            <ics:setvar name="doproceed" value="InvalidContentId"/>
        </ics:then>
    </ics:if>

    <%-- check the input id to ensure that the new target master actually exists --%>
    <ics:if condition='<%=ics.GetVar("MakeRootID") != null%>'>
        <ics:then>
            <asset:load type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("MakeRootID")%>'
                        name='makeroot:proposedNewMasterExistenceCheck' editable="true"/>
            <ics:if condition="<%=ics.GetErrno() < 0%>">
                <ics:then>
                    <ics:setvar name="doproceed" value="CantMakeRootInvalidNewMasterId"/>
                </ics:then>
            </ics:if>
        </ics:then>
    </ics:if>

    <%
        List<AssetId> thisAssetPlusRelativesInDimGroup = new ArrayList<AssetId>();
        thisAssetPlusRelativesInDimGroup.add(new AssetIdImpl(ics.GetVar("AssetType"), Long.valueOf(ics.GetVar("id"))));
    %>
    <asset:getrelatives name='<%=ics.GetVar("assetObjectName")%>' list="makeroot:relatives"/>
    <%
        for (IList row : new IterableIListWrapper(ics.GetList("makeroot:relatives")))
        {
            thisAssetPlusRelativesInDimGroup.add(new AssetIdImpl(row.getValue("TYPE"), Long.valueOf(row.getValue("OBJECTID"))));
        }
    %>

    <%-- Now call the access check function to make sure that the user has privs on all of these assets --%>
    <%
        for (AssetId id : thisAssetPlusRelativesInDimGroup)
        {
    %>
    <ics:if condition='<%="true".equals(ics.GetVar("doproceed"))%>'>
        <ics:then>
            <asset:load name="makeroot:relative" type='<%=id.getType()%>' objectid='<%=Long.toString(id.getId())%>' editable="true"/>
            <ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/AccessCheck">
                <ics:argument name="assetObjectName" value="makeroot:relative"/>
                <ics:argument name="AssetType" value='<%=id.getType()%>'/>
                <ics:argument name="pubid" value='<%=ics.GetSSVar("pubid")%>'/>
                <ics:argument name="id" value='<%=Long.toString(id.getId())%>'/>
                <ics:argument name="Function" value="makeroot"/>
            </ics:callelement>
            <ics:if condition='<%=ics.GetVar("error") != null && ics.GetVar("error").length() > 0%>'>
                <ics:then>
                    <%-- -12069 means allow edit but display warning, any other error means prohibit edit --%>
                    <ics:if condition='<%=ics.GetErrno() == -12069%>'>
                        <ics:then>
                            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
                                <ics:argument name="elem" value="EditNotAllowed"/>
                                <ics:argument name="severity" value="info"/>
                                <ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
                                <ics:argument name="id" value='<%=ics.GetVar("id")%>'/>
                            </ics:callelement>
                        </ics:then>
                        <ics:else>
                            <%-- note this is NOT errno, it is error.  It corresponds to an error element. --%>
                            <ics:setvar name="doproceed" value='<%=ics.GetVar("error")%>'/>
                        </ics:else>
                    </ics:if>
                </ics:then>
            </ics:if>
        </ics:then>
    </ics:if>
    <%
        }
    %>

    <%-- Scatter the main asset. --%>
    <ics:if condition='<%="true".equals(ics.GetVar("doproceed"))%>'>
        <ics:then>
            <asset:scatter name='<%=ics.GetVar("assetObjectName")%>' prefix="ContentDetails" fieldlist="*"/>
            <ics:if condition='<%=ics.GetErrno() < 0%>'>
                <ics:then>
                    <ics:setvar name="doproceed" value="InvalidContentId"/>
                </ics:then>
            </ics:if>
        </ics:then>
    </ics:if>

    <ics:if condition='<%="true".equals(ics.GetVar("doproceed"))%>'>
        <ics:then>
            <!-- check to see if the table is tracked
            if so, then the current record must
            be locked by the current user -->
            <ics:callelement element="OpenMarket/Xcelerate/Actions/RevisionTracking/CheckTrackingEnabled">
                <ics:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
            </ics:callelement>
            <ics:if condition='<%="true".equals(ics.GetVar("trackingenabled"))%>'>
                <ics:then>

                    <%-- If revision tracking is enabled, then we have a lot of work to do.
                         first, because the "makeroot" function actually deals not just the
                         current asset, but all of the asset's relatives too, we have to
                         make sure that the current asset and all of its relatives in the
                         group are checked out to the current user before we can proceed
                         and make any changes.

                         First, make sure they aren't checked out to someone else, then
                         make sure they are indeed checked out to the current user. --%>

                    <%-- If this asset is locked by someone else, we need to display an error --%>
                    <%
                        for (AssetId id : thisAssetPlusRelativesInDimGroup)
                        {
                            // if the asset is locked by someone else, we need to display an error
                            if ("true".equals(ics.GetVar("doproceed")))
                            {
                                if (isLockedBySomeoneElse(ics, id.getType(), Long.toString(id.getId()), ics.GetSSVar("username")))
                                {
                                    ics.SetVar("doproceed", "CantMakeRootCheckedOutByOther");
                                }
                            }

                            // if the asset is locked by the current user, that's okay, but if not
                            // the user needs to be told to check it out.
                            if ("true".equals(ics.GetVar("doproceed")))
                            {
                                if (!isLockedByMe(ics, id.getType(), Long.toString(id.getId()), ics.GetSSVar("username")))
                                {
                                    ics.SetVar("doproceed", "CantMakeRootNotCheckedOutByCurrentUser");
                                }
                            }
                        }

                    %>
                </ics:then>
            </ics:if>
        </ics:then>
    </ics:if>
</cs:ftcs>

<%!
    private boolean isLockedBySomeoneElse(ICS ics, String c, String cid, String user)
    {
        final boolean result;
        IList history = ics.RTHistory(c, cid, null, null, null, null, "ItsHistory");
        if (history != null && history.hasData() && history.numRows() > 0)
        {
            // just care about the first row
            history.moveTo(1);
            try
            {
                String lockedBy = history.getValue("lockedby");
                result = lockedBy != null && lockedBy.length() > 0 && !user.equals(lockedBy);
            }
            catch (NoSuchFieldException impossible)
            {
                throw new IllegalStateException("Bad list contents for IList - no lockedby column", impossible);
            }
        }
        else
        {
            // not locked
            result = false;
        }
        return result;
    }

    private boolean isLockedByMe(ICS ics, String c, String cid, String user)
    {
        final boolean result;
        IList history = ics.RTHistory(c, cid, null, null, null, null, "ItsHistory");
        if (history != null && history.hasData() && history.numRows() > 0)
        {
            // just care about the first row
            history.moveTo(1);
            try
            {
                String lockedBy = history.getValue("lockedby");
                result = lockedBy.equals(user);
            }
            catch (NoSuchFieldException impossible)
            {
                throw new IllegalStateException("Bad list contents for IList - no lockedby column", impossible);
            }
        }
        else
        {
            // not locked
            result = false;
        }
        return result;
    }
%>
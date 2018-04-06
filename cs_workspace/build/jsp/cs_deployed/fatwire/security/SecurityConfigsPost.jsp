<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/security/SecurityConfigsPost
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Access.*"%>
<%@ page import="com.fatwire.cs.core.security.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.security.*"%>
<%@ page import="com.fatwire.realtime.util.Util"%>
<%@ page import="com.fatwire.assetapi.site.*, com.fatwire.cs.core.security.SecurityManager"%>
<cs:ftcs>
<%
ics.SetVar("userIsGeneralAdmin","false");
%>
<!-- Check if the current user has General Admin role in any one of the publications 
	If so, he can set the security and manage them.
-->
<%
String _pubid = ics.GetSSVar("pubid");
//Allow the access for the management(pubid = 0) site by default
if(!"0".equals(_pubid)){
%>
	<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin">
		<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
	</ics:callelement>
<%	
} else {
	ics.SetVar("userIsGeneralAdmin","true");
}

if("true".equals(ics.GetVar("userIsGeneralAdmin"))){
        UserGroupManager ugm = new UserGroupManagerImpl(ics);
        UserManager um = new UserManagerImpl(ics);
        GroupManager gm = new GroupManagerImpl(ics);
        SecurityManager securityM = new SecurityManagerImpl( ics );
		SiteManager sm = new SiteManagerImpl(ics);
		if(ics.GetVar("pageType") == null){
			ics.SetVar("pageType","front");
		}
		if(ics.GetVar("objectname") == null){%>
		<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
			<ics:argument name="error" value="NoName"/>
        </ics:callelement>            
        <throwexception/>
	<%}
	if("delete".equals(ics.GetVar("action"))){
	%>
		<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
		<tr><td>
			<span class="title-text"><xlat:stream key='dvin/UI/Admin/DeletingSecurityConfiguration'/> : <string:stream value='<%=ics.GetVar("objectname")%>'/></span>
		</td></tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
		</table>	
		<%
		ics.SetVar("errno","0");
		String sitename = ics.GetVar("sitename");
		if(sitename != null && sitename.equals(_showLocaleString(ics,"_ANY_"))){
			sitename = "_ANY_";
		}
		String objecttype = ics.GetVar("objecttype");
		String objectname = ics.GetVar("objectname");
		if(objectname.equals(_showLocaleString(ics,"_ANY_"))){
			objectname = "_ANY_";
		}
		String objectsubtype = ics.GetVar("objectsubtype");
		String configaction = ics.GetVar("configaction");
		
		if ( null != objecttype && null != objectname )
		{
			CSObject cso = new CSObjectImpl( objecttype, objectsubtype, objectname, sitename);
			securityM.setPrivilege( null,ActionEnum.fromString( configaction ),cso );
		}
		//-502(list contains no columns) error can be ignored
		if("-502".equals(ics.GetVar("errno"))){
			ics.SetVar("errno","0");
		}
		if(!"0".equals(ics.GetVar("errno"))){
		%>
			<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
				<ics:argument name="error" value="DeleteFailed"/>
			</ics:callelement>            
		<%} else {%>
			<xlat:lookup key="dvin/UI/Deletesuccessful" encode="false" varname="msg"/>
			<div class="width-outer-70">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
				<ics:argument name="severity" value="info"/>
			</ics:callelement>
			</div><P/>
		<%}
		} else if ("add".equals(ics.GetVar("action")) || "edit".equals(ics.GetVar("action"))){
			String actionsStr = ics.GetVar("configaction");
			List<String> configactions = Arrays.asList( actionsStr.split (";" ));
			for(String _configaction : configactions){
			String sitename = ics.GetVar("sitename");
			if(sitename != null && sitename.equals(_showLocaleString(ics,"_ANY_"))){
				sitename = "_ANY_";
			}
			
			String objectname = ics.GetVar("objectname");
			if(objectname.equals(_showLocaleString(ics,"_ANY_"))){
				objectname = "_ANY_";
			}
			
			String objecttype = ics.GetVar("objecttype");
			//Handle the case when the object type is application
			if("APPLICATION".equals(objecttype)){
				objecttype = "ASSET";
				sitename="AdminSite";
				if("_ANY_".equals(objectname)){
					objectname = "FW_Application";
				} else if(objectname != null && !"".equals(objectname) && objectname.trim().length() !=0) {
					objectname = "FW_Application:" + objectname;
				}
			}
			String objectsubtype = ics.GetVar("objectsubtype");
			String grps = ics.GetVar("groups");
			if ( null != objecttype && null != objectname )
			{
				CSObject cso = new CSObjectImpl( objecttype, objectsubtype, objectname, sitename);
				Set<String> grpSet  = new HashSet<String>();
				if("add".equals(ics.GetVar("action"))){
					//Check if this csobject and the action already exists
					List<String> existingGrps = securityM.getGroups( ActionEnum.fromString( _configaction ), cso );
					if ( existingGrps.size() > 0 )
					{
						grpSet.addAll(existingGrps);
						ics.SetVar("addedToExisting", "true");
					}
				}
				//Add the input groups to the set
				grpSet.addAll(Arrays.asList( grps.split (";" )));
				
				securityM.setPrivilege( new ArrayList<String>(grpSet), ActionEnum.fromString( _configaction ), cso);
			}
		if("edit".equals(ics.GetVar("action"))){
	%>        
		<xlat:lookup key="dvin/UI/Updatesuccessful" encode="false" varname="msg"/>
	<%} else if ("add".equals(ics.GetVar("action"))){
		if("true".equals(ics.GetVar("addedToExisting"))){
		%>
			<xlat:lookup key="dvin/UI/AddsuccessfulToExistingConfig" encode="false" varname="msg" evalall="false">
				<xlat:argument name="cfgaction" value="<%=_showLocaleString(ics,_configaction)%>"/>
			</xlat:lookup>
		<%
		ics.SetVar("addedToExisting", "false");
		}
		else {
		%>
			<xlat:lookup key="dvin/UI/AddsuccessfulForAction" encode="false" varname="msg" evalall="false">
				<xlat:argument name="cfgaction" value="<%=_showLocaleString(ics,_configaction)%>"/>
			</xlat:lookup>
		<%}
	}%>   
	<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="info"/>
	</ics:callelement>
	</div>
	<%}}%>
	<P/>
	<ics:callelement element="fatwire/security/SecurityConfigsFront">
		<ics:argument name="action" value="list"/>
	</ics:callelement>
	<%
}
else {
//Not authorized
%>
<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
	<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
	<ics:argument name="severity" value="error"/>
</ics:callelement>
</div>
<%}%>
<%!
//Server side access for fetching locale strings
public String _showLocaleString(ICS ics,String str){
	if("_ANY_".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Any");
	} else if("SITE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Site");
	} else if("USER".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/User");
	} else if("GROUP".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Admin/Group");
	} else if("ROLE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Role");
	} else if("INDEX".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Admin/Index");
	} else if("ASSET".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Asset");
	} else if("ASSETTYPE".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/AssetTypenospace");
	} else if("APPLICATION".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Application");
	} else if("USERLOCALES".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/UserLocales");
	} else if("USERDEF".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/UserDef");
	} else if("ACL".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/ACLs");
	} else if("CREATE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Create");
	} else if("UPDATE".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Update");
	} else if("DELETE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Delete");
	} else if("READ".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/ReadOrHead");
	} else if("LIST".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/List");
	}else if("ENGAGE".equals(str)){
		return "Engage";
	}else if("VISITOR".equals(str)){
		return "Visitor";
	}
	return null;
}
%>
  </cs:ftcs>
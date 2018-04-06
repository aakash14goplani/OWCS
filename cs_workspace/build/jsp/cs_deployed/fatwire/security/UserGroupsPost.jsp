<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/security/UserGroups
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
<%@ page import="com.fatwire.assetapi.site.*"%>
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
        
	if(ics.GetVar("username") == null){%>
		<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
			<ics:argument name="error" value="NoName"/>
        </ics:callelement>            
        <throwexception/>
	<%}
	if("delete".equals(ics.GetVar("action"))){
	%>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key='dvin/UI/Admin/DeletingUserGroupForUser'/> : <string:stream value='<%=ics.GetVar("username")%>'/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
		<%
		ics.SetVar("errno","0");
		ugm.removeUserGroups(ics.GetVar("username"));
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
		<%}%>
		<ics:callelement element="fatwire/security/UserGroupsFront">
			<ics:argument name="action" value="list"/>
		</ics:callelement>
    <%} else if ("add".equals(ics.GetVar("action")) || "edit".equals(ics.GetVar("action"))){
			String users = ics.GetVar("username");
			String[] userArray = users.split(";");
			for (String user : userArray) {
				String grps = ics.GetVar("groups");
				if(null != grps && grps.length() > 0){
					ugm.assignUserGroups( user, Arrays.asList( grps.split( ";" )));
				} else {
					ugm.assignUserGroups( user, null);
				}
			}
		if("edit".equals(ics.GetVar("action"))){
	%>  
		<xlat:lookup key="dvin/UI/Updatesuccessful" encode="false" varname="msg"/>
	<%} else if ("add".equals(ics.GetVar("action"))){%>
		<xlat:lookup key="dvin/UI/Addsuccessful" encode="false" varname="msg"/>
	<%}%>
		<div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
			<ics:argument name="severity" value="info"/>
		</ics:callelement>
		</div>
		<P/>
		<ics:callelement element="fatwire/security/UserGroupsFront">
			<ics:argument name="action" value="list"/>
		</ics:callelement>
	<%}
	String proptreetype = ics.GetProperty("xcelerate.treeType","futuretense_xcel.ini",true);
	if(ics.IsElement("OpenMarket/Xcelerate/UIFramework/UpdateTree" + proptreetype)){
	%>
		<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + proptreetype%>'>
			<ics:argument name="__TreeRefreshKeys__" value="Self:Security:UserGroups"/>
		</ics:callelement>
	<%
	}
} else {
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
</cs:ftcs>
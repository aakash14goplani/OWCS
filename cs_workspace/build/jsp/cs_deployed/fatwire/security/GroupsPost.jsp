<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/security/GroupsPost
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
<cs:ftcs>
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<string:encode variable="cs_environment" varname="cs_environment"/>
<string:encode variable="cs_formmode" varname="cs_formmode"/>
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

if("true".equals(ics.GetVar("userIsGeneralAdmin"))){%>
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS"/>
    <%
        GroupManager gm = new GroupManagerImpl(ics);	
		
	 if(ics.GetVar("groupname") == null){%>
		<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
			<ics:argument name="error" value="NoName"/>
        </ics:callelement>            
        <throwexception/>
	<%}
	if("delete".equals(ics.GetVar("action"))){
	List<String> groupsList = new ArrayList<String>();
	groupsList.add(ics.GetVar("groupname"));
	%>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key='dvin/UI/Admin/DeletingGroup'/> : <string:stream value='<%=ics.GetVar("groupname")%>'/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>	
		<%
		ics.SetVar("errno","0");
		gm.removeGroups(groupsList);
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
		<%}%>
		<ics:callelement element="fatwire/security/GroupsFront">
			<ics:argument name="action" value="list"/>
			<ics:argument name="pageType" value="front"/>
		</ics:callelement>
    <%} else if ("add".equals(ics.GetVar("action"))){
		if(gm.exist(ics.GetVar("groupname"))){%>
		<xlat:lookup key="dvin/UI/Admin/Error/AlreadyExistingGroup" encode="false" varname="msg"/>
		<div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
			<ics:argument name="severity" value="error"/>
		</ics:callelement>
		</div>
		<%} else { 
			List<Group> groupsList = new ArrayList<Group>();
			groupsList.add(new GroupImpl(ics.GetVar("groupname"),ics.GetVar("description")));
			gm.addGroups(groupsList);
		%>
		<xlat:lookup key="dvin/UI/Addsuccessful" encode="false" varname="msg"/>
		<div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
			<ics:argument name="severity" value="info"/>
		</ics:callelement>
		</div>
		<%
		}%>
		<P/>        
	    <ics:callelement element="fatwire/security/GroupsFront">
			<ics:argument name="action" value="list"/>
			<ics:argument name="pageType" value="front"/>
		</ics:callelement>
	<%} else if("edit".equals(ics.GetVar("action"))){
			ics.SetVar("errno","0");
			gm.updateGroup(new GroupImpl(ics.GetVar("groupname"),ics.GetVar("description")));
			if(!"0".equals(ics.GetVar("errno"))){
			%>
				<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
					<ics:argument name="error" value="UpdateFailed"/>
				</ics:callelement>            
			<%} else {%>
				<xlat:lookup key="dvin/UI/Updatesuccessful" encode="false" varname="msg"/>
				<div class="width-outer-70">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
						<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
						<ics:argument name="severity" value="info"/>
					</ics:callelement>
				</div><P/>
			<%}%>
			<ics:callelement element="fatwire/security/GroupsFront">
				<ics:argument name="action" value="inspect"/> 
				<ics:argument name="pageType" value="front"/>
			</ics:callelement>
	<%}
	String proptreetype = ics.GetProperty("xcelerate.treeType","futuretense_xcel.ini",true);
	if(ics.IsElement("OpenMarket/Xcelerate/UIFramework/UpdateTree" + proptreetype)){
	%>
		<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + proptreetype%>'>
			<ics:argument name="__TreeRefreshKeys__" value="Self:Security:Groups"/>
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
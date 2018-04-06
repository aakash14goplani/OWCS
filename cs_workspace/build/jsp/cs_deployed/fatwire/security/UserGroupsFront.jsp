<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/security/UserGroupsFront
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
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<string:encode variable="cs_environment" varname="cs_environment"/>
<string:encode variable="cs_formmode" varname="cs_formmode"/>
<script LANGUAGE="JavaScript">
function checkGroups()
{
	var obj = document.forms['0'];
	if (obj.elements['groups'].selectedIndex == -1)
	{
		alert('<xlat:stream key="dvin/UI/Admin/Error/mustspecifygroups" encode="false" escape="true"/>');
		obj.elements['groups'].focus();
		return false;
	}
	return true;
}
</script>
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
        
		if("list".equals(ics.GetVar("action"))){
		Map<String,List<String>> userGroups = new TreeMap<String,List<String>>(String.CASE_INSENSITIVE_ORDER);
		userGroups.putAll(ugm.listUserGroups());
    %>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/UserGroups"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
					<tr>
						<td></td><td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
					</tr>
					<tr>
						<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
						<td >
							<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff"><tr><td colspan="7" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>
							<tr><td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
					            	<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif" NOWRAP="TRUE">
	                                                <DIV class="new-table-title"><xlat:stream key="dvin/UI/UserName"/></DIV></td>
		  					<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	                                                <DIV class="new-table-title"><xlat:stream key="dvin/TreeApplet/SecurityGroups"/></DIV></td>
								<td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
							</tr>
							<tr><td colspan="7" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>

					   		<%
							ics.SetVar("rowStyle","tile-row-normal");
							ics.SetVar("separatorLine","0");
							if(userGroups.size() == 0){%>
							<tr>
											<td><BR/></td><td colspan="5" style="height:25px;text-align:center;"><xlat:stream key="dvin/UI/Admin/NoUserGroupsAvailable"/></td><td><BR/></td>
										</tr>
							<%}
							for(Map.Entry<String,List<String>> entry : userGroups.entrySet()){
								if("1".equals(ics.GetVar("separatorLine"))){
							%>
							<%--<tr>
											<td colspan="7" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
										</tr>--%>
								<%}
								ics.SetVar("separatorLine","1");
								%>
								<tr class='<%=ics.GetVar("rowStyle")%>'><td><BR /></td>
									<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
									<xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
									<xlat:lookup key="dvin/UI/Admin/InspectThisUGConfig" varname="_alt_"/>
									<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
											<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
							                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
                                            <satellite:argument name="action" value="inspect"/>
				                            <satellite:argument name="username" value='<%=entry.getKey()%>'/>
                                	</satellite:link>
									<A HREF='<%=ics.GetVar("urlusergrps")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContent.gif'  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
										<xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/><xlat:lookup key="dvin/UI/Admin/EditThisUGConfig" varname="_alt_"/>
										<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
											<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
							                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
                                            <satellite:argument name="action" value="edit"/>
				                            <satellite:argument name="username" value='<%=entry.getKey()%>'/>
                                		</satellite:link>
							                        <A HREF='<%=ics.GetVar("urlusergrps")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContent.gif'  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
										
										<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/><xlat:lookup key="dvin/UI/Admin/DeleteThisUGConfig" varname="_alt_"/>
										<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlsecuritygrps">
                        					<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
							                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
                                            <satellite:argument name="action" value="confirmdelete"/>
				                            <satellite:argument name="username" value='<%=entry.getKey()%>'/>
										</satellite:link>
                        							<A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif"  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
								
										</td>
								                <td><BR /></td><td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
					                			<DIV class="small-text-inset">
													<%=entry.getKey()%>
												</DIV>
										</td>
										<td><BR /></td><td VALIGN="TOP" ALIGN="LEFT">
										<DIV class="small-text-inset">
										<%=_toCommaString((List<String>)entry.getValue())%>
										</DIV>
										</td>
							                 	<td><BR /></td></tr>
							<%if("tile-row-normal".equals(ics.GetVar("rowStyle"))){
								ics.SetVar("rowStyle","tile-row-highlight");
							} else {
								ics.SetVar("rowStyle","tile-row-normal");
							}
							}%>
							</table>
						</td>
						<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
						</tr>
					<tr>
					<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
					</tr>
					<tr>
					<td></td><td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif"><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
					</tr>
					</table>
					<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
						<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
                        <satellite:argument name="action" value="new"/>
                    </satellite:link>
	<div class="width-outer-70">
		<A HREF='<%=ics.GetVar("urlusergrps")%>'><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddNew"/></ics:callelement></A>
	</div><P/>
<%} else if("new".equals(ics.GetVar("action"))){
List<String> usernames = um.list();
//Sort the usernames
Collections.sort(usernames,String.CASE_INSENSITIVE_ORDER);
//Remove the users which already have group assigned
Map<String,List<String>> userGroups = ugm.listUserGroups();
for(Map.Entry<String,List<String>> entry : userGroups.entrySet()){
	usernames.remove(entry.getKey());
}
List<Group> groups = gm.list();
//Sort the groups
Collections.sort(groups,new GroupNameComparator());
%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/AssignGroupsToUser"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
	<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
        <satellite:argument name="action" value="list"/>
    </satellite:link>
    <table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
					<span class="alert-color">*</span><xlat:stream key="dvin/UI/UserName"/>:
				</td>
				<td class="form-inset">
						
							<%
							if(usernames.size() != 0){
							%>
								<select name='username' size="5" multiple>
							<%
								for( String username : usernames )
								   {
								%>
								<option value='<%=username%>'><%=username%></option>
								<%
								   }
								   %>
								   </select>
								   <%
							} else {
								%>
								<input type="hidden" name="username" value=""/>
								<xlat:lookup key="dvin/UI/UsersNotAvailable" varname="_XLAT_" escape="true"/>
								<div class="width-outer-70">
								<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
									<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_")%>'/>
									<ics:argument name="severity" value="warning"/>
								</ics:callelement>
								</div>
								<%
							}
							%>
						</select> 
				</td><td><BR /></td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>	
			<tr>
				<td class="form-label-text" NOWRAP="NOWRAP">
					<span class="alert-color">*</span><xlat:stream key='dvin/TreeApplet/SecurityGroups'/>:
				</td>
				<td class="form-inset">
                  	   <%if(groups.size() != 0){%>  
						   <select name='groups' size="5" style="width:220px;" MULTIPLE>
								<%
									for( Group g : groups)
									{
								%>
								<option value='<%=g.getName()%>'><%=g.getName()%></option>
								<%
									}
								%>
							</select>
						<%} else {%>
							<input type="hidden" name="groups" value=""/>
								<xlat:lookup key="dvin/UI/GroupsNotAvailable" varname="_XLAT_" escape="true"/>
							<div class="width-outer-70">
								<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
								<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_")%>'/>
								<ics:argument name="severity" value="warning"/>
								</ics:callelement>
							</div>
						<%}%>
				</td>
			</tr>
			
			<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
				<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
				<satellite:argument name="action" value="list"/>
			</satellite:link >
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
			<TR>
			<TD class="form-label-text"></TD><TD class="form-inset">
				<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
				<A HREF='<%=ics.GetVar("urlusergrps")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
				<xlat:lookup key="dvin/UI/AddGroup" varname="_XLAT_" escape="true"/>
				<input type="hidden" name="pagename" value="fatwire/security/UserGroupsPost"/> 
				<input type="hidden" name="action" value="add"/>
				<%if(usernames.size() > 0 && groups.size() > 0){%> 
				<A HREF="javascript:void(0);" onClick="if(checkGroups()!=false){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A>
				<%}%>
		</TD></TR>
			
			</table>
	</td></tr>
</table>
<P/><P/>

<%} else if("confirmdelete".equals(ics.GetVar("action"))) {
List<String> usergroups = new ArrayList<String>();
try{
	usergroups.addAll(ugm.getUserGroups(ics.GetVar("username")));
} catch(Exception ex){
	//if there is a exception here that means probably user has been deleted 
	//from the system.
}

%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/RemoveUserGroups"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
	  <%if(usergroups.size() > 1){%>
		<xlat:lookup key="dvin/UI/Admin/DeleteUserFromGroups" encode="false" evalall="false" varname="deletemessage">
			<xlat:argument name="uname" value='<%=ics.GetVar("username")%>'/>
		</xlat:lookup>
	  <%} else {%>
		<xlat:lookup key="dvin/UI/Admin/DeleteUserFromGroup" encode="false" evalall="false" varname="deletemessage">
			<xlat:argument name="uname" value='<%=ics.GetVar("username")%>'/>
			<xlat:argument name="gname" value='<%=usergroups.get(0)%>'/>
		</xlat:lookup>
	  <%}%>
	<div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=ics.GetVar("deletemessage")%>'/>
			<ics:argument name="severity" value="warning"/>
		</ics:callelement>							
	</div>					
							
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" NOWRAP="TRUE">
					<xlat:stream key="dvin/UI/UserName"/>:
				</td>
				<td class="form-inset">
					<INPUT TYPE="HIDDEN" NAME="username" VALUE="<string:stream value='<%=ics.GetVar("username")%>'/>"/>
					<string:stream variable="username"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
					<xlat:stream key="dvin/TreeApplet/SecurityGroups"/>:
				</td>
				<td class="form-inset">
					<%=_toCommaString(usergroups)%>
				</td>
			</tr>
			<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="fatwire/security/UserGroupsPost"/>
		<INPUT TYPE="HIDDEN" NAME="action" VALUE="delete"/>
			<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
				<satellite:argument name="action" value="list"/>
			</satellite:link >    

		<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
		<xlat:lookup key="dvin/UI/Cancel" varname="_ALT_"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
		<TR>
			<TD class="form-label-text"></TD><TD class="form-inset">
				<A HREF='<%=ics.GetVar("urlusergrps")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
				<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
				<xlat:lookup key="dvin/Common/Delete" varname="_ALT_"/>
				<A HREF="javascript:void(0);" onclick="document.forms['AppForm'].submit(); return false;" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Delete"/></ics:callelement></A>
		</TD></TR>
			
		</table>
	</td></tr>
</table>



<%} else if("edit".equals(ics.GetVar("action"))){
List<Group> groups = gm.list();
//Sort the groups
Collections.sort(groups,new GroupNameComparator());
List<String> usergroups = new ArrayList<String>();
try{
	usergroups.addAll(ugm.getUserGroups(ics.GetVar("username")));
} catch(Exception ex){
	//if there is a exception here that means probably user has been deleted 
	//from the system.
	groups.clear();
}
%>
	  		<INPUT TYPE="HIDDEN" NAME="username" VALUE="<string:stream value='<%=ics.GetVar("username")%>'/>"/>
			<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
				<tr><td>
					<span class="title-text"><xlat:stream key="dvin/UI/Admin/EditUserGroups"/></span>
				</td></tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
			</table>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" NOWRAP="TRUE">
					<xlat:stream key="dvin/UI/UserName"/>:
				</td>
				<td class="form-inset">
					<string:stream variable="username"/>
				</td><td><BR /></td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" NOWRAP="NOWRAP">
					<span class="alert-color">*</span><xlat:stream key="dvin/TreeApplet/SecurityGroups"/>:
				</td>
				<td class="form-inset">
					<%if(groups.size() != 0){%>
					   <select name='groups' size="5" style="width:220px;" MULTIPLE>
							<%
								for(Group group:groups)
								{
								String grp = group.getName();
								if(usergroups.contains(grp)){
							%>
							<option value='<%=grp%>' selected><%=grp%></option>
							<%
							  }else{%>
							<option value='<%=grp%>'><%=grp%></option>
							  <%}
							 }
							%>
						</select> 
						<%} else {%>
							<input type="hidden" name="groups" value=""/>
								<xlat:lookup key="dvin/UI/GroupsNotAvailable" varname="_XLAT_" escape="true"/>
							<div class="width-outer-70">
								<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
								<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_")%>'/>
								<ics:argument name="severity" value="warning"/>
								</ics:callelement>
							</div>
						<%}%>
				</td>
			</tr>
			
			<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="fatwire/security/UserGroupsPost"/>                
			<INPUT TYPE="HIDDEN" NAME="action" VALUE="edit"/>
			<satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
					<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
					<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
					<satellite:argument name="action" value="list"/>
				</satellite:link >    

			<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
			<xlat:lookup key="dvin/UI/Cancel" varname="_ALT_"/>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
			<TR>
				<TD class="form-label-text"></TD><TD class="form-inset">
					<A HREF='<%=ics.GetVar("urlusergrps")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='<%=ics.GetVar("_XLAT_")%>';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
					<xlat:lookup key="dvin/UI/Save" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Save" varname="_ALT_"/>
					<%if(groups.size() != 0){%> 
					<A HREF="javascript:void(0);" onClick="if(checkGroups()!=false){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A><%}%>
			</TD></TR>
						
			</table>
	</td></tr>
</table>

<%} else if("inspect".equals(ics.GetVar("action"))){
		List<String> usergroups = new ArrayList<String>();
		try{
			usergroups.addAll(ugm.getUserGroups(ics.GetVar("username")));
		} catch(Exception ex){
			//if there is a exception here that means probably user has been deleted 
			//from the system.
		}
%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/UserGroup"/> : <string:stream variable="username"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30 margin-top-zero">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<tr>
				<td class="form-label-text" colspan="3">
				<table class="legacyAbar" border="0" cellpadding="0" cellspacing="0">
				<tr>

	    <!-- construct encoded urls -->
            <ics:encode base="ContentServer" session="true" output="inspect">
                <ics:argument name="pagename" value="fatwire/security/UserGroupsFront"/>
                <ics:argument name="action" value="inspect"/>
                <ics:argument name="username" value='<%=ics.GetVar("username")%>'/>
            </ics:encode>
            <ics:encode base="ContentServer" session="true" output="edit">
                <ics:argument name="pagename" value="fatwire/security/UserGroupsFront"/>
                <ics:argument name="action" value="edit"/>
                <ics:argument name="username" value='<%=ics.GetVar("username")%>'/>
            </ics:encode>
            <ics:encode base="ContentServer" session="true" output="delete">
                <ics:argument name="pagename" value="fatwire/security/UserGroupsFront"/>
                <ics:argument name="action" value="confirmdelete"/>
                <ics:argument name="username" value='<%=ics.GetVar("username")%>'/>
            </ics:encode>

					<td><xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/InspectThisUGConfig" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("inspect")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContentUp.gif'  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("inspect")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Inspect"/></span></A></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/EditThisUGConfig" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("edit")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContentUp.gif" hspace="2" border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("edit")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Edit"/></span></A></td>

	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>

					<td><xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/DeleteThisUGConfig" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("delete")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContentUp.gif" hspace="2" border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("delete")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Delete"/></span></A></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>
				</td>
			</tr></table>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<%--<tr>
				<td colspan="2" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" NOWRAP="TRUE"><xlat:stream key="dvin/UI/UserName"/>:</td>
				<td class="form-inset">
					<string:stream variable="username"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="2" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" WIDTH="30%"><xlat:stream key="dvin/TreeApplet/SecurityGroups"/>:</td>
				<td class="form-inset" WIDTH="70%">
					<%=_toCommaString(usergroups)%>
				</td>
			</tr>
			</table>

	</td></tr>
</table>
    <satellite:link assembler="query" pagename="fatwire/security/UserGroupsFront" outstring="urlusergrps">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
	</satellite:link >   
<DIV class="width-outer-70"><A HREF='<%=ics.GetVar("urlusergrps")%>'><IMG src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif" WIDTH="15" HEIGHT="12" BORDER="0"/><xlat:stream key="dvin/UI/Admin/Listallusergroups"/></A>
</DIV><P/>
<%}
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
<%!
public String _toCommaString(List<String> groups)
    {
        boolean needComma = false;
        StringBuilder sb = new StringBuilder();
        for( String group: groups)
        {
            if ( needComma )
            {
                sb.append(",");
            }
            else
            {
                needComma = true;
            }
            sb.append("'").append(group).append("'");
        }
        return sb.toString();
    }

private class GroupNameComparator implements Comparator {
  public int compare(Object group, Object anotherGroup) {
    String desc1 = (((Group) group).getDescription()).toLowerCase();
    String name1 = (((Group) group).getName()).toLowerCase();
    String desc2 = (((Group) anotherGroup).getDescription()).toLowerCase();
    String name2 = (((Group) anotherGroup).getName()).toLowerCase();
	desc1 = (desc1 == null)? ""  : desc1;
	name1 = (name1 == null)? ""  : name1;
	desc2 = (desc2 == null)? ""  : desc2;
	name2 = (name2 == null)? ""  : name2;
    if (!(name1.equals(name2)))
      return name1.compareTo(name2);
    else
      return desc1.compareTo(desc2);
  }
}
%>
  </cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/security/GroupsFront
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
<script LANGUAGE="JavaScript">
function checkfields()
{
	var obj = document.forms['0'];
	var isclean = isCleanString(obj.elements['groupname'].value);	
	if (!isclean) {
		alert('<xlat:stream key="dvin/FlexibleAssets/Attributes/ApostropheNotAllowed" encode="false" escape="true"/>');
		return false;
	}
	if ( (obj.elements['groupname'].value.length == 0) ||
		 (obj.elements['groupname'].value.match(/^[\s]/) != null) ) {
	
	//Here means something is wrong, let us figure out what
	
			if (obj.elements['groupname'].value.length == 0) {
				alert('<xlat:stream key="dvin/UI/Admin/Error/Youmustspecifyanameforthisgroup" encode="false" escape="true"/>');
			}
			
			if ( obj.elements['groupname'].value.match(/^[\s]/) != null ) {
				alert('<xlat:stream key="dvin/UI/Admin/Error/Groupnamescannotstartwithaspace" encode="false" escape="true"/>');
			}
			obj.elements['groupname'].focus();
			return false;
	}
	if (obj.elements['description'].value=="")
	{
		alert('<xlat:stream key="dvin/UI/Admin/Error/mustspecifydescriptiongroup" encode="false" escape="true"/>');
		obj.elements['description'].focus();
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

if("true".equals(ics.GetVar("userIsGeneralAdmin"))){%>
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS"/>
    <%
        GroupManager gm = new GroupManagerImpl(ics);		
        if("list".equals(ics.GetVar("action"))){
		if(ics.GetVar("orderby") == null){
			ics.SetVar("orderby","groupname");
		}
		List<Group> groups = gm.list();
		if(ics.GetVar("orderby") == null || "groupname".equals(ics.GetVar("orderby"))){
			Collections.sort(groups, new GroupNameComparator());
		} else {
			Collections.sort(groups, new GroupDescriptionComparator());
		}

    %>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/TreeApplet/SecurityGroups"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-50">
					<tr>
						<td></td><td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
					</tr>
					<tr>
						<td class="tile-dark" WIDTH="1" NOWRAP="nowrap"><BR /></td>
						<td >
							<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff"><tr><td colspan="7" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>
							<tr><td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
					            	<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	                                                <satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
        	                                            <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
                	                                    <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
														<satellite:argument name="action" value="list"/>
														<satellite:argument name="orderby" value="groupname"/>
                                                    </satellite:link>
	                                                <A HREF='<%=ics.GetVar("urlsecuritygrps")%>'><DIV class="new-table-title"><xlat:stream key="dvin/Common/Name"/></DIV></A></td>
		  					<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	                                                <satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
        	                                            <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
                	                                    <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
														<satellite:argument name="action" value="list"/>
														<satellite:argument name="orderby" value="description"/>
                                                    </satellite:link>
	                                                <A HREF='<%=ics.GetVar("urlsecuritygrps")%>'><DIV class="new-table-title"><xlat:stream key="dvin/Common/Description"/></DIV></A></td>
								<td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
							</tr>
							<tr><td colspan="7" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>

					   		<%
							ics.SetVar("rowStyle","tile-row-normal");
							ics.SetVar("separatorLine","0");
							if(groups.size() == 0){%>
							<tr>
											<td><BR/></td><td colspan="5" style="height:25px;text-align:center;"><xlat:stream key="dvin/UI/Admin/NoGroupsAvailable"/></td><td><BR/></td>
										</tr>
							<%}
							for(Group group : groups){
								if("1".equals(ics.GetVar("separatorLine"))){
							%>
									<%--<tr>
											<td colspan="7" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
										</tr>--%>
								<%}
								ics.SetVar("separatorLine","1");
								%>
								<tr class='<%=ics.GetVar("rowStyle")%>'><td><BR /></td>
									<td NOWRAP="NOWRAP" ALIGN="LEFT">
									<xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
									<xlat:lookup key="dvin/UI/Admin/InspectThisGroup" varname="_alt_"/>
									<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
											<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
							                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
                                            <satellite:argument name="action" value="inspect"/>
				                            <satellite:argument name="groupname" value='<%=group.getName()%>'/>
                                	</satellite:link>
									<A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContent.gif'  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
										<xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/><xlat:lookup key="dvin/UI/Admin/EditThisGroup" varname="_alt_"/>
										<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
											<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
							                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
                                            <satellite:argument name="action" value="edit"/>
				                            <satellite:argument name="groupname" value='<%=group.getName()%>'/>
                                		</satellite:link>
							                        <A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContent.gif'  border="0" title='<%=ics.GetVar("_alt_")%>'  alt='<%=ics.GetVar("_alt_")%>'/></A>
										
										<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/><xlat:lookup key="dvin/UI/Admin/DeleteThisGroup" varname="_alt_"/>
										<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
                        					<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
							                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
                                            <satellite:argument name="action" value="confirmdelete"/>
				                            <satellite:argument name="groupname" value='<%=group.getName()%>'/>
										</satellite:link>
                        							<A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif"  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
								
										</td>
								                <td><BR /></td><td NOWRAP="NOWRAP" ALIGN="LEFT">
					                			<DIV class="small-text-inset">
													<string:stream value='<%=group.getName()%>'/>
												</DIV>
										</td>
										<td><BR /></td><td ALIGN="LEFT">
										<DIV class="small-text-inset">
										<string:stream value='<%=group.getDescription()%>'/>
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
						<td class="tile-dark" WIDTH="1" NOWRAP="nowrap"><BR /></td>
						</tr>
					<tr>
					<td colspan="3" class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
					</tr>
					<tr>
					<td></td><td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif"><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
					</tr>
					</table>
					<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
						<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
                        <satellite:argument name="action" value="new"/>
                    </satellite:link>
	<div class="width-outer-70">
	<A HREF='<%=ics.GetVar("urlsecuritygrps")%>'><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddNew"/></ics:callelement></A>
	</div><P/>
<%} else if("new".equals(ics.GetVar("action"))){%>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/AddNewGroup"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
        <satellite:argument name="action" value="list"/>
    </satellite:link>
    <table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td class="form-label-text"><span class="alert-color">*</span><xlat:stream key="dvin/AT/Common/Name"/>:
				</td>
				<td VALIGN="TOP" class="form-inset">
						<INPUT TYPE="TEXT" SIZE="32" MAXLENGTH="32" NAME="groupname" VALUE=""/>
				</td><td><BR /></td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/AT/Common/Description'/>:
				</td>
				<td VALIGN="TOP" class="form-inset">
                  	   <INPUT TYPE="TEXT" SIZE="32" MAXLENGTH="255" NAME="description" VALUE=""/>
				</td>
			</tr>
			
			<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
			<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
			<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
			<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
			<satellite:argument name="action" value="list"/>
		</satellite:link >
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
		<TR>
			<TD class="form-label-text"></TD><TD class="form-inset">
				<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
				<A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
				<xlat:lookup key="dvin/UI/AddGroup" varname="_XLAT_" escape="true"/>
				<input type="hidden" name="pagename" value="fatwire/security/GroupsPost"/> 
				<input type="hidden" name="action" value="add"/>				
				<A HREF="javascript:void(0);" onClick="if(checkfields()!=false){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A>
		</TD></TR>
			
			</table>

	</td></tr>
	</table>

<%} else if("confirmdelete".equals(ics.GetVar("action"))) {
List<String> groupsList = new ArrayList<String>();
groupsList.add(ics.GetVar("groupname"));
List<Group> groups = gm.getGroups(groupsList);
//There is only one group
Group group = (Group)groups.get(0);
ics.SetVar("groupdescription",group.getDescription());
%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/DeleteGroup"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
	  	<xlat:lookup key="dvin/UI/Admin/DeleteGroupWarning" encode="false" varname="deletemessage"/>
		<div class="width-outer-70">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="msgtext" value='<%=ics.GetVar("deletemessage")%>'/>
				<ics:argument name="severity" value="warning"/>
			</ics:callelement>	
		</div>						
							
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">		
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Name"/>:
				</td>
				<td VALIGN="TOP" class="form-inset">
						<INPUT TYPE="HIDDEN" NAME="groupname" VALUE="<string:stream value='<%=ics.GetVar("groupname")%>'/>"/>
						<string:stream variable="groupname"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Description"/>:
				</td>
				<td VALIGN="TOP" class="form-inset">
						<string:stream variable="groupdescription"/>
				</td>
			</tr>
			
			<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="fatwire/security/GroupsPost"/>
			<INPUT TYPE="HIDDEN" NAME="action" VALUE="delete"/>
				<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
					<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
					<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
					<satellite:argument name="action" value="list"/>
				</satellite:link >    

			<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
			<xlat:lookup key="dvin/UI/Cancel" varname="_ALT_"/>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
			<TR>
				<TD class="form-label-text"></TD><TD class="form-inset">
					<A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
					<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/Common/Delete" varname="_ALT_"/>
					<A HREF="javascript:void(0);" onclick="document.forms['AppForm'].submit(); return false;" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Delete"/></ics:callelement></A>
				</TD>
			</TR>
			
		</table>
	</td></tr>
</table>


<%} else if("edit".equals(ics.GetVar("action"))){
List<String> groupsList = new ArrayList<String>();
groupsList.add(ics.GetVar("groupname"));
List<Group> groups = gm.getGroups(groupsList);
//There is only one group
Group group = (Group)groups.get(0);
ics.SetVar("groupdescription",group.getDescription());
%>
	  		<INPUT TYPE="HIDDEN" NAME="groupname" VALUE="<string:stream value='<%=ics.GetVar("groupname")%>'/>"/>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/EditGroup"/>: <string:stream variable="groupdescription"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>			

<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Name"/>:
				</td>
				<td VALIGN="TOP" class="form-inset">
						<string:stream variable="groupname"/>
				</td><td><BR /></td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key="dvin/AT/Common/Description"/>:
				</td>
				<td VALIGN="TOP" class="form-inset">
						<string:encode variable="groupdescription" varname="OutputQString"/>
                  	   <INPUT TYPE="TEXT" SIZE="32" MAXLENGTH="255" NAME="description" VALUE='<%=ics.GetVar("OutputQString")%>'/>
				</td>
			</tr>
			
			<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="fatwire/security/GroupsPost"/>                
			<INPUT TYPE="HIDDEN" NAME="action" VALUE="edit"/>
			<satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
			<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
			<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
			<satellite:argument name="action" value="inspect"/> 
			<satellite:argument name="groupname" value='<%=group.getName()%>'/>
		  </satellite:link >    

			<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
			<xlat:lookup key="dvin/UI/Cancel" varname="_ALT_"/>
			
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
			<TR>
				<TD class="form-label-text"></TD><TD class="form-inset">
					<A HREF='<%=ics.GetVar("urlsecuritygrps")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='<%=ics.GetVar("_XLAT_")%>';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
					<xlat:lookup key="dvin/UI/Save" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Save" varname="_ALT_"/>
					<A HREF="javascript:void(0);" onClick="if(checkfields()!=false){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A><P/>
				</TD>
			</TR>
			
			</table>
	</td></tr>
</table>


<%} else if("inspect".equals(ics.GetVar("action"))){
		List<String> groupsList = new ArrayList<String>();
	groupsList.add(ics.GetVar("groupname"));
	List<Group> groups = gm.getGroups(groupsList);
	//There is only one group
	Group group = (Group)groups.get(0);
	if(group.getDescription() == null){
		ics.SetVar("groupdescription","");
	} else {
		ics.SetVar("groupdescription",group.getDescription());
		ics.SetVar("groupname",group.getName());
	}
%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/Group"/>: <string:stream variable="groupname"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
		<tr><td>
		<table border="0" cellpadding="0" cellspacing="0" class="legacyAbar">
				<tr>

	    <!-- construct encoded urls -->
            <ics:encode base="ContentServer" session="true" output="inspect">
                <ics:argument name="pagename" value="fatwire/security/GroupsFront"/>
                <ics:argument name="action" value="inspect"/>
                <ics:argument name="groupname" value='<%=ics.GetVar("groupname")%>'/>
            </ics:encode>
            <ics:encode base="ContentServer" session="true" output="edit">
                <ics:argument name="pagename" value="fatwire/security/GroupsFront"/>
                <ics:argument name="action" value="edit"/>
                <ics:argument name="groupname" value='<%=ics.GetVar("groupname")%>'/>
            </ics:encode>
            <ics:encode base="ContentServer" session="true" output="delete">
                <ics:argument name="pagename" value="fatwire/security/GroupsFront"/>
                <ics:argument name="action" value="confirmdelete"/>
                <ics:argument name="groupname" value='<%=ics.GetVar("groupname")%>'/>
            </ics:encode>

					<td><xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/InspectThisGroup" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("inspect")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContentUp.gif'  border="0" title='<%=ics.GetVar("_alt_")%>'  alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("inspect")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Inspect"/></span></A></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/EditThisGroup" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("edit")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContentUp.gif" hspace="2" border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("edit")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Edit"/></span></A></td>

	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>

					<td><xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/DeleteThisGroup" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("delete")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContentUp.gif" hspace="2" border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("delete")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Delete"/></span></A></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table></td>
			</tr></table>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Name"/>:</td>
				<td VALIGN="TOP" class="form-inset">
						<string:stream variable="groupname"/>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Description"/>:</td>
				<td class="form-inset">
						<string:stream variable="groupdescription"/>
				</td>
			</tr>
			</table>
	</td></tr>
</table>

    <satellite:link assembler="query" pagename="fatwire/security/GroupsFront" outstring="urlsecuritygrps">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
	</satellite:link >   
<DIV class="width-outer-70"><A HREF='<%=ics.GetVar("urlsecuritygrps")%>'><IMG src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif" WIDTH="15" HEIGHT="12" BORDER="0"/><xlat:stream key="dvin/UI/Admin/Listallgroups"/></A>
</DIV>
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

private class GroupDescriptionComparator implements Comparator {
  public int compare(Object group, Object anotherGroup) {
    String desc1 = (((Group) group).getDescription()).toLowerCase();
    String name1 = (((Group) group).getName()).toLowerCase();
    String desc2 = (((Group) anotherGroup).getDescription()).toLowerCase();
    String name2 = (((Group) anotherGroup).getName()).toLowerCase();
	desc1 = (desc1 == null)? ""  : desc1;
	name1 = (name1 == null)? ""  : name1;
	desc2 = (desc2 == null)? ""  : desc2;
	name2 = (name2 == null)? ""  : name2;
    if (!(desc1.equals(desc2)))
      return desc1.compareTo(desc2);
    else
      return name1.compareTo(name2);
  }
}
%>
  </cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/systemtools/SystemInfo/DBInfo
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
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.fatwire.cs.systemtools.systeminfo.DBInfo" %>
<%@ page import="java.util.Map" %>
<%
final String VAR_REQHANDLERURL = "requestURL";
%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
	// String defaultLocale = ics.GetSSVar("locale");
	String defaultLocale = "en_US";
%>
<satellite:link assembler="query" pagename='fatwire/systemtools/SystemInfo/Download' outstring="createZipURL" />
<satellite:link assembler="query" pagename='fatwire/systemtools/SystemInfo/DisplayDBResults' outstring='<%= VAR_REQHANDLERURL%>' />
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/content.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css"/>
</ics:callelement>
<script language="JavaScript" src='<%=request.getContextPath()%>/js/prototype.js'></script>
<script type="text/javascript">
	   function check_before_submit(download)
	   {
		var elem = document.forms[0].elements;
		var sel = false;
		for(var i=0;i<elem.length;i++) {
			 if(elem[i].name.indexOf('sFromDBtables') != -1) {
				var target = elem[i];
				for(k=0;k<target.options.length;k++) {
				     if (target.options[k].selected) {
						sel = true;
						break;
					 }
				   }
			 }
		}
		if(sel) {
				if(download === 'false')
				{
					document.forms[0].action = '<%= ics.GetVar(VAR_REQHANDLERURL) %>';
					document.forms[0].submit();
				}
				else
					execute('<%=ics.GetVar("createZipURL")%>','dbInfo');
			}else{
				alert('<xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/AlertMakeChoice"/>');
				 return false;
			}
	   }
		
		function selAllAll(){
			var obj = document.forms[0];
			selAll(obj.elements['sFromDBtables']);
			selAll(obj.elements['sFromDBtables_1']);
		}
</SCRIPT>
<ics:callelement element="fatwire/systemtools/SystemInfo/SysInfoCommons" />
</HEAD>

<body>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo" /></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<p></p>
<satellite:form name="appForm" id="appForm" action='<%=ics.GetVar(VAR_REQHANDLERURL) %>' method="post">
<%-- Print basic database information.--%>
<%
Map<String,String> basic_info = DBInfo.getBasicInfo(ics);
%>
<ics:callelement element="fatwire/systemtools/SystemInfo/ShowLoading" />
<table class="width-outer-70" BORDER="0" CELLSPACING="0" CELLPADDING="0">
 <tr><td>
 <table class="width-inner-100" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr> 
			    <td></td>
			    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
			<tr>
				<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
							<tr>
								<td colspan="6" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
							</tr>
							<tr>
								<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' />&nbsp;</td>
								<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
									<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/BasicInfo" /></DIV>
								</td>
								<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' />&nbsp;</td>
								<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' />&nbsp;</td>
								<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' />&nbsp;</td>
								<td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
							</tr>
							<tr>
								<td colspan="6" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
							</tr>
							<%
							int j=0;
							  for(String key : basic_info.keySet() ) {
								  String value = basic_info.get(key);
							
							if(j%2==0) {
							%>
							<tr class="tile-row-normal">
							<% } else { %>
							<tr class="tile-row-highlight">
							<% } %>
							    <td><br/></td>
								<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
									<DIV class="small-text-inset"><%=key%></DIV>
								</td>
								<td><br/></td>
								<td><br/></td>
								<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
									<DIV class="small-text-inset"><%=value%></DIV>
								</td>
								<td><br/></td>
							</tr>
							<%
							j++;} %>
						</table>
					</td>
					<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
			</tr>
			<tr>
				<td colspan="6" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			</tr>
			<tr>
				<td></td>
				<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
	</table>

<table class="width-inner-100" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	 <%
	 //getTableTypes returns distinct tables from SystemInfo based on systable column.
	 ArrayList<String> table_types = DBInfo.getTableTypes(ics);
	 //Next for each table types retrieve the tables corresponding to it.
	  for(int i=0; i < table_types.size() ; i++) {
	 String table_type = table_types.get(i);
	 %>
	 <tr>
	 <td class="form-label-text" valign="top"><br/><xlat:stream key='<%= "fatwire/SystemTools/SystemInfo/DBInfo/" + table_type %>' />:</td>
	 <td>
	 <table BORDER="0" CELLSPACING="0" CELLPADDING="0">
	 <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	 <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar"/>
	 <tr>
	 <td></td>
	 <td class="form-inset">
	 <table BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<ics:setvar name="errno" value="0"/>
			<%
			ArrayList<String> tables = DBInfo.getTablesPerType(ics,table_type);
			%>
	    <tr>
				<td></td>
				<td>
				 <table border="0" cellpadding="0" cellspacing="0">
					<tr>
							<td align="center">
								<span class="table-header-small-text"><xlat:stream key="dvin/Common/Available"/> </span>
								<br/>
								<SELECT name="fromINIFiles_<%=table_type%>" size="12" multiple="yes" style="width:200px;" >			
								<%
								int index=0;
								//Iterate the tables to display information.
								for(String table_name : tables) {
								
								%>
									<option value='<%=table_name%>'>
										   <%=table_name%>
									</option>
									
								<%
								index++;
								}
								%>
								</SELECT><br/>
							</td>
							<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif" %>' /></td>
							<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' />
							<td>
								<table>
									<tr><td>
											
											<A HREF="javascript:void(0);" onclick="moveright(document.forms[0].elements['fromINIFiles_<%=table_type%>'], document.forms[0].elements['sFromDBtables_<%=table_type %>']);"  onmouseout="window.status=' ';return true;" >
												<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Add"/></ics:callelement><br/>
											</A>
											</tr><tr><td></td></tr><tr><td>
											<A HREF="javascript:void(0);" onclick="moveleft(document.forms[0].elements['sFromDBtables_<%=table_type%>'], document.forms[0].elements['fromINIFiles_<%=table_type%>']);" onmouseout="window.status=' ';return true;" >
												<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Remove"/></ics:callelement>
											</A>
									 </td></tr>
								</table>
							</td>
							<td>
								<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif" %>'/>
							</td>
							<td>
								<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/>
							</td>
							<td align="center"><span class="table-header-small-text"><xlat:stream key="dvin/Common/Selected"/></span><br/>
								<select name="sFromDBtables_<%=table_type%>" SIZE="12" MULTIPLE="yes" style="width:200px;"></select>
							</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</td>
  </tr>
  </table>
  </td>
  </tr>
  <%if(i == table_types.size() - 1){%>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
		<tr><td><br/></td><td>			<xlat:lookup key="fatwire/SystemTools/SystemInfo/ShowResults" varname="ShowResults"/>
			    	<xlat:lookup key="fatwire/SystemTools/SystemInfo/Download" varname="Download"/>
					
					<A HREF='#' onclick=" check_before_submit('false');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/ShowResults"/></ics:callelement></A>
					
                    <A HREF='#' onclick=" check_before_submit('true');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Download"/></ics:callelement></A>
	</td></tr>
<%}
   }
	%>
</table>
</satellite:form>
</body>
</html>
<%
}else{
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
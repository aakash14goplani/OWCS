<%@page import="com.fatwire.cs.systemtools.util.SysInfoUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// fatwire/systemtools/SystemInfo/CSInfo
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
<%@ page import="com.fatwire.cs.systemtools.systeminfo.ConfigFilesReader"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
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
	String ini_path = application.getInitParameter("inipath");
	// String defaultLocale = ics.GetSSVar("locale");
	String defaultLocale = "en_US";
%>
<satellite:link pagename="fatwire/systemtools/SystemInfo/Download" assembler="query" outstring="createZipURL" />
<satellite:link assembler="query" pagename='fatwire/systemtools/SystemInfo/DisplayCSResults' outstring='<%= VAR_REQHANDLERURL%>' />		
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
		   
		   var target = document.forms[0].elements['sfromINIFiles'];
		   var sel = false;
		   for(i=0;i<target.options.length;i++) {
		     if (target.options[i].selected) {
				sel = true;
				break;
			 }
		   }
		   
		   if(!sel) {
		   target = document.forms[0].elements['sfromINIFiles_1'];
			   for(i=0;i<target.options.length;i++) {
			     if (target.options[i].selected) {
					sel = true;
					break;
					
				 }
			   }
		   }
		   
			 if(!sel && (document.forms[0].elements['jars'].checked 
				|| document.forms[0].elements['csvars'].checked 
				||document.forms[0].elements['systemvars'].checked)) {
		   sel = true;
		   }
		if(!sel) 
		{
			alert('<xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/AlertMakeChoice"/>');
			return false;
		}
		
		if(download === 'false')
		{
			document.forms[0].action = '<%= ics.GetVar(VAR_REQHANDLERURL) %>';
			document.forms[0].submit();
		}
		else
			execute('<%=ics.GetVar("createZipURL")%>','csInfo');
	   }
	   
		function selAllAll(){
			var obj = document.forms[0];
			selAll(obj.elements['sfromINIFiles']);
			selAll(obj.elements['sfromINIFiles_1']);
		}
</script>
<ics:callelement element="fatwire/systemtools/SystemInfo/SysInfoCommons" />
</HEAD>

<body>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo" /></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<p></p>
<satellite:form name="appForm" id="appForm" action='<%=ics.GetVar(VAR_REQHANDLERURL) %>' method='post'>
<ics:callelement element="fatwire/systemtools/SystemInfo/ShowLoading" />
<table  class="width-outer-70" BORDER="0" CELLSPACING="0" CELLPADDING="0">
 <tr><td>
 <table class="width-outer-50" BORDER="0" CELLSPACING="0" CELLPADDING="0">
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
									<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/MemInfo" /></DIV>
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
							  for(String[] row : SysInfoUtils.getMemoryInfo(ics) ) {
							if(j%2==0) {
							%>
							<tr class="tile-row-normal">
							<% } else { %>
							<tr class="tile-row-highlight">
							<% } %>
							    <td><br/></td>
								<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
									<DIV class="small-text-inset"><%=row[0]%></DIV>
								</td>
								<td><br/></td>
								<td><br/></td>
								<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
									<DIV class="small-text-inset"><%=row[1]%></DIV>
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
	</td></tr>
	<tr><td>
		<table border="0" cellpadding="0" cellspacing="0">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar"/>
			<tr>
				<td class="form-label-text" style="width:200px;vertical-align:top;"><br/><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/ConfigFiles/CSProperties" />:</td>
				<td></td>
				<td class="form-inset">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="center"><span class="table-header-small-text"><xlat:stream key="dvin/Common/Available"/> <br/> </span>
								<SELECT name="fromINIFiles" size="12" multiple="yes" style="width:200px;" >
								<%
								 List<File> files = ConfigFilesReader.getCSInfoFileNames(ini_path);
								 for( File ini_file : files ) {
								   %> 
								   <option value='<%=ini_file.getName()%>'>
								   <%=ini_file.getName()%>
								   </option>
								   <%
								 }
								%>
							
								</SELECT>
								<br/>
							</td>
					
							<td>
													<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif" %>' />
												</td>
												<td>
													<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' />
							</td>
							<td>
								<table>
									<tr><td>
									<xlat:lookup key="dvin/Util/FlexAssets/AddAttr" varname="AddAttr" escape="true"/>
									<A HREF="javascript:void(0);" onclick="moveright(document.forms[0].elements['fromINIFiles'], document.forms[0].elements['sfromINIFiles']); return false;" onmouseover="window.status='Variables.AddAttr';return true;" onmouseout="window.status=' ';return true;" ><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Add"/></ics:callelement><br/>
									</A>
									</tr><tr><td></td></tr><tr><td> 
									<xlat:lookup key="dvin/Util/FlexAssets/RemoveselectItem" varname="RemoveselectItem" escape="true"/>
									<A HREF="javascript:void(0);" onclick="moveleft(document.forms[0].elements['sfromINIFiles'], document.forms[0].elements['fromINIFiles']);" onmouseover="window.status='Variables.RemoveselectItem';return true;" onmouseout="window.status=' ';return true;" REPLACEALL="Variables.RemoveselectItem"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Remove"/></ics:callelement>
									</A>
									</td></tr>
								</table>
							</td>
							<td>
								<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif" %>' />
							</td>
							<td>
								<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' />
							</td>
						<td align="center"><span class="table-header-small-text"><xlat:stream key="dvin/Common/Selected"/> </span><br/>
						<select name="sfromINIFiles" SIZE="12" MULTIPLE="yes" style="width:200px;">
						</select>
					</tr>
			</table>
		</td>
	</tr>
</table>
</td>
</tr>


<tr>
<td>
<table class="width-inner-100" border="0" cellpadding="0" cellspacing="0">
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar"/>
<tr>
<td class="form-label-text" style="width:200px;vertical-align:top;"><br/><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/ConfigFiles/WebProperties" />:</td>
<td></td>
		<td class="form-inset">
		 <table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="center"><span class="table-header-small-text"><xlat:stream key="dvin/Common/Available"/> </span><br/>
					<SELECT name="fromINIFiles_1" size="12" multiple="yes" style="width:200px;" >
						<%
							ServletContext context = getServletConfig().getServletContext() ; 
							 files = ConfigFilesReader.getWebPropFiles(context);
							 for( File ini_file : files ) {
							   %> 
							   <option value='<%=ini_file.getName()%>'>
							   <%=ini_file.getName()%>
							   </option>
							   <%
							 }
							 files = ConfigFilesReader.getWebXMLFiles(context);
							 
							 for( File ini_file : files ) {
							   %> 
							   <option value='<%=ini_file.getName()%>'>
							   <%=ini_file.getName()%>
							   </option>
							   <%
							 }
						%>
					</SELECT>
					<br/>
				</td>
				<td>
												<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif" %>' />
											</td>
											<td>
												<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' />
							</td>
				<td>
					<table>
						<tr><td>
								<%--xlat:lookup key="dvin/Util/FlexAssets/AddAttr" varname="AddAttr" escape="true" --%>
								<A HREF="javascript:void(0);" onclick="moveright(document.forms[0].elements['fromINIFiles_1'], document.forms[0].elements['sfromINIFiles_1']);" onmouseover="window.status='Variables.AddAttr';return true;" onmouseout="window.status=' ';return true;" ><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Add"/></ics:callelement><br/>
								</A>
								</tr><tr><td></td></tr><tr><td> 
								<%--xlat:lookup key="dvin/Util/FlexAssets/RemoveselectItem" --%>
								<A HREF="javascript:void(0);" onclick="moveleft(document.forms[0].elements['sfromINIFiles_1'], document.forms[0].elements['fromINIFiles_1']);" onmouseout="window.status=' ';return true;" ><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Remove"/></ics:callelement>
								</A>
						 </td></tr>
					</table>
				</td>
					<td>
						<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif" %>' />
					</td>
					<td>
						<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' />
					</td>
					<td align="center"><span class="table-header-small-text"><xlat:stream key="dvin/Common/Selected"/> </span><br/>
					<select name="sfromINIFiles_1" SIZE="12" MULTIPLE="yes" style="width:200px;">
					 </select>
					 </td>
			</tr>
		   </table>
		</td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar"/>
		<tr>
			<td class="form-label-text" style="width:200px;vertical-align:top;"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/OtherCSInfo" />:</td>
			<td></td>
			<td class="form-inset">
			<input type="checkbox" name="jars" value="JarVersions"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/JarVersions" /></input><br/>
			<input type="checkbox" name="csvars" value="CSVars"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/CSVariables" /></input><br/>
			<input type="checkbox" name="systemvars" value="SystemVars"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/SystemVariables" /></input><br/>
			</td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
	<tr>
	<TD class="form-label-text"></TD><TD></TD><TD class="form-inset">
		<xlat:lookup key="fatwire/SystemTools/SystemInfo/ShowResults" varname="ShowResults"/>
		<xlat:lookup key="fatwire/SystemTools/SystemInfo/Download" varname="Download"/>
		<A HREF='#' onclick="check_before_submit('false');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/ShowResults"/></ics:callelement></A>
		<A HREF='#' onclick="check_before_submit('true');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Download"/></ics:callelement></A>			
	</TD>
	</tr>
  </table>
  </td>
</tr>
	

</table>
</td>
</tr>
</table>	
</satellite:form>
</body>
</html>
<%} else
{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%
}
%>
</cs:ftcs>
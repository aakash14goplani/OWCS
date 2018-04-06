<%@page import="com.fatwire.cs.systemtools.util.SysInfoUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.log4j.lf5.LogLevel" 
%><%@ page import="org.apache.log4j.*" 
%><%@ page import="org.apache.log4j.spi.*" 
%><%@ page import="java.util.*" 
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.ConfigFilesReader" 
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.JarVersion" %>

<cs:ftcs>
<div class="width-outer-70">
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
%>
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/content.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/prettify.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css,prettify.css"/>
</ics:callelement>
<script language="JavaScript">
   function toggleVisibility(id) {
   var theImage =  document.getElementById(id);
   var theRowName = id.replace('_img', '_result');   
    var theRow = document.getElementById(theRowName);
    if (theRow.style.display=="none") {
        theRow.style.display = "";
        theImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Collapse.gif';
	} else {
        theRow.style.display = "none";
        theImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif';
    }
	}
</script>
<script type="text/javascript" src='<%=request.getContextPath() %>/js/prettify.js'></script>
</HEAD>
<BODY onload="prettyPrint()">
<satellite:form>
	<% 
	String ini_path = application.getInitParameter("inipath");
	%>
	<br/>
<% if(ics.GetVar("sfromINIFiles") != null) { %>
<span class="title-text">
<xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/ConfigFiles/CSProperties" />
</span>
<P>
</P>
<%
String[] filenames = ics.GetVar("sfromINIFiles").split(";");
String[] xmlFiles = SysInfoUtils.getFilesByType(filenames,"xml");

List<String> propertiesList = new ArrayList<String>();
for(String screenXml: filenames)
{
	if(!screenXml.endsWith(".xml"))
	{
		propertiesList.add(screenXml);
	}
}

ArrayList<Properties> listConfig = ConfigFilesReader.getCSProperties(ini_path,propertiesList);

int i=0;
for( Properties p : listConfig ) {
String name = propertiesList.get(i++);
%>

<img id='<%=name + "_img"%>' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif'
	onClick="javascript:toggleVisibility('<%=name + "_img"%>');" style='vertical-align:middle;' /><%=name%>
<p></p>
<div id='<%=name + "_result"%>' style="display:none">
<table BORDER="0" CELLSPACING="0" CELLPADDING="0">

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
		<td colspan="9" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	</tr>
	<tr>
	<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
	</td>
<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
	<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Property" /></DIV>
</td>

<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</td>

<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Value" />
</DIV>
</td>
<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
</td>
</tr>
<tr>
<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
</tr>

<%

int num=1;
TreeSet property_key_set = new TreeSet();
property_key_set.addAll(p.keySet());
for (Iterator itr = property_key_set.iterator(); itr.hasNext();)
  {
        String key = (String)(itr.next());
		String value = (String)(p.get(key));
		if (num % 2 !=0) 
			{ %>
		<tr class="tile-row-highlight">
		<% }
		else {
		  %>
		<tr class="tile-row-normal">
		<% } %>
				<td><br/></td>
                <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
				<DIV class="small-text-inset"><%=key%></DIV>
				</td>
				<td><br/></td>
                <td VALIGN="TOP" ALIGN="LEFT">
				<DIV class="small-text-inset"><%=value%></DIV>
				</td>
				<td><br/></td>
				<%--<tr><td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td></tr>
          </tr>--%>
        <%
		num++;
		}		
		%>

</table>
</td>
<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
</tr>
<tr>
<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
</tr>
<tr>
<td>
</td>
<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'>
<IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
<td></td>
</tr>
</table>
</div>
<p></p>
<%  
   } // closing of for loop for INI files
   if(xmlFiles.length != 0) {   
 %>
<h3><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/ConfigFiles/CSXMLFiles"/></h3>
<%
List<String> xml_file_list = ConfigFilesReader.getCSXMLFiles(ini_path ,Arrays.asList(xmlFiles));
i=0;
for(String xmlFile : xml_file_list ) {
	%>
	<p></p>
	<img id='<%=xmlFiles[i] + "_img"%>' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif' onClick="javascript:toggleVisibility('<%=xmlFiles[i] + "_img"%>' );" style="vertical-align:middle;"/>
	<%=xmlFiles[i]%>
	<p></p>
	<div id='<%=xmlFiles[i] + "_result"%>' style="display:none">
  	<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<tr> 
		    <td></td>
		    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			<td></td>
		</tr>
		<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
							   <ics:setvar name="xmlF" value='<%=xmlFile%>' />
							   <string:encode varname="xmlFEnc" variable="xmlF" />
								   <tr class="tile-row-highlight">
										   <td><pre class="prettyprint lang-xml" style="margin-bottom: -5px" ><%=ics.GetVar("xmlFEnc")%></td>
									</tr>
				</table>
			</td>
			<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
		</tr>
	<tr><td class="tile-dark" HEIGHT="1" valign="TOP" colspan="3"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td></tr>
	<tr>
		<td></td>
		<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		<td></td>
	</tr>		
 </table>
 </div>
 <%
 i++;
}

}   
   
  } // closing of if(ics.GetVar("sfromINIFiles") != null)
      
  %>
<%--Logic for Displaying CS Web files. eg. FWLicense.xml --%>


    
<%-- Display logic for properties files in webapps --%>

<% if(ics.GetVar("sfromINIFiles_1") != null) { %>
<span class="title-text">
<xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/ConfigFiles/WebProperties" />
</span>
<P>
</P>
<%
String[] filenames = ics.GetVar("sfromINIFiles_1").split(";");
String[] propFiles = SysInfoUtils.getFilesByType(filenames,"properties");
String[] xmlFiles = SysInfoUtils.getFilesByType(filenames,"xml");

ArrayList<Properties> listConfig = ConfigFilesReader.getWebProperties(getServletConfig().getServletContext() ,Arrays.asList(propFiles));
int i=0;
for( Properties p : listConfig ) {
String name = propFiles[i++];
%>
<p></p>
<img id='<%=name + "_img"%>' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif' onClick="javascript:toggleVisibility('<%=name + "_img"%>');" style="vertical-align:middle;"/>
<%=name%>
<p></p>
<div id='<%=name + "_result"%>' style="display:none">
<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
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
		<td colspan="9" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			</tr>
			<tr>
			<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
			</td>


		<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
			<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Property" />  
			</DIV>
		</td>

		<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>

		<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
		<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Value" />
		</DIV>
		</td>
		<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
		</td>
		</tr>
		<tr>
		<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<%
		int num=1;
		TreeSet property_key_set = new TreeSet();
		property_key_set.addAll(p.keySet());
		for (Iterator itr = property_key_set.iterator(); itr.hasNext();)
		  {
		        String key = (String)(itr.next());
				String value = (String)(p.get(key));
				if (num % 2 !=0) 
					{ %>
				<tr class="tile-row-highlight">
				<% }
				else {
				  %>
				<tr class="tile-row-normal">
				<% } %>
						<td><br/></td>
		                <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
						<DIV class="small-text-inset">
							<%=key%>
						</DIV>
						</td>
						
						<td><br/></td>
		                <td VALIGN="TOP" ALIGN="LEFT">
						<DIV class="small-text-inset">
						<%=value%>
						</DIV>
						</td>
						<td><br/></td>
						<%--<tr>
							<td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
						</tr>--%>
		          </tr>
		        <%
				num++;
				}		
				%>

		</table>
	</td>

<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
</tr>
<tr>
<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td></tr>
<tr>
<td>
</td>
<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
<td>
</td>
</tr>
</table>
</div>

<%   
	} // closing of for loop for web app files
 
%>
	  <%-- Logic for displaying the XML files--%>   <% 
	  if(xmlFiles.length !=0 ) {
	  %>
	  <h3><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/ConfigFiles/XMLFiles"/></h3>
	  <%
	  ArrayList<String> xml_file_list = ConfigFilesReader.getWebXMLs(getServletConfig().getServletContext() ,Arrays.asList(xmlFiles));
	  i=0;
	  for(String xmlFile : xml_file_list ) {
		%>
		<p></p>
		<img id='<%=xmlFiles[i] + "_img"%>' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif' onClick="javascript:toggleVisibility('<%=xmlFiles[i] + "_img"%>' );" style="vertical-align:middle;"/>
		<%=xmlFiles[i]%>
		<p></p>
		<div id='<%=xmlFiles[i] + "_result"%>' style="display:none">
	    	<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr> 
			    <td></td>
			    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
			<tr>
				<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
								   <ics:setvar name="xmlF" value='<%=xmlFile%>' />
								   <string:encode varname="xmlFEnc" variable="xmlF" />
									   <tr class="tile-row-highlight">
											   <td><pre class="prettyprint lang-xml" style="margin-bottom: -5px" ><%=ics.GetVar("xmlFEnc")%></td>
										</tr>
					</table>
				</td>
				<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
			</tr>
		<tr><td class="tile-dark" HEIGHT="1" valign="TOP" colspan="3"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td></tr>
		<tr>
			<td></td>
			<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			<td></td>
		</tr>		
	   </table>
	   </div>
	   <%
	   i++;
	  }
    }
  }
 %>
  	 
 <% if(ics.GetVar("jars")!= null || ics.GetVar("csvars")!= null || ics.GetVar("systemvars")!= null) { %>
 <h3> <xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/OtherCSInfo" /> </h3>
 <% } %>
  <%--Display logic for Jar Versions --%>

  <% 
    if(ics.GetVar("jars") != null ) {
    
   %>
   <p></p>
  <img id="jarversions_img" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif' onClick="javascript:toggleVisibility('jarversions_img');" style="vertical-align:middle;"/>
   <xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/JarVersions" />
<p></p>
<div id='jarversions_result' style="display:none">
 <table BORDER="0" CELLSPACING="0" CELLPADDING="0">
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
			<td colspan="9" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<tr>
			<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
			</td>
	
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
				<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/JarNameTableHeader"/>
				</DIV>
			</td>

			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>

			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
			<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/JarVersionVendor" />
			</DIV>
			</td>
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
<%
	int num=1;
	Map<String,String> map = JarVersion.getCSJarVersions(ics,getServletConfig().getServletContext());
	for(String key : map.keySet() ) {
	  String value = map.get(key);
		if (num % 2 !=0) 
			{ %>
		<tr class="tile-row-highlight" >
		<% }
		else {
		  %>
		<tr class="tile-row-normal">
		<% } %>
				<td><br/></td>
                <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
				<DIV class="small-text-inset">
					<%=key%>
				</DIV>
				</td>
				<td><br/></td>
                <td  VALIGN="TOP" ALIGN="LEFT" >
				<DIV class="small-text-inset">
				<%=value%>
				</DIV>
				</td>
				<td><br/></td>
				<%--<tr>
					<td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>--%>
          </tr>
        <%
		num++;
		}		
		%>
	</table>
	</td>
	<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
	</tr>
	<tr>
	<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	</tr>
	<tr><td></td>
	<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	<td></td>
	</tr>
	</table>
	</div>
	  <%
	}  
    //Display logic for Content server variables
    if(ics.GetVar("csvars") != null ) {
   %>
   	<p></p>
 	<img id="csvar_img" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif' onClick="javascript:toggleVisibility('csvar_img');" style="vertical-align:middle;"/>
	<xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/CSVariables" />
	<p></p>
<div id='csvar_result' style="display:none">
<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
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
			<td colspan="9" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<tr>
			<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
			</td>	
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
				<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Property" />  
				</DIV>
			</td>
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
			<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Value" />
			</DIV>
			</td>
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
<%
	int num=1;
	Map<String,String> sessionVars= ConfigFilesReader.getSessionVariables(ics);
	for (String key : sessionVars.keySet()) {
	  String value = sessionVars.get(key);
		if (num % 2 !=0) 
			{ %>
		<tr class="tile-row-highlight" >
		<% }
		else {
		  %>
		<tr class="tile-row-normal"> 
		<% } %>
				<td><br/></td>
                <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
				<DIV class="small-text-inset">
					<%=key%>
				</DIV>
				</td>
				<td><br/></td>
                <td  VALIGN="TOP" ALIGN="LEFT" >
				<DIV class="small-text-inset">
				<string:stream value='<%=value%>'/>
				</DIV>
				</td>
				<td><br/></td>
				<%--<tr>
					<td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>--%>
          </tr>
        <%
		num++;
		}		
		%>
	</table>
	</td>
	<td class="tile-dark" VALIGN="top" WIDTH="1">
	<br/>
	</td>
	</tr>
	<tr>
	<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	</tr>
	<tr>
	<td>
	</td>
	<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	<td>
	</td>
	</tr>
	</table>
	</div>
	<%}
	
	
	//Display logic for System variables
    if(ics.GetVar("systemvars") != null ) {
   %>
   <p></p>
   <img id="systemvars_img" 
	   src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif' 
		onClick="javascript:toggleVisibility('systemvars_img');" style="vertical-align:middle;"/>
   <xlat:stream key="fatwire/SystemTools/SystemInfo/CSInfo/SystemVariables" />
   <p></p>
<div id='systemvars_result' style="display:none">
 <table BORDER="0" CELLSPACING="0" CELLPADDING="0">
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
			<td colspan="9" class="tile-highlight">
			<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<tr>
			<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
			</td>
	
			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
				<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Property" />    
				</DIV>
			</td>

			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>

			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
			<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/Value" />  
			</DIV>
			</td>

			<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
			</td>
		</tr>

		<tr>
			<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
<%
	int num=1;

	Enumeration e = System.getProperties().propertyNames();
	
	while ( e.hasMoreElements()) {
	
	  String key = (String)e.nextElement();
	  String value = (String)System.getProperty(key );
	  if(key.toLowerCase().contains("password") || key.toLowerCase().contains("passwd") ) {
	  				 value = "#############";
	}
		if (num % 2 !=0) 
			{ %>
		<tr class="tile-row-highlight" >
		<% }
		else {
		  %>
		<tr class="tile-row-normal" >
		<% } %>
				<td>
				<br/>
				</td>
                <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
				<DIV class="small-text-inset">
					<%=key%>
				</DIV>
				</td>
				
				<td>
				<br/>
				</td>
				
                <td  VALIGN="TOP" ALIGN="LEFT" >
				<DIV class="small-text-inset">
				<%=value%>
				</DIV>
				</td>
				<td><br/></td>
				<%--<tr>
					<td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>--%>
          </tr>
        <%
		num++;
		}		
		%>

	</table>
	</td>
	<td class="tile-dark" VALIGN="top" WIDTH="1">
	<br/>
	</td>
	</tr>
	<tr>
	<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	</tr>
	<tr>
	<td>
	</td>
	<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	<td>
	</td>
	</tr>
	</table>
	</div>
	<%}%>
</satellite:form>
</BODY>
</HTML>
<%}else{%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%}%>
</div>
</cs:ftcs>
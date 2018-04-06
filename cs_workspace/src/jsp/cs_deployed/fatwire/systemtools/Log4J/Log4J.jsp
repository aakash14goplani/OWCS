<%@page import="java.util.Iterator"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.Set"%>
<%@page import="com.fatwire.cs.systemtools.util.SysInfoUtils"%>
<%@page import="org.apache.log4j.spi.LoggerRepository"%>
<%@page import="org.apache.log4j.Level"%>
<%@page import="org.apache.log4j.Logger"%>
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
<cs:ftcs>
<string:encode variable="log" varname="log"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />

<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
	// final String systemToolsLocale = ics.GetSSVar("locale");
	final String systemToolsLocale = "en_US";
%>
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/content.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS" />
<script type="text/javascript">
function checkBeforeSubmit()
{
	
	var logName = document.forms[0].elements['log'];
	if(!isCleanString(logName.value,' ~!@#$%^&*()[]{}_+=-|',false) )
		alert('<xlat:stream key="fatwire/SystemTools/Log4J/IncorrectPackage"/>');
	else
		document.forms[0].submit();
}
</script>
</HEAD>
<BODY>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="fatwire/SystemTools/Log4J/Log4JPageHeading" /></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<div class="width-outer-70">
<%if("true".equals(ics.GetVar("showAll"))){
    %><b><xlat:stream key="fatwire/SystemTools/Log4J/AllLoggers" /></b><%
}else{%><b><xlat:stream key="fatwire/SystemTools/Log4J/ConfiguredLoggers"/></b>
<%   
}
	/*
	Below lines performs addition of a new logger and setting its level.
	If logger level is not provided default is DEBUG.
	*/
	String logName=ics.GetVar("log");
	if (null!=logName) {
	   logName = logName.trim();
	   if(logName.contains(" ")) {
	      %><script type='text/javascript'>
	      
	      alert('<xlat:stream key="fatwire/SystemTools/Log4J/IncorrectPackage"/>');
	      </script>
	      <%
	   } else {
	       
	   Logger log=("root".equals(logName) ?
	       Logger.getRootLogger() : Logger.getLogger(logName));
	   log.setLevel(Level.toLevel(ics.GetVar("level"),Level.DEBUG));
	   }
	}
	
	Logger rootLogger=Logger.getRootLogger();
	LoggerRepository loggerRepository=Logger.getRootLogger().getLoggerRepository();
 %>
 </div>
<P>
</P>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-70">

<tr>
    <td></td>
    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	<td></td>
</tr>

<tr>
	<td class="tile-dark" VALIGN="top" WIDTH="1"><BR/></td>
	<td>
					
			<% 
			//-- New table inside --
			%>

			<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
					<tr>
						<td colspan="9" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
					</tr>
					<tr>
						<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
						</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
							<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/Log4J/Index" />
							</DIV>
						</td><td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
						<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/Log4J/Level" /></DIV>
						</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
						</td>


						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
						<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/Log4J/Logger" />
						</DIV>
						</td>

						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td><td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
						<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/Log4J/SetNewLevel" />
						</DIV>
						</td>
						<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' class="tile-c">&nbsp;</td>
					</tr>

<tr>
<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif '/></td>
</tr>

<%  
				   
%>

					<tr class="tile-row-normal">
					<td><BR/></td>
					<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
					<DIV class="small-text-inset">1</DIV>
					</td>
					<td><BR/></td>
					<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
					<DIV class="small-text-inset"><%= rootLogger.getLevel() %></DIV></td>
								<td><BR/></td>
					<td VALIGN="TOP"><DIV class="small-text-inset"><%= rootLogger.getName() %></DIV></td>
										<td><BR/></td>
					<td  VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
					<DIV class="small-text-inset">
					<%  
					        /*
							 This section displays the links for setting the level of the logger.
							 A parameter called level is passed in the URL.
							*/
					      for (int i=0; i< SysInfoUtils.levelsLog4j.length;i++){
					        %>
							
							<a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&log=root&level=<%=SysInfoUtils.levelsLog4j[i] %>'><%=SysInfoUtils.levelsLog4j[i] %></a>
							<%}%>
					</DIV>
					</td>
						<td><BR/></td>
							<%--<tr><td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
							</tr>--%>
					<%
					//The treeset is created to sort the loggers by name. com.a , com.b, com.c , etc
					Set loggerNameSet = new TreeSet();
					for (Enumeration loggers = loggerRepository.getCurrentLoggers(); loggers.hasMoreElements();){
										Logger logger = (Logger)loggers.nextElement();
										loggerNameSet.add(logger.getName());	
					}
					int num=1;
					for (Iterator loggers = loggerNameSet.iterator(); loggers.hasNext();){
									        Logger logger = loggerRepository.getLogger((String)loggers.next());
						/*
						  showAll is false by default. At the end of this page, a link to display all (Show All Loggers)is given.
						*/
				        if (logger.getLevel() !=null || "true".equals(ics.GetVar("showAll") )){
						num++;
						//This variable (num) is used to count the rows, as well as to display the row styles in alternating fashion, as in code 
						//immediately below.
				        %>
						
						<%if (num % 2 ==0) { %>
						<tr class="tile-row-highlight">
						<% }else {%>
						<tr class="tile-row-normal">
						<% } %>
								<td><BR/></td>
				                <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
								<DIV class="small-text-inset">
								<%= Integer.toString(num) %>
								</DIV>
								</td>
								<td><BR/></td>
				                <td VALIGN="TOP" ALIGN="LEFT">
								<DIV class="small-text-inset">
								<%= logger.getLevel() !=null? logger.getLevel().toString():"(inherited: "+ logger.getEffectiveLevel()+")" %>
								</DIV>
								</td>
								<td><BR/></td>
				                <td VALIGN="TOP" ALIGN="LEFT">
								<DIV class="small-text-inset">
								<%= logger.getName() %>
								</DIV>
								</td>
								<td>
								<BR/>
								</td>
								
				                <td VALIGN="TOP" ALIGN="LEFT">
								<DIV class="small-text-inset">
								<% for (int i=0; i< SysInfoUtils.levelsLog4j.length;i++){ 
				                %><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&log=<%= logger.getName() %>&level=<%=SysInfoUtils.levelsLog4j[i] %>'><%=SysInfoUtils.levelsLog4j[i] %></a> <%
				                }
				                %>
								</DIV>
								</td>
								
								<td>
								<BR/>
								</td>
								<%--<tr>
									<td colspan="9" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
								</tr>--%>
				          </tr>
				        <%}
		}%>

		</table>
	</td>

	<td class="tile-dark" VALIGN="top" WIDTH="1"><BR/></td>
</tr>
<tr><td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
</tr>

<tr>
	<td></td>
	<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
	<td></td>
</tr>

</table>

<P>
</P>
<div class="width-outer-70">
<satellite:form>
<input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
<table>
	<tr>
		<td></td>
		<td><div><input type="text" name="log"/></div>
		</td>
		<td>
			<div>
				<select name="level"><% for (int i=0; i< SysInfoUtils.levelsLog4j.length;i++){ %><option><%=SysInfoUtils.levelsLog4j[i] %></option><%}%>
				</select>
			</div>
		</td>
		<td>
			<div style="position: relative; top: 2px; left: 5px;">
			<a onmouseout="window.status='';return true;" onmouseover="window.status='Add new logger';return true;" onclick="checkBeforeSubmit();return false;" href="#">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddLogger"/></ics:callelement>
			</a>
			</div>
		</td>
	</tr>
</table>

</satellite:form>

<ul>
<li><xlat:stream key="fatwire/SystemTools/Log4J/Show" /> 
	<a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&showAll=true'><xlat:stream key="fatwire/SystemTools/Log4J/AllLoggers" /></a>
</li>
<li><xlat:stream key="fatwire/SystemTools/Log4J/Show" />
	<a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>'><xlat:stream key="fatwire/SystemTools/Log4J/ConfiguredLoggers" /></a>
</li>
<li><xlat:stream key="fatwire/SystemTools/Log4J/Show" />  
	<a href='ContentServer?pagename=<%= ics.GetVar("pagename")%>Config'> <xlat:stream key="fatwire/SystemTools/Log4J/LoggerLevelsAsProperties" /></a>
</li>
</ul>
<%}
else
{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
	</div>
<%
}
%>
</div>
</BODY>
</HTML>
</cs:ftcs>
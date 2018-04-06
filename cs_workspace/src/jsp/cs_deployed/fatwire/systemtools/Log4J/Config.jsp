<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.log4j.*" %>
<%@ page import="org.apache.log4j.spi.*" %>
<%@ page import="java.util.*" %>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/content.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css"/>
</ics:callelement>
</HEAD>
<BODY>
<div class="width-outer-70">
<satellite:link assembler="query" pagename="fatwire/systemtools/Log4J/Log4J" outstring="urllog4j"/>
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{%>
<xlat:lookup  key="fatwire/SystemTools/Log4J/SaveLog4JLoggerXML" varname="msgtext"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
    <ics:argument name="severity" value='info'/>
</ics:callelement>
<textarea style="width:700px;height:800px;" readonly="readonly">
<%  

		Logger rootLogger=Logger.getRootLogger();
		LoggerRepository loggerRepository=Logger.getRootLogger().getLoggerRepository();

		Set loggerNameSet = new TreeSet();
		//Added to the treeset to have the loggers displayed in sorted order.
		for (Enumeration loggers = loggerRepository.getCurrentLoggers(); loggers.hasMoreElements();){
			Logger logger = (Logger)loggers.nextElement();
			loggerNameSet.add(logger.getName());
			
		}
		int num=0;

		for (Iterator loggers = loggerNameSet.iterator(); loggers.hasNext();){
			Logger logger = loggerRepository.getLogger((String)loggers.next());
			Level level = logger.getLevel();
			if ( level!=null){
			num++;
			%>log4j.logger.<%= logger.getName() %>=<%=level%>
<%
			}
		}
	%>
</textarea>
<ul>
<li><xlat:stream key="fatwire/SystemTools/Log4J/Show" /> 
	<a href='<%=ics.GetVar("urllog4j") + "&showAll=true"%>'><xlat:stream key="fatwire/SystemTools/Log4J/AllLoggers" /></a>
</li>
<li><xlat:stream key="fatwire/SystemTools/Log4J/Show" />
	<a href='<%=ics.GetVar("urllog4j")%>'><xlat:stream key="fatwire/SystemTools/Log4J/ConfiguredLoggers" /></a>
</li>
<li><xlat:stream key="fatwire/SystemTools/Log4J/Show" />  
	<a href='<%=ics.GetVar("urllog4j") + "Config"%>'> <xlat:stream key="fatwire/SystemTools/Log4J/LoggerLevelsAsProperties" /></a>
</li>
</ul>
<%
}else{
%><xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/><ics:getvar name="msg" />
<%}%>
</div>
</BODY>
</HTML>
</cs:ftcs>
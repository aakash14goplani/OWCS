<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" 
%><%
//
// OpenMarket/Xcelerate/ControlPanel/EditPanel
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><%
String mode = ics.GetVar("mode");
if (mode == null) mode = "editing";
%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Login">
	<ics:argument name="panel" value="SimplePanel"/>
</ics:callelement>
<ics:if condition='<%=!"-1".equals(ics.GetVar("errno")) %>'>
<ics:then>

<usermanager:getloginusername varname="thisusername"/>
<satellite:link pagename="OpenMarket/Xcelerate/ControlPanel/Stylesheet" outstring="urlstylesheet" assembler="query"/>
<ics:getproperty name="xcelerate.imageurl" file="futuretense_xcel.ini" output="imageurl"/>
<ics:setvar name="cs_imagedir" value='<%=ics.GetProperty("ft.cgipath") + ics.GetVar("imageurl")%>' />  		
<ics:setvar name="panelImagePath" value='<%=ics.GetVar("cs_imagedir") + "/graphics/" + ics.GetSSVar("locale") + "/controlpanel"%>' />		    
<ics:setvar name="commonImagePath" value='<%=ics.GetProperty("ft.cgipath") + "images"%>' />	
<html>
	<head>    
		<link href="<ics:getvar name="urlstylesheet"/>" rel="stylesheet" type="text/css" />
		<script>
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/Ajax"/>
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/RequestEngine" />
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/ControlPanel">
			<%if(ics.GetVar("wem") != null) {%>
				<ics:argument name="wem" value='<%=ics.GetVar("wem")%>' />
			<%}%>
			</ics:callelement>
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/EditPanel"/>
		</script>
	</head>
	<body> 
		<div id="controlPanel">
		    <div id="siteName">
		    	<strong>Site:</strong> <ics:getssvar name="PublicationName" /><br/>
		    	<strong>User:</strong> <ics:getvar name="thisusername"/>
		    </div>		    
		    <div id="editing"><table class="titlebar" cellspacing="0"><tr><td><img src="<ics:getvar name="panelImagePath"/>/insite_editing.gif"></td></tr></table></div>
		    <div id="editingTab">
		    	<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteEditing" />
		    </div>
		</div> 	  
	</body>
</html>
<script type="text/javascript">
<%--doing this based on offsetHeight/Width introduces infinite-growth bug
	var iHeight = 100 + document.getElementById('controlPanel').offsetHeight;
	var iWidth = 4 + document.getElementById('controlPanel').offsetWidth;
--%>
	var iHeight = 400; var iWidth = 254;
	window.resizeTo(iWidth, iHeight);
</script>
</ics:then>
</ics:if>
</cs:ftcs>

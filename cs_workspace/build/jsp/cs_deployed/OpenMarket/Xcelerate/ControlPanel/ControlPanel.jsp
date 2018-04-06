<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 

%><%
//
// OpenMarket/Xcelerate/ControlPanel/ControlPanel
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><cs:ftcs><%
String mode = ics.GetVar("mode");
if (mode == null) mode = "preview";
%>
<string:encode value='<%=ics.GetVar("AssetType")%>' varname='AssetType' />
<string:encode value='<%=ics.GetVar("id")%>' varname='id' />
<string:encode value='<%=ics.GetVar("mode")%>' varname='mode' />
<ics:if condition='<%=ics.GetVar("target")!=null%>'>
	<ics:then>
		<string:encode value='<%=ics.GetVar("target")%>' varname='target' />
	</ics:then>
</ics:if>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Login">
  <ics:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
  <ics:argument name="id" value='<%=ics.GetVar("id")%>'/>
  <ics:argument name="target" value='<%=ics.GetVar("target")%>'/>
  <ics:argument name="mode" value='<%=ics.GetVar("mode")%>' />
  <ics:argument name="pubid" value='<%=ics.GetSSVar("pubid")%>' />
</ics:callelement>
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
		</script>
		<script type="text/javascript" src='<%=ics.GetProperty("ft.cgipath")+"js/dojo/dojo.js"%>' djConfig="debugAtAllCosts: false, isDebug: true, parseOnLoad: true"></script>
	</head>
	<body>
	<div id="siteName">
		<table id="siteNameTable"><tr><td class="siteNameTableSpace">&nbsp;</td></tr><tr><td class="siteNameTableSpace">&nbsp;</td><td><strong>Site:</strong> <ics:getssvar name="PublicationName" /></td></tr><tr><td class="siteNameTableSpace">&nbsp;</td></tr></table>
	</div>
		<div id="controlPanel">
		    <div id="preview"><table class="titlebar" cellspacing="0"><tr><td style="cursor:pointer; cursor:hand" title='<xlat:stream key="dvin/UI/PreviewYourWebPage"/>'><img src="<ics:getvar name="panelImagePath"/>/insite_preview.gif" class="title-image"></td></tr></table></div>
		    <div id="previewTab" style="border-style:solid;border-width:0px 0px 1px 0px;border-color:#b4b4b4;">        
		    	<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Tabs/Preview" />            
		    </div>
		    <div id="editing"><table class="titlebar" cellspacing="0"><tr><td style="cursor:pointer; cursor:hand" title='<xlat:stream key="dvin/UI/EditYourWebPageInContext"/>' onClick="checkBrowserForEditingTab()"><img src="<ics:getvar name="panelImagePath"/>/insite_editing.gif" class="title-image"></td></tr></table></div>
		    <div id="editingTab" style="border-style:solid;border-width:0px 0px 1px 0px;border-color:#b4b4b4;">
		    	<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteEditing" />
		    </div>
		    <div id="pagebuilder"><table class="titlebar" cellspacing="0"><tr><td style="cursor:pointer; cursor:hand" title='<xlat:stream key="dvin/UI/BuildYourWebPage"/>' onclick="checkPageLayoutPrivileges()"><img src="<ics:getvar name="panelImagePath"/>/insite_pagebuilder.gif" class="title-image"></td></tr></table></div>
		   	<div id="pagebuilderTab" style="border-style:solid;border-width:0px 0px 1px 0px;border-color:#b4b4b4;">
		   		<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteTemplating" />
		   	</div>
		   	<div id="insitesearch"><table class="titlebar" cellspacing="0"><tr><td style="cursor:pointer; cursor:hand" title='<xlat:stream key="dvin/UI/SearchforAssets"/>'><img src="<ics:getvar name="panelImagePath"/>/insite_search.gif" class="title-image"></td></tr></table></div>
		   	<div id="insitesearchTab" style="border-style:solid;border-width:0px 0px 1px 0px;border-color:#b4b4b4;">
		   		<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteSearch" />
		   	</div>
		   	<div id="workflow"><table class="titlebar" cellspacing="0"><tr><td style="cursor:pointer; cursor:hand" title='<xlat:stream key="dvin/UI/CompleteYourWorkflowAssignments"/>'><img src="<ics:getvar name="panelImagePath"/>/insite_assignments.gif"  class="title-image"></a></td></tr></table></div>                
		   	<div id="workflowTab" style="border-style:solid;border-width:0px 0px 1px 0px;border-color:#b4b4b4;">
		   		<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Tabs/Workflow" />
		   	</div>
		</div> 	  
	</body>
</html> 
</cs:ftcs>

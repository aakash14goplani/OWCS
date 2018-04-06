<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/ShowWemPreviewHeader
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
<cs:ftcs>


<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html>
<head><%
    String topNavImagesPath = ics.GetVar("cs_imagedir") + "/graphics/common/toolbar";
    String commonImagesPath = ics.GetProperty("ft.cgipath") + "images";	
%>
    <style>
		

		.toprowwhite, .toprowwhite a, .toprowwhite a:visited
		{
			vertical-align:middle;
		 	font-family:arial, helvetica, verdana, san-serif;
		 	font-size:10px;
		 	white-space:nowrap;
		 	font-weight:bold;
		 	color:#ffffff;

		}
    </style>

    <script>
		var prevWindow="";
    	var panelOn = true;
    	var currentCols = "200,*";
    	function togglePanel(turnOn) {
            if (panelOn && !turnOn) {
				switchToggleIcon('FullWindowToggleDiv','controlToggleDiv');
    			var frameSet = parent.document.getElementById("previewFrameset");
    			currentCols = frameSet.cols;
    			frameSet.cols = "0,*";
    			panelOn = false;
    		} else if (!panelOn && turnOn) {
				switchToggleIcon('controlToggleDiv','FullWindowToggleDiv');
				var frameSet = parent.document.getElementById("previewFrameset");
    			frameSet.cols = currentCols;
    			panelOn = true;
    		}
    	}
		function switchToggleIcon(iconDivFrom,iconDivTo)
		{
		    if(document.getElementById(iconDivFrom).style.display != "none")
		    {
		        document.getElementById(iconDivFrom).style.display = "none";
		        document.getElementById(iconDivTo).style.display = "inline";
		    }

		}
		function swap(currentImage, newImageName)
		{
			if (document.images)
			{
				currentImage.src = newImageName;
			}
		}
		
		 function openPreviewWindow()
	  	{
              var rendermode="preview";
	  		var panelObj = parent.frames["ControlPanel"].fw.controlPanel ;
	  		var currentUrl  = panelObj.getCurrentURL();
	  		var str="";
	  		var temp = currentUrl.split('&');
	  		for (j=0; j<temp.length; j++) {
	  			if((temp[j].lastIndexOf("rendermode"))!= -1){
	  				temp[j]=temp[j].replace(temp[j].substr(temp[j].lastIndexOf("=")+1),rendermode);
	  			}
	  			str+=temp[j]+'&';
	  		}
	  		str=str.substr(0,str.lastIndexOf("&"));
	  		currentUrl=str;
            var newWindow = window.open(currentUrl);
	  		newWindow.focus();
	  	}
       

    </script>
	<link href='<%=ics.GetVar("cs_imagedir") + "/data/css/" + ics.GetSSVar("locale") + "/wemAdvancedUI.css"%>' rel="stylesheet" type="text/css"/>
	<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
		<ics:argument name="cssFilesToLoad" value="wemAdvancedUI.css"/>
	</ics:callelement>
</head>
<body style="padding:0;margin:0;"><usermanager:getloginusername varname="thisusername" />
<div class="topMenuBar">
	<div class="topMenuBarLeft">
		<div class="logoWebCenterSites"></div>
	</div>
	<div class="topMenuBarRight">
		<a href="javascript:openPreviewWindow();" class="toggleWindow"><img id="OpenFullWindowToggle" src="<%=topNavImagesPath%>/togglepreviewfullwin.gif" border="0" alt="<xlat:stream key="dvin/UI/PreviewinFullWindow"/>" title="<xlat:stream key="dvin/UI/PreviewinFullWindow"/>" style="vertical-align:middle;" /></a>						
	</div>
</body>
</html>

</cs:ftcs>
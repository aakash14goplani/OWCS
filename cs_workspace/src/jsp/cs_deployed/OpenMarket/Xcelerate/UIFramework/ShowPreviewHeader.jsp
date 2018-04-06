<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" %><%
%><%@ taglib prefix="ccuser" uri="futuretense_cs/ccuser.tld" %><%
%><%@ taglib prefix="rolelist" uri="futuretense_cs/rolelist.tld" %><%
%><%@ taglib prefix="property" uri="futuretense_cs/property.tld" %><%

%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %><%
//
// OpenMarket/Xcelerate/UIFramework/ShowPreviewHeader
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>


<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html>
<head><%
    String topNavImagesPath = ics.GetVar("cs_imagedir") + "/graphics/common/toolbar";
    String commonImagesPath = ics.GetProperty("ft.cgipath") + "images";	
%>
    <style>
		.middlerowregular
		{
			vertical-align:middle;
			font-family:arial, helvetica, verdana, san-serif;
			font-size:11px;
			white-space:nowrap;
			font-weight:normal;
			color:#17387d;

		}

		.middlerowregular a, .middlerowregular a:visited
		{
			vertical-align:middle;
			font-family:arial, helvetica, verdana, san-serif;
			font-size:11px;
			white-space:nowrap;
			font-weight:normal;
			color:#17387d;
			text-decoration:underline;

		}

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
              var rendermode="previewnoinsite";
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
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="background-image:url(<%=topNavImagesPath%>/topnav_bg.gif);background-repeat: repeat-x"><usermanager:getloginusername varname="thisusername" />

<table width="100%" cellPadding="0" cellSpacing="0">
 	<tr>
      	<td align="left" valign="top" width="4">
      		<!--<img src="<%=topNavImagesPath%>/topnav_bg_left.gif" />-->
      	</td>
      	<td width="100%" align="left" valign="top">
		  	<table width="100%" cellPadding="0" cellSpacing="0" border="0">
		  	  <tr height="24">
		  	    <td align="left" height="24"><img src="<%=topNavImagesPath%>/fw_logo.gif"/></td>
		  	    <td  height="24" align="right" valign="middle" class="toprowwhite">

					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
					<td valign="top">
						<img src="<%=topNavImagesPath%>/spacer.gif" width="5" height="1" />
						<a href="javascript:openPreviewWindow();"><img id="OpenFullWindowToggle" src="<%=topNavImagesPath%>/togglepreviewfullwin.gif" border="0" alt="<xlat:stream key="dvin/UI/PreviewinFullWindow"/>" title="<xlat:stream key="dvin/UI/PreviewinFullWindow"/>" style="vertical-align:middle;" /></a>
						<span id="controlToggleDiv" style="display:none;"><img id="panelOnToggle" src="<%=topNavImagesPath%>/togglecontroloff.gif" alt="<xlat:stream key="dvin/Common/ShowLeftHandNavigation"/>" title="<xlat:stream key="dvin/Common/ShowLeftHandNavigation"/>" style="vertical-align:middle; cursor:pointer; cursor:hand" onclick="togglePanel(true);"/></span><span id="FullWindowToggleDiv"><img id="panelOffToggle" src="<%=topNavImagesPath%>/togglewindowfulloff.gif"  alt="<xlat:stream key="dvin/Common/HideLeftHandNavigation"/>" title="<xlat:stream key="dvin/Common/HideLeftHandNavigation"/>" onclick="togglePanel(false);"	style="vertical-align:middle; cursor:pointer; cursor:hand" /></span>
					</td>
					<td><img src="<%=topNavImagesPath%>/spacer.gif" width="26" height="1" /><br /></td>
					<td class="toprowwhite">
						<table cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td class="toprowwhite"><xlat:stream key="dvin/Common/User"/>: <ics:getvar name="thisusername"/> </td>
						<td><img src="<%=topNavImagesPath%>/spacer.gif" width="3" height="1" /><br /></td>
						<td class="toprowwhite">| </td>
						<td><img src="<%=topNavImagesPath%>/spacer.gif" width="3" height="1" /><br /></td>
						<td class="toprowwhite"><a onclick="window.open('<ics:getproperty name="cs.documentation"/>?cslocale=<ics:getssvar name="locale"/>', 'help_window');" href="javascript:void(0);"><xlat:stream key="dvin/UI/Help"/></a></td>
						<td><img src="<%=topNavImagesPath%>/spacer.gif" width="3" height="1" /><br /></td>
						<td class="toprowwhite">| </td>
						<td><img src="<%=topNavImagesPath%>/spacer.gif" width="3" height="1" /><br /></td>
						<td class="toprowwhite"><a onclick="parent.close(); return false;" href="javascript:void(0);"><xlat:stream key="fatwire/InSite/Close"/></a></td>
						</tr>
						</table>
					</td>
 					<td><img src="<%=topNavImagesPath%>/spacer.gif" width="15" height="1" /><br /></td>
					</tr>
					</table>

		  	    </td>
		  	  </tr>
		  	  <tr>
				<td colspan="2"><img src="<%=topNavImagesPath%>/spacer.gif" width="1" height="4" /></td>
			  </tr>
		  	  <tr>
		  	    <td align="left" width="60%" style="padding-left:4px;">
		  	        	<%
						String currentUser = ics.GetVar("thisusername");
						String currentSite = ics.GetSSVar("pubid");
					%>   				
   				   	 <usermanager:getuserfromname username='<%=currentUser%>' objvarname="u"/>
   					 <ccuser:getsiteroles name="u" site='<%=currentSite%>' objvarname="srl"/>
   					 
   					 <rolelist:hasrole name="srl" role="AdvancedUser" varname="isAdvUser"/>
					<%
					String isAdvancedUser = ics.GetVar("isAdvUser");
					if( null !=isAdvancedUser && isAdvancedUser.equalsIgnoreCase( "true" ) )
					{
					%>
		  	        
				  	        <a href="javascript:void(0);" onclick="window.parent.openAdvancedWindow('ContentServer?showSiteTree=true&ThisPage=ShowMyDesktopFront&pagename=OpenMarket/Xcelerate/UIFramework/ShowMainFrames');"><img src="<%=topNavImagesPath%>/advanced.gif" border="0" alt="advanced" title="Advanced" onmouseover="swap(this,'<%=topNavImagesPath%>/advancedhover.gif')" onmouseout="swap(this,'<%=topNavImagesPath%>/advanced.gif')"/></a>		  	        
		  	        	<%
		  	        	} else {
		  	        	%>
		  	        	<img src="<%=topNavImagesPath%>/advancedunavail.gif" title="<xlat:stream key="dvin/Common/Advancedisunavailable"/>" alt="<xlat:stream key="dvin/Common/Advancedisunavailable"/>" />
		  	        	<%
		  	        	}
		  	        	%>
		  	        <img src="<%=topNavImagesPath%>/spacer.gif" width="1" height="1" />
                    <rolelist:hasrole name="srl" role="DashUser" varname="isDashUser"/>
                    <%
                        String isDashUser = ics.GetVar("isDashUser");
                        if (null!= isDashUser && isDashUser.equalsIgnoreCase("true"))
                        {
                    %>
                      <a href="javascript:void(0);" onclick="window.parent.openDashWindow('faces/jspx/dash.jspx?CS_UI_CONTEXT=CS_ADVANCE_UI');"><img src="<%=topNavImagesPath%>/dashboard.gif" border="0" alt="dash" title="Dash" onmouseover="swap(this,'<%=topNavImagesPath%>/dashboardhover.gif')" onmouseout="swap(this,'<%=topNavImagesPath%>/dashboard.gif')"/></a>
                    <%
                        }else {
                    %>
                      <img src="<%=topNavImagesPath%>/dashboardunavail.gif" title="<xlat:stream key="dvin/Common/Dashisunavailable"/>" alt="<xlat:stream key="dvin/Common/Dashisunavailable"/>" />
                    <%
                    }
                    %>
                    <img src="<%=topNavImagesPath%>/spacer.gif" width="1" height="1" /><img src="<%=topNavImagesPath%>/insiteon.gif" title="InSite" alt="insite" /><img src="<%=topNavImagesPath%>/spacer.gif" width="1" height="1" />

		  	        <!-- start Analytics Performance Indicator-->
   					<rolelist:hasrole name="srl" role="Analytics" varname="hasit"/>
					<%
					String userHasRole = ics.GetVar("hasit");
					if( null !=userHasRole && userHasRole.equalsIgnoreCase( "true" ) )
					{
					%>
   					<property:get inifile="futuretense_xcel.ini" param="analytics.enabled" varname="analyticsEnabled"/>
					<%

   					   String analyticsEnabled = ics.GetVar("analyticsEnabled");
					   if( null !=analyticsEnabled && analyticsEnabled.equalsIgnoreCase( "true" ) )
					   {
					%>
					<property:get inifile="futuretense_xcel.ini" param="analytics.reporturl" varname="reporturl"/>
					<property:get inifile="futuretense_xcel.ini" param="analytics.user" varname="analyticsUser"/>
					<%
					   String analyticsURL = ics.GetVar("reporturl") + "?context=cs&amp;username=" + ics.GetVar("analyticsUser") + "&amp;action=doLogin";
					%>

												<a href="javascript:void(0);" onclick="window.parent.openAnalyticsWindow('<%=analyticsURL%>')" ><img src="<%=topNavImagesPath%>/analytics.gif" title="Analytics" alt="analytics" onmouseover="swap(this,'<%=topNavImagesPath%>/analyticshover.gif')" onmouseout="swap(this,'<%=topNavImagesPath%>/analytics.gif')" border="0" /></a>
  					    <%	} else {  %>
   					       					    <img src="<%=topNavImagesPath%>/analyticsunavail.gif" title="<xlat:stream key="dvin/Common/Analyticsisunavailable"/>" alt="<xlat:stream key="dvin/Common/Analyticsisunavailable"/>" />
   					    <%}
   					  } else { %>


		  	        		<img src="<%=topNavImagesPath%>/analyticsunavail.gif" title="<xlat:stream key="dvin/Common/Analyticsisunavailable"/>" alt="<xlat:stream key="dvin/Common/Analyticsisunavailable"/>" />
   					    <%}%>

   					    <!-- end Analytics Performance Indiacator-->


				</td>

		  	    <td align="right" width="40%" class="middlerowregular">
					<img src="<%=topNavImagesPath%>/spacer.gif" width="10" height="1" />
				</td>
		  	  </tr>
		  	</table>


  		</td>
      	<td align="right" valign="top" width="4">
      		<!--<img src="<%=topNavImagesPath%>/topnav_bg_right.gif" />-->
      	</td>
	</tr>
</table>

</body>
</html>
</cs:ftcs>
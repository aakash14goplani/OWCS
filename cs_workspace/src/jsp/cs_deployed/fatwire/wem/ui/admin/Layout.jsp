<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%--
fatwire/wem/ui/admin/Layout
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<cs:ftcs>
<%-- set relative path to webapp folder once and for all. --%>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:setssvar name="locale" value='<%=com.fatwire.util.LocaleUtil.getUserLocale(ics,request.getLocales())%>'/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html>
 <head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <style type="text/css">
@import url('<%=ics.GetVar("cspath")%>/js/dojo/resources/dojo.css');
@import url('<%=ics.GetVar("cspath")%>/js/dijit/themes/dijit.css');
@import url('<%=ics.GetVar("cspath")%>/wemresources/css/wemUI.css');
@import url('<%=ics.GetVar("cspath")%>/js/fw/css/UILayout.css');
@import url('<%=ics.GetVar("cspath")%>/js/fw/css/UIComponents.css');
@import url('<%=ics.GetVar("cspath")%>/js/fw/css/ui/global.css');
@import url('<%=ics.GetVar("cspath")%>/js/fw/css/ui/SWFUpload.css');
  </style>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/js/dojo/dojo.js"
   djConfig="parseOnLoad: true, fw_csPath:'<%=ics.GetVar("cspath")%>/', locale: '<%=ics.GetSSVar("locale")%>'.toLowerCase().replace('_', '-')"
  ></script>
  <%-- built layers --%>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/js/fw/fw_wem_base.js"></script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/js/fw/fw_wem_admin.js"></script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/wemresources/js/ui/imagereplace.js"></script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/js/SWFUpload/swfupload.js"></script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/js/SWFUpload/plugins/swfupload.swfobject.js"></script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/js/SWFUpload/plugins/swfupload.queue.js"></script>
  <script type="text/javascript">
	//set the swf path this would be used everywhere by elementsImageReplacement
	elementsImageReplacement.setSwfPath("<%=ics.GetVar("cspath")%>/wemresources/js/ui/base64image.swf");
  </script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/wemresources/js/ui/admin.js"></script>
  <script type="text/javascript" src="<%=ics.GetVar("cspath")%>/wemresources/js/dojopatches.js"></script>
  <script type="text/javascript">
  //Validate the current user
  dojo.addOnLoad(
    function(){
		var dfd = AdminUIManager.validateUser();
				dfd.addCallback(function() {
					if (!AdminUIManager._fullAccess) {
						//disable all menu items except Sites
						dijit.byId('miApps').set('disabled', true);
						dijit.byId('miUsers').set('disabled', true);
						dijit.byId('miRoles').set('disabled', true);
					}
					if(AdminUIManager._fullAccess){
					//Fetch the user attributes
						AdminUIManager.getUserAttributes();
					}
				});
		//wencontent div is hidden when it first loads so lets make it visible 
		//Since at this point we know that the user has been validated
		dojo.byId("wemcontent").style.display='';
	}
);
  </script>
 </head>
 <body class="fw">
  <div id="borderContainerDiv" dojoType="dijit.layout.BorderContainer" class="mainBorderContainer">
   <div dojoType="dijit.layout.ContentPane" splitter="false" region="top" class="headerContentPane">
    <div class="container">
     <div class="menu">
      <div class="item logoWebCenterSites"></div>
      <div dojoType="fw.dijit.UIMenuBar" id="wemmenu" style="display:none">
       <div dojoType="dijit.MenuBarItem" id="miSites" onClick="AdminUIManager.loadPage('site/Browse','top');"><xlat:stream key="fatwire/wem/admin/common/Sites"/></div>
       <div dojoType="dijit.MenuBarItem" id="miApps" onClick="AdminUIManager.loadPage('app/Browse','top');"><xlat:stream key="fatwire/wem/admin/common/Applications"/></div>
       <div dojoType="dijit.MenuBarItem" id="miUsers" onClick="AdminUIManager.loadPage('user/Browse','top');"><xlat:stream key="fatwire/wem/admin/common/Users"/></div>
       <div dojoType="dijit.MenuBarItem" id="miRoles" onClick="AdminUIManager.loadPage('role/Browse','top');"><xlat:stream key="fatwire/wem/admin/common/Roles"/></div>
      </div>
     </div>
    </div>
   </div>
   <!-- end of menu bar area, start of main area -->
   <div dojoType="dijit.layout.ContentPane" region="center" class="mainContentPane">
	<div class="containerBg">
	<div class="container" id="wemcontent" style="display:none;" dojoType="fw.wem.layout.UIContentPane" href=''>
    </div>
	</div>
   </div>
  </div>
 </body>
</html>
</cs:ftcs>

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// fatwire/wem/Welcome
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="com.fatwire.wem.sso.SSO" %>
<cs:ftcs>
<ics:setssvar name="locale" value='<%=com.fatwire.util.LocaleUtil.getUserLocale(ics,request.getLocales())%>'/>
<%
//set cs path variable for use for client-side resources
String cspath = request.getContextPath();
if (!cspath.endsWith("/")) {
	cspath += "/";
}
String locale = ics.GetSSVar("locale").toLowerCase().replace("_", "-");
%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html>
 <head>
  <title>Oracle WebCenter Sites 11gR1</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <link rel="shortcut icon" href="<%=cspath%>wemresources/images/icons/sitesFavicon.ico" type="image/x-icon" />
  <style type="text/css">
@import url('<%=cspath%>js/fw/css/ui/transition.css');
  </style>
  <script type="text/javascript" src="<%=cspath%>wemresources/js/WemContext.js"></script>
  <satellite:link assembler="query" pagename="fatwire/ui/util/GetSLSObj" outstring="getSLSObj">
	<satellite:argument name="user_locale" value='<%=locale%>'/>
  </satellite:link>
  <script type="text/javascript" src="<%=cspath%>js/dojo/dojo.js"
   djConfig="fw_csPath:'<%=cspath%>', locale:'<%=locale%>'"
  ></script>
  <script type="text/javascript">
	//initialize wemcontext before loading dojo layers (see AppBar FIXME)
	//Unfortunately it needs to be AFTER dojo because WemContext relies on xhrGet!
	WemContext.initialize('<%=cspath%>');
	
	console.debug("[Welcome]  WemContext.initialize  FETCHED User Preferences ") ;
  </script>
<%-- rather than create ANOTHER layer for this, reuse base+framework,
     since that should include all we need for this page... --%>

  <script type="text/javascript" src="<%=cspath%>js/fw/fw_wem_base.js"></script>
  <script type="text/javascript" src="<%=cspath%>js/fw/fw_wem_framework.js"></script>
  
  <script type="text/javascript">
var context = WemContext.getInstance();
dojo.require('fw.wem.AppBar');
dojo.require("fw.xhr");

//TODO 
//var lastSite = context.getAttribute(fw.wem._COOKIE_PREFIX_ + 'lastSite');

var lastSite = context.getSiteName(), selectedSite; 

dojo.require('dojo.parser');
dojo.require('fw.data.cs.ClientRestStore');
dojo.require('fw.dijit.UIFilteringSelect');

var appArea, appBar, appFadeInAnim, appFadeOutAnim; //defined in addOnLoad below


function checkLogin(func) {
	var xhrProps = {
		url: dojo.config.fw_csPath + 'wem/fatwire/wem/ui/Ping',
		handleAs: 'json',
		error: function(err) {
			//we got logged out - tell WEM UI to kick out to login page
			context.directToLoginPage();
		}
	};
	if (func) { //we were passed a function to perform on success, hook it up
		xhrProps.load = func;
	}
	return dojo.xhrGet(xhrProps);
}


function showSiteApps(site) {
	
	checkLogin( function() {
	var siteSwitcher = dijit.byId('siteSwitcher');

	console.debug("[Welcome] Selected Site=",site," ,lastSite=",lastSite) ; 
	
	if (site && site != selectedSite) { //ignore useless events
		siteSwitcher.textbox.blur(); //defocus field
		//update context object for apps switcher, and also set site cookie now
		
		// Ok Site has been selected set both cookie and WEMUI:lastsite  with value = null 
		context.setSiteName(site);
		selectedSite = site;
		console.debug("[Welcome] SET WEMUI:lastSite=",lastSite) ;	
		
		//tell app selector to populate for this site
		//make sure app selector is displayed now that we've picked a site
		appFadeOutAnim.play();
	}
	});
}

//function used by fadeout animation's onEnd as well as by first-time display
function fadeInSiteApps() {
	appBar.refresh();
	dojo.style(appArea, 'display', ''); //unhide
	appFadeInAnim.play();
}

//function to send browser to WEM UI
function loadWEM() {
	window.location.href = '<%=cspath%>wem/fatwire/home';
}

//init: includes post-onload stuff that should only happen after we know
//whether user has access to any sites.  (Called onComplete of sites fetch)
function init(sites) {
	if (sites && sites.length > 0) {
		//create animations
		appArea = dojo.byId('appArea');
		appBar = dijit.byId('appBar');
		appFadeInAnim = dojo.fadeIn({node: appBar.domNode, duration: 500});
		if (dojo.isIE < 8) {
			//work around odd shenanigans with _setOpacity in 1.5.
			//(I can't figure out what the real cause is...)
			appFadeInAnim.onEnd = function() {
				setTimeout(function() {
					dojo._setOpacity(appBar.domNode, 1);
				}, 1);
			}
		}
		appFadeOutAnim = dojo.fadeOut({node: appBar.domNode, duration: 500});
		appFadeOutAnim.onEnd = fadeInSiteApps;

		//connect UIFilteringSelect textbox defocus and drop-down click
		dojo.connect(dijit.byId('siteSwitcher'), 'onChange', showSiteApps);
		dojo.connect(dijit.byId('siteSwitcher')._popupWidget, 'onChange', showSiteApps);
		//connect application icon click and drop-down click
		//but make sure it happens AFTER cookie population!
		dojo.connect(appBar._favBar, 'updateFavorites', loadWEM);
		
		//set up siteswitcher properties to sort site list (since service doesn't)
		dijit.byId('siteSwitcher').fetchProperties = {
			sort: [
				{attribute: 'site'}
			]
		};
		
	    console.debug("[Welcome].init Sites Fetched  lastSite=",lastSite) ;
	    
		if (lastSite) {
			dijit.byId('siteSwitcher').set('value', lastSite);
			delete lastSite; //variable no longer needed
		}
		
		//hide no-sites message since we have sites
		dojo.style('noSiteArea', 'display', 'none');
	} else {
		//show no-sites message, hide sites select
		dojo.style('siteArea', 'display', 'none');
	}
	//Unhide contents now that we're done
	dojo.style('container', 'display', '');
}

function doSignout() {
	var url = window.location.href;
	url = url.split('/').slice(0,3).join('/') + dojo.config.fw_csPath +
		'login';
	url = '<%=SSO.getSSOSession().getSignoutUrl()%>?url=' +
		encodeURIComponent(url);
	window.location.href = url;
}

dojo.addOnLoad(function() {
	//[KGF #21644/etc.] Actually, maybe having the forwarding logic in here is a
	//good thing, as it gives me a wonderful opportunity to update the
	//last-logged-in time via XHR.
	dojo.xhrPost({
		url: '<%=cspath%>wem/fatwire/wem/UpdateLastLoggedIn',
		sync: true //need to make sure this fires completely before any redirect
	});
	
	//Before bothering with anything else, check if we already have cookies for
	//lastSite and favorites:<lastSite>. If we do, forward straight to WEM UI.
	//[KGF #21607] Wanted to do this well before onload, but that causes
	//harmless-but-noticeable javascript errors - but doing it here delays more.
	var favourites = context.getAttribute(fw.wem._USRPREFERENCE_PREFIX_ + 'favorites');
	if (lastSite && favourites)
	{
		var url = window.location.href;
		url = url.split('/').slice(0,3).join('/') + dojo.config.fw_csPath +
			'wem/fatwire/home'; 
		window.location.href = url;
		return; //don't bother running the rest of this handler, just forward
	}
	
	//[#21650] Login again link
	//hook up redirect to initial URL upon SSO logout
	//TODO: ensure we don't have ;JSESSIONID or anything?
	//hook up login again link
	dojo.byId('loginAgain').onclick = function() {
		doSignout();
	};
	
	//initialize sites store up here, where it's possible to get user from context
	sitesstore = new fw.data.cs.ClientRestStore({
		resource: 'usersites',
		params: { user: encodeURIComponent(context.getUserName())}
	});
	
	//parse now that we have sitesstore defined (needed by sites switcher)
	dojo.parser.parse('loginbox');
	
	//perform initial fetch to determine whether user has access to any sites.
	sitesstore.fetch({ onComplete: init });
});
<% 
if(session.getAttribute("X-CSRF-Token") != null){
%>
	context.setAuthTicket('<%=session.getAttribute("X-CSRF-Token") %>');
<%	  
}
%>
  </script>
 </head>
 <body class="fw">
<div class="centerboxcontainer" id="container" style="display: none">
 <div class="centerbox">
  <div class="loginbox" id="loginbox">
   <div class="topshadow"></div>
   <div class="leftshadow"></div>
   <div class="rightshadow"></div>
   <div class="bottomshadow"></div>

   <div class="loginBevelBottom"></div>
   
   <div class="loginheader"><div class="item logoWebCenterSites"><xlat:stream key="fatwire/wem/Version"/></div></div>
   <div class="logincontent">
    <div class="logo"></div>
    <div class="loginform">
     <div id="siteArea">
      <div><strong><xlat:stream key="fatwire/wem/admin/common/Site"/></strong></div>
      <div id="siteSwitcher" class="siteSwitcher" dojoType="fw.dijit.UIFilteringSelect"
       store="sitesstore" searchAttr="site" placeHolder="<xlat:stream key="fatwire/wem/SelectaSite"/>"></div>
     </div>
		 <div id="noSiteArea"><xlat:stream key="fatwire/wem/NoSites"/></div>
     <p></p>
     <div id="appArea" style="display: none">
      <div><strong><xlat:stream key="fatwire/wem/admin/common/SelectApplication"/></strong></div>
      <div id="appBar" class="appBar" dojoType="fw.wem.AppBar"
       appSwitcherText="<xlat:stream key="fatwire/wem/AllApps"/>"
       noAppsText="<xlat:stream key="fatwire/wem/NoApps"/>"
       errorAppsText="<xlat:stream key="fatwire/wem/ErrorGettingApps"/>"></div>
     </div>
		 <div class="loginAgain">
		  &laquo; <a id="loginAgain" href="#"><xlat:stream key="UI/ErrorHTML/LoginAgain"/></a>
		 </div>
    </div>
   </div>
  </div><%-- end of loginbox --%>
  <div class="center">
  	<xlat:stream key="dvin/UI/CopyrightFatWireSoftware" encode="false"/><br/>
  	<xlat:stream key="dvin/UI/TrademarkOracle" encode="false"/>
  </div>
 </div><%-- end of centerbox --%>
</div>
<div class="loginscreen"></div>
<div class="loginscreenbg"></div>
 </body>
</html>
</cs:ftcs>

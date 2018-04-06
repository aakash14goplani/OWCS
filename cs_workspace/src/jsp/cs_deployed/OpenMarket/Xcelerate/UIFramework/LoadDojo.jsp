<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/LoadDojo
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
<%@ page import="com.fatwire.wem.sso.SSO" %>
<cs:ftcs>
<ics:getproperty name="ft.cgipath" file="futuretense.ini" output="cgipath"/>
<script type="text/javascript">
	function getLocale(loc) {
		//convert from CS's locale notation format to the format Dojo NLS uses.
		//(e.g. en_US -> en-us, fr_FR -> fr-fr, etc.)
		return loc.toLowerCase().replace('_', '-');
	}
	var djConfig = {
		fw_csPath: '<%=ics.GetVar("cgipath")%>',
		pubName: '<%=ics.GetSSVar("PublicationName")%>',
		parseOnLoad: true,
		locale: getLocale('<%=ics.GetSSVar("locale")%>')
	};
</script>
<%
	String locale = ics.GetSSVar("locale") != null ? ics.GetSSVar("locale").toLowerCase().replace("_", "-") : "en-us";
%>
<satellite:link assembler="query" pagename="fatwire/ui/util/GetSLSObj" outstring="getSLSObj">
	<satellite:argument name="user_locale" value='<%=locale%>'/>
</satellite:link>
<ics:if condition='<%="true".equals(ics.GetSSVar("WemUI"))%>'>
<ics:then>
	<script type="text/javascript" src="<%=ics.GetVar("cgipath")%>wemresources/js/WemContext.js"></script>
	<script type="text/javascript">
		//initialize wemcontext before loading dojo layers (see AppBar FIXME)
		//Unfortunately it needs to be AFTER dojo because WemContext relies on xhrGet!
		WemContext.initialize('<%=ics.GetVar("cgipath")%>','<%=SSO.getSSOSession().getSignoutUrl()%>');
		var wemcontext = WemContext.getInstance();
		// If a new browser window is opened, as a pop up or new tab or new window, and if the Wem top bar is not there.
		// Then global sls js object would not avilable. In that scenario we load the object in two ways based on how the new window opened.
		// If as a pop-up
		if(window.opener) window.fw_sls_obj = window.opener.top.fw_sls_obj;
		// If as a browser tab or new brower window		
		if(!window.opener && window.top === window.self) document.write('<script type="text/javascript" src="<%=ics.GetVar("getSLSObj")%>"><' + '/script>');
	</script>
</ics:then>
<ics:else>
  	<script type="text/javascript" src='<%=ics.GetVar("getSLSObj")%>'></script>
</ics:else>
</ics:if>

<script type="text/javascript" src='<%=ics.GetVar("cgipath") + "js/dojo/dojo.js"%>'></script>
<script type="text/javascript" src="js/fw/fw_ui_advanced.js"></script>
<script type="text/javascript" src="js/SWFUpload/swfupload.js"></script>
<script type="text/javascript" src="js/SWFUpload/plugins/swfupload.swfobject.js"></script>
<script type="text/javascript" src="js/SWFUpload/plugins/swfupload.queue.js"></script>
<string:encode variable="docId" varname="docId"/>
<script type="text/javascript">
	dojo.require("fw.ui._advancedbase");
	dojo.addOnLoad(function() {
		var docIdInput
			, appForm = dojo.query('form[name="AppForm"]')[0]
			;
		dojo.addClass(dojo.body(), 'fw');
		//adding a class for Mac platform to fix scrollbar issue in Mac webkit browsers
		if(dojo.isMac) {
			dojo.addClass(dojo.body(), 'dj_Mac');
		}
		docIdInput = dojo.query('input[name="docId"]')[0];
		
		// docId identifies the tab selected in UC1.
		// AdvancedView passes the docId while drawing the page and 
		//	we are carrying forward the information to every page submit.
		if (!docIdInput && appForm) {
			dojo.create('input', {
				type: 'hidden',
				name: 'docId',
				value: '<%= ics.GetVar("docId") %>'
			}, appForm);
		}
	});
</script>
<script type="text/javascript" src='<%=ics.GetVar("cgipath") + "wemresources/js/dojopatches.js"%>'></script>
</cs:ftcs>
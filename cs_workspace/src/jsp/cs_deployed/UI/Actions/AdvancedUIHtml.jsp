<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="locale" uri="futuretense_cs/locale1.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardVariables" />

<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini" output="charset"/>
<!--  charset = <ics:getvar name="charset" /> -->
<ics:setvar name="cs.contenttype" value='<%="text/html; charset=" + ics.GetVar("charset") %>'/>
<html>
<head>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardHeader" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/AddCustomHeader"/>	
</head>
<body class="AdvForms">
	<ics:clearerrno />
	<satellite:form assembler="query" name="AppForm" method="post">
		<string:encode variable="charset" varname="_charset"/>
		<string:encode variable="cs_environment" varname="_cs_environment"/>
		<string:encode variable="cs_formmode" varname="_cs_formmode"/>
		
		<input type="hidden" name="_charset_" value="<ics:getvar name="_charset" />" />
		<input type="hidden" name="cs_environment" value="<ics:getvar name="_cs_environment" />" />
		<input type="hidden" name="cs_formmode" value="<ics:getvar name="_cs_formmode" />" />
		<input type="hidden" name="PubName" value='<%= ics.GetSSVar("PublicationName") %>' />
		<ics:if condition='<%=Utilities.goodString(ics.GetSSVar("locale")) %>'>
		<ics:then>
			<locale:create varname="LocaleName" localename='<%=ics.GetSSVar("locale") %>'/>
			<dateformat:create name="_FormatDate_" datestyle="full" timestyle="full" locale="LocaleName" timezoneid='<%=ics.GetSSVar("time.zone") %>'/>
		</ics:then>
		<ics:else>
			<dateformat:create name="_FormatDate_" datestyle="full" timestyle="full" timezoneid='<%=ics.GetSSVar("time.zone") %>'/>
		</ics:else>
		</ics:if>

		<ics:if condition='<%=Utilities.goodString(ics.GetVar("ThisPage")) %>'>
		<ics:then>
			<ics:if condition='<%=ics.IsElement("OpenMarket/Xcelerate/PrologActions/" + ics.GetVar("ThisPage")) %>' >
			<ics:then>
				<ics:callelement element='<%="OpenMarket/Xcelerate/PrologActions/" + ics.GetVar("ThisPage")%>'/>
			</ics:then>
			</ics:if>
			<ics:callelement element='<%="OpenMarket/Xcelerate/Actions/" + ics.GetVar("ThisPage") %>' />
		</ics:then>
		<ics:else>
			<!-- Display an informational message. -->
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="elem" value="NoActionSpecified"/>
				<ics:argument name="severity" value="error"/>
			</ics:callelement>
		</ics:else>
		</ics:if>
		<input type="hidden" name="errorOccured" value='<%=ics.GetVar("isErrorOccured") %>'/>
		<%-- TODO - implement history refresh: it has to work for assets accessed through the Advanced UI --%>
	</satellite:form>
	<script>
		var num = document.AppForm.length, i;
		document.AppForm.encoding="application/x-www-form-urlencoded";
		for (i=0; i < num; i++) {
			if (document.AppForm.elements[i].type=="file") document.AppForm.encoding="multipart/form-data";
		}
		(function() {
			var _alert = window.alert;
			window.alert = function() {
				var out = SitesApp.getActiveView() || SitesApp;
				out.clearFeedback();
				out.clearMessage();
				out.message(arguments[0], arguments[1] || "error");
				//fw/ui/controller/AdvancedController subscribes to this event
				parent.dojo.publish('/fw/ui/form/alert',[]);
				return true;
			};
		})();
	</script>
	
</body>
</html>
</cs:ftcs>
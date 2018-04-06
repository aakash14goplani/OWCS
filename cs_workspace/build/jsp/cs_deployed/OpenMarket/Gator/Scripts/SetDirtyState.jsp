<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/Scripts/SetDirtyState
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
<script>
dojo.addOnLoad(function(){
	var isUcForm = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
	var connectChangeEvents = function(){
		var widgets = dijit.findWidgets(document.forms[0]);				
		if (widgets && widgets.length === 1 && widgets[0].declaredClass === "dijit.layout.BorderContainer"){
			widgets = dijit.findWidgets(widgets[0].domNode);
			if (widgets && widgets.length === 1 && widgets[0].declaredClass === "dijit.layout.ContentPane"){
				widgets = dijit.findWidgets(widgets[0].domNode);
			}
		}
		dojo.forEach(widgets, function(eachWidget){
			var handleChange = dojo.connect(eachWidget, "onChange", function(){					
				setTabDirty();
				dojo.disconnect(handleChange);
			});
		})		
	};
	if(isUcForm) {
		setTimeout(function(){connectChangeEvents();}, 0);
	}	
});
</script>
</cs:ftcs>
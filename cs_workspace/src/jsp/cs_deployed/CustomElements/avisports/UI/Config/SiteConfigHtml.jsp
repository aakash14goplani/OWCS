<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs>
webcenter.sites['${param.namespace}'] = function (config) {	
	// default view modes for avisports
	config.defaultView["Page"] = "web";
	config.defaultView["AVIArticle"] = "web";
}
</cs:ftcs>
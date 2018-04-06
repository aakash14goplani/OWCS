<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs>
webcenter.sites['${param.namespace}'] = function (config) {
	// override this element in order to provide site-specific configuration settings
	// (CustomElements/siteName/UI/Config/SiteConfigHtml)
}
</cs:ftcs>
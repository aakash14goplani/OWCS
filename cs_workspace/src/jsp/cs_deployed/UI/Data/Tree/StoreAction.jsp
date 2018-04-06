<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>

<cs:ftcs>

<%
	//Call to filter/encode all request Input Parameter Strings
%>

<ics:callelement element="UI/Utils/encodeParameters"> 
	<ics:argument name="excludeParametersLst" value="loadUrl"/> 
</ics:callelement>
<%
String loadUrl = (String)request.getParameter("loadUrl");

// nodeKey is set to init when we're requesting the 
// root nodes  corresponding to legacy tree tabs
if (loadUrl != null && "init".equals(loadUrl)) {	
	// init with configured roots source element 
	String roots = (String)request.getParameter("roots");
	if(roots != null && StringUtils.isNotEmpty(roots)) {
		// yes: root source element specifed 
		// use custom element to fetch the forest of root nodes 
		ics.CallElement( roots, null );
	}
	else {
		// init, then we want to load the list of trees for this tab.
		ics.CallElement( "UI/Data/Tree/TabDataStore", null );
	}	
}
else {
	// otherwise, this is normal tree business: 
	// given a current node, we want to fetch all immediate child nodes
	ics.CallElement( "UI/Data/Tree/TreeDataStore", null );
}
%>
</cs:ftcs>

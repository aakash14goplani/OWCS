<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.util.*"
%><cs:ftcs>
<%
String nodeKey = (String)request.getParameter("nodeKey");
// TODO hardcoded string
if ( "init".equals( nodeKey ) ) {
	// system pane always shows the history tree
	String tabs = ics.GetVar( "tabs" );
	if ( Utilities.goodString( tabs ) ) {
		tabs += "," + "CSSystem:TreeTabs:History"; // TODO history tab uid
	}
	ics.SetVar( "tabs", tabs );
	ics.CallElement( "UI/Data/Tree/TabDataStore", null );
}
else {
	// otherwise, this is normal tree business: 
	// given a current node, we want to determine its child nodes
	ics.CallElement( "UI/Data/Tree/TreeDataStore", null );
}
%>
</cs:ftcs>

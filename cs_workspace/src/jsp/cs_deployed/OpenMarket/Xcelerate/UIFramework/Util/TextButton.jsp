<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/Util/TextButton
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
<%
String _titlekey ="";
if(null != ics.GetVar("title")){%>
	<xlat:lookup  key='<%=ics.GetVar("title")%>' locale='<%=ics.GetVar("locale")%>' varname="_title"/>
	<% //If the title gets passed from some other element then the following would make 
		// sure that we dont show some garbage.
		if(ics.GetVar("_title").startsWith("Missing translation key"))
			_titlekey = "buttonkey";
		else
			_titlekey = "title";
	%>
<%} else {
	_titlekey = "buttonkey";
}
%>
<div data-dojo-type='fw.ui.dijit.Button' data-dojo-props='
	title: "<xlat:stream  key='<%=ics.GetVar(_titlekey)%>' locale='<%=ics.GetVar("locale")%>' />", 
	label: "<xlat:stream  key='<%=ics.GetVar("buttonkey")%>' locale='<%=ics.GetVar("locale")%>' />"
'></div>
</cs:ftcs>
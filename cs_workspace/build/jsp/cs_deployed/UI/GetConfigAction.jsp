<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="java.util.*"
%><cs:ftcs><%
// global configuration element
String globalConfig = "UI/Config/Global";
String suffix = "Html";
List<String> configElements = new ArrayList<String>();
configElements.add(globalConfig);
%>
<ics:sql sql="select * from ElementCatalog where elementname like 'UI/Config/%Html'" listname="configElements" table="ElementCatalog" />
<ics:listloop listname="configElements">
	<ics:listget listname="configElements" fieldname="elementname" output="element" />
	<%String element = ics.GetVar("element"); 
	String controllerElement;
	if (element != null && element.endsWith(suffix)) {
		controllerElement = element.substring(0, element.length() - suffix.length());
		// discard global config - already inserted
		if (!globalConfig.equals(controllerElement)) {
			configElements.add(controllerElement);
		}
	}
	%>
</ics:listloop>
<%request.setAttribute("configElements", configElements);%>
</cs:ftcs>
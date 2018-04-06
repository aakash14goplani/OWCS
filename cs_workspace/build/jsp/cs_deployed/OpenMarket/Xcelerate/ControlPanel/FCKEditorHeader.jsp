<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@
	taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%	
/*
	OpenMarket/Xcelerate/ControlPanel/FCKEditorHeader

    Outputs the JavaScript for the FCKEditor.

	INPUT

	OUTPUT

 */
%><cs:ftcs><%
    // Get the relative path of the FCKEditor installation
    String sBasePath = ics.GetVar("basepath");
%>
<script type="text/JavaScript" src="<%=sBasePath%>fckeditor.js"></script>
</cs:ftcs>
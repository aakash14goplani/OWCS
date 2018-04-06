<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="com.openmarket.xcelerate.publish.EmbeddedLink"
%><cs:ftcs><%
	String fieldData = (String) request.getAttribute("fieldData");
	String _fieldData = fieldData.replaceAll("(?i)<script[^>]*>.*?</script[^>]*>","");
	EmbeddedLink link = new EmbeddedLink(ics,_fieldData,false,false,true);
	String ret = link.evaluate();
%><%= org.apache.commons.lang.StringEscapeUtils.escapeHtml(ret)%></cs:ftcs>
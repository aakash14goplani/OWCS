<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="proxy" uri="futuretense_cs/proxy.tld"
%><%@ page import="org.codehaus.jettison.json.JSONArray"
%><%@ page import="org.codehaus.jettison.json.JSONObject"
%><cs:ftcs><proxy:tojson store="${store}" total="${totalRows}" /></cs:ftcs>
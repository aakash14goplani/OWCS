<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" %>
<%//
// fatwire/wem/ui/Wemcontext
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="com.fatwire.util.LocaleUtil"%>

<cs:ftcs>

<usermanager:getloginuser varname="loginuser"/>
<usermanager:getusername varname="loginusername" user='<%=ics.GetVar("loginuser")%>' />

<%
JSONObject contextJSONObject = new JSONObject();
contextJSONObject.put("user",ics.GetVar("loginuser"));
contextJSONObject.put("username",ics.GetVar("loginusername"));
contextJSONObject.put("locale",LocaleUtil.getUserLocale(ics,request.getLocales()));
%>
<%=contextJSONObject.toString()%>
</cs:ftcs>
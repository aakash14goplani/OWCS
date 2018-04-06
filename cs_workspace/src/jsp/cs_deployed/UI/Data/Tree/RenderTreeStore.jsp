<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="java.util.List"
%><%@ page import="com.fatwire.services.beans.entity.TreeNodeBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="org.codehaus.jackson.map.annotate.JsonSerialize"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
	try 
	{
		List<TreeNodeBean> nodeList = (List<TreeNodeBean>) request.getAttribute("nodeList");
		//convert the list to json
		//as we do not want to serilaise the null values, set the serialization config to 
		//have JsonSerialize.Inclusion.NON_NULL  which allows us not to serialize null values.
		ObjectMapper mapper = new ObjectMapper();
		mapper.getSerializationConfig().setSerializationInclusion(JsonSerialize.Inclusion.NON_NULL);
		String json = mapper.writeValueAsString(nodeList);
	%>
	{
		"identifier": "nodeId",
		"label":"name",
		"items": <%=json%>
	}
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>
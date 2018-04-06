<%@page import="java.util.Map"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="java.util.List"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="java.net.URLEncoder"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {	
	List<UISearchResultBean> results = GenericUtil.emptyIfNull((List<UISearchResultBean>)request.getAttribute("results"));
	List<UISearchResultBean> pagedResults = GenericUtil.buildPaginationList(NumberUtils.toInt(request.getParameter("start")), NumberUtils.toInt(request.getParameter("count"), 10), results);
	List<Map<String, Object>> jsonResults = GenericUtil.transformList(pagedResults, new GenericUtil.Transformer<UISearchResultBean, Map<String, Object>> () {
		public Map<String,Object> transform(UISearchResultBean item) {
			return item.getFields();
		}
	});	
	%>{"identifier": "id", "numRows":<%= results.size()%>,"items":<%= new ObjectMapper().writeValueAsString(jsonResults)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
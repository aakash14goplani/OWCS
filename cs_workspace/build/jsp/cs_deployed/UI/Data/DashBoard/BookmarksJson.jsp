<%@page import="java.util.Map"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ page import="java.net.URLEncoder"
%><%@page import="java.util.HashMap"
%><cs:ftcs><%
try {
	List<UISearchResultBean> results = GenericUtil.emptyIfNull((List<UISearchResultBean>)request.getAttribute("result"));	
	List<Map<String, Object>> jsonResults = GenericUtil.emptyIfNull(GenericUtil.transformList(results, new GenericUtil.Transformer<UISearchResultBean, Map<String, Object>> () {
		public Map<String,Object> transform(UISearchResultBean item) {
			Map<String, Object> fields = new HashMap<String, Object>(GenericUtil.emptyIfNull(item.getFields()));			
			return fields;
		}
	}));	
%>{"identifier": "id", "items":<%= new ObjectMapper().writeValueAsString(jsonResults)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
<%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.services.beans.search.SearchCriteria"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.search.SmartList"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="java.util.Arrays"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@page import="com.fatwire.services.beans.response.MessageCollectors.SmartListMessageCollector"
%><%@page import="com.fatwire.ui.util.SearchUtil"%><cs:ftcs><%
try {
	String userName = GenericUtil.getLoggedInUserName(ics);
	long siteId = GenericUtil.getLoggedInSite(ics);
	String name = StringUtils.defaultString(request.getParameter("saveSearchName"));
	String saveSearchId = StringUtils.defaultString(request.getParameter("saveSearchId"));
	String searchType = StringUtils.defaultString(request.getParameter("searchType"));
	List<String> rolesList = GenericUtil.asList(request.getParameterValues("roles"));
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService =  servicesManager.getSearchService();

	SmartList smartList = new SmartList();
	smartList.setSiteId(siteId);
	smartList.setName(name);
	smartList.setUserName(userName);
	smartList.getRoles().addAll(rolesList);

	if(StringUtils.equalsIgnoreCase(searchType, "advanced")) {
		smartList.setPostPage(SmartList.SearchType.ADVANCED);
	} else {
		smartList.setPostPage(SmartList.SearchType.SIMPLE);
	}
	if(StringUtils.isNotBlank(saveSearchId)) {
		smartList.setId(Long.parseLong(saveSearchId));
	}
	SearchCriteria searchCriteria = SearchUtil.createSearchCriteriaForSaveSearch(ics, request, siteId);
	smartList.setSearchCriteria(searchCriteria);
	final SmartListMessageCollector collector = new SmartListMessageCollector();
	boolean result = searchService.saveSmartList(smartList,collector);
	request.setAttribute("message", collector.getMessage());
	request.setAttribute("result", new Boolean(result));
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
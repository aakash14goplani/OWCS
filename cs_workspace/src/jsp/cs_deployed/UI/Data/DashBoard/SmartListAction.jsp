<%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="java.util.*"
%><%@page import="com.fatwire.services.beans.search.SmartList"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UISmartListBean"
%><%@ page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>
<% 
	//Call to filter/encode all request Input Parameter Strings
%>
<ics:callelement element="UI/Utils/encodeParameters"/>  
<%
try {
	// get the search service
	final ICS _ics = ics;
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService =  servicesManager.getSearchService();
	List<SmartList> saveSearchList = searchService.getSmartLists();

	// build list of ui beans that has the smartlists
	List<UISmartListBean> saveSearchData = GenericUtil.transformList(saveSearchList, new GenericUtil.Transformer<SmartList, UISmartListBean> () {
		public UISmartListBean transform(SmartList smartList) {
			return new UISmartListBean(_ics, smartList);
		}
	});
	request.setAttribute("saveSearchData", saveSearchData);	
} catch(Exception e) {
	e.printStackTrace();
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="proxy" uri="futuretense_cs/proxy.tld"
%><%@ page import="org.codehaus.jettison.json.*"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.sun.jersey.api.client.*"
%><%@ page import="com.sun.jersey.api.client.config.*"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="java.net.URLEncoder"
%><%@ page import="javax.xml.bind.DatatypeConverter"
%><%@ page import="java.util.*"
%><%@ page import="com.openmarket.xcelerate.util.ConverterUtils"
%><%@page import="com.fatwire.services.beans.search.SearchCriteria"
%><%@page import="com.fatwire.services.beans.search.SmartList"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><cs:ftcs><%
try {
// set proxy if specified in resargs
String proxyHost = ics.GetVar("proxyHost");
String proxyPort = ics.GetVar("proxyPort");
if (Utilities.goodString(proxyHost)) {
	System.setProperty("http.proxyHost", proxyHost);
	if (Utilities.goodString(proxyPort)) {
		System.setProperty("http.proxyPort", proxyPort);
	}
}

// determine start index
String start = ics.GetVar("start");
int startIndex = 1; 
if (Utilities.goodString(start)) {
	startIndex = Integer.valueOf(start) + 1; // youtube start index is 1-based, ours is 0-based
}

// this is the search term
String searchTerm = ics.GetVar("searchText");
if (!Utilities.goodString(searchTerm)) {
	searchTerm = "";
}

// in case of a saved search, get the search term from the saved search.
String searchType = request.getParameter("searchType");
if(StringUtils.equalsIgnoreCase(searchType, "runSaveSearch")) {
	long ssId = NumberUtils.toLong(StringUtils.defaultString(request.getParameter("saveSearchId")));
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService =  servicesManager.getSearchService();
	SmartList savedSearch = searchService.getSmartList(ssId);
	if(savedSearch != null) {
		SearchCriteria searchCriteria = savedSearch.getSearchCriteria();
		searchTerm = searchCriteria.getPhrase();
	}
}

//handle sort
String sort = request.getParameter("sort");
if(sort != null && StringUtils.isNotEmpty(sort)){
	// incase of decending sort UI sends the field with a -ve sign, 
	// You Tube doesn't take as is, so remove the -ve sign if any
	sort.trim();
	if(sort.startsWith("-")){
		 sort = sort.substring(1,sort.length());
	}
}else{
	sort = "relevance";
}

// build YouTube URL
String baseYtURL = "http://gdata.youtube.com/feeds/api/videos";
StringBuffer ytQuery = new StringBuffer(baseYtURL);
ytQuery.append("?format=5");
ytQuery.append("&alt=json");
ytQuery.append("&max-results=" + ics.GetVar("count")); // number of results per page
ytQuery.append("&start-index=" + String.valueOf(startIndex));
ytQuery.append("&orderby="+sort); // ordering
ytQuery.append("&q=").append(URLEncoder.encode(searchTerm));
Client client = Client.create();
ClientResponse resp;
WebResource res;
try {
	res = client.resource(ytQuery.toString());
	resp = res.accept("application/json").get(ClientResponse.class);
}
catch(Exception e) {
	// propagate exception to client-side
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	e.printStackTrace();
	throw e;
}

JSONArray list = new JSONArray(); // incoming list of videos

// as per You Tube API documentation, we won't be able to request beyond 1000 results 
// even if there are more . So limit the total to 1000.
// (i.e) the limitaion is  max-results+start-index can't exceed more than 1000.
String total = "1000"; // total number of results

if (resp.getStatus() == 200) {
	JSONObject json = new JSONObject(resp.getEntity(String.class));
	// get the feed object
	JSONObject feed = json.getJSONObject("feed");
	//ics.LogMsg(feed.toString());
	// the 'entry' property contains the list of videos	
	
	// some times the JSON Object doesn't have "entry".
	// This happens when queried with max-results+start-index is more than 980
	// so check if "entry" exists.
	if(feed.has("entry")){
		list = feed.getJSONArray("entry");
	}
}

// create a store
%>
<proxy:createstore store="assets" />
<% // for each incoming video
for (int i = 0; i < list.length(); i++) {
	JSONObject item = list.getJSONObject(i);
	// get the id, title and thumbnail URL
	String id = item.getJSONObject("id").getString("$t").substring(baseYtURL.length() + 1);
	String title = item.getJSONObject("title").getString("$t");
	// temporary workaround for bug #16542369 - arbitrarily restricting title length to 32 chars
	if (title.length() > 32) title = title.substring(0, 32);
	// get updated date - format is ISO8601
	String updated = item.getJSONObject("updated").getString("$t");
	Calendar cal = DatatypeConverter.parseDateTime(updated);
	Date updatedDate = cal.getTime();
	// get video stats, if available
	JSONObject stats = null;
	if (item.has("yt$statistics")) stats = item.getJSONObject("yt$statistics");
	String viewed = stats != null ? stats.getString("viewCount") : "N/A";
	// get video thumbnail
	JSONObject thumbnailURL = item.getJSONObject("media$group").getJSONArray("media$thumbnail").getJSONObject(1);
	// register proxy asset %>
	<proxy:register externalid='<%=id %>' type="YouTube" name='<%=title %>' varname="internalid" />
	<% // add proxy asset to store %>
	<proxy:addstoreitem store="assets" id='<%=ics.GetVar("internalid") %>' type="YouTube">
		<proxy:argument name="thumbnailURL" value='<%=thumbnailURL.getString("url") %>' />
		<proxy:argument name="updateddate" value='<%=ConverterUtils.getLocalizedDate(ics, updatedDate) %>' />
		<proxy:argument name="viewed" value='<%=viewed %>' />
	</proxy:addstoreitem><%
}

// set store name and totalRows in request
request.setAttribute("store", "assets");
request.setAttribute("totalRows", total);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>
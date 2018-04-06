<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/Publish/PublishingConsole
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="com.fatwire.realtime.util.Util"%>
<%@ page import="com.openmarket.basic.dateformat.DateFormat"%>
<%@ page import="org.apache.commons.lang.time.DurationFormatUtils"%>
<cs:ftcs>
<%
if ("createSessionList".equals(ics.GetVar("publishHistoryAction")))
    { 
		java.util.ArrayList al = new java.util.ArrayList();
		request.setAttribute("seesionIdList",al);
	} else if ("addToSessionList".equals(ics.GetVar("publishHistoryAction")))
    {
	java.util.ArrayList al =  (java.util.ArrayList)request.getAttribute("seesionIdList");
	al.add(ics.GetVar("pubsess:id"));
	}else if ("createCheckbox".equals(ics.GetVar("publishHistoryAction")))
    {%>
	<input type="checkbox" value='<%=ics.GetVar("pubsess:id")%>' name="delPubSess" onclick="changeRowColor(this)"/>
	<%}else if ("getSessionIdsString".equals(ics.GetVar("publishHistoryAction")))
	{
		int fetchSize = Integer.parseInt((ics.GetVar("pubSessionHistory:rows")));
		int displayPage = Integer.parseInt((ics.GetVar("pubSessionHistory:displayPage")));
		int count = Integer.parseInt((ics.GetVar("pubSessionHistory:total")));
		double totalPages = Math.ceil((double)count/fetchSize);
		if(displayPage > (int)totalPages){
			displayPage = (int)totalPages;
			ics.SetVar("displayPage",displayPage);
		}
		int start = (displayPage - 1)*fetchSize;
		int last =  displayPage*fetchSize - 1;
		int startIndex = start + 1;
		int endIndex = 0;
		StringBuffer sb = new StringBuffer();
		for(int i=start;i <= last;){
			if(i < count){
				endIndex = i + 1;
				sb.append(((Long)ics.GetObj("sessionIds:"+i)).longValue());
			}
			if(++i <= last && i < count){
				sb.append(";");
			}
		}
		ics.SetVar("sessionIdsString",sb.toString());
		ics.SetVar("displayPage:startIndex",String.valueOf(startIndex));
		ics.SetVar("displayPage:endIndex",String.valueOf(endIndex));
		ics.SetVar("pubSessionHistory:totalPages",String.valueOf((int)totalPages));
	} else if ("checkEquals".equals(ics.GetVar("publishHistoryAction")))
	{
		String param1 = ics.GetVar("param1");
		String param2 = ics.GetVar("param2");
		if(param1.equals(param2)){
			ics.SetVar(ics.GetVar("output"),"true");
		} else {
			ics.SetVar(ics.GetVar("output"),"false");
		}
	} else if ("populateToolTip".equals(ics.GetVar("publishHistoryAction")))
	{
		String startDateStr =  ics.GetVar("publishstartdate");
		String endDateStr =  ics.GetVar("publishenddate");
		String toolTip = "<table>";
		//Support for database upgrade for older systems.The date column might not contain anything.
		if(startDateStr != null && startDateStr.trim().length() !=0){
			toolTip += "<tr><td> " + Util.xlatLookup(ics, "dvin/UI/StartTime", true, true) + " </td><td>" + startDateStr + "</td></tr>";
		}
		if(endDateStr != null && endDateStr.trim().length() !=0){
			toolTip += "<tr><td> " + Util.xlatLookup(ics, "dvin/UI/EndTime", true, true) + " </td><td>" + endDateStr + "</td></tr>" ;
		}
		DateFormat dateformat = (DateFormat)ics.GetObj("_FormatDate_");
		String duration ="";
		if(startDateStr != null && startDateStr.trim().length() !=0 && endDateStr != null && endDateStr.trim().length() !=0){
			Date startdate = dateformat.parseDateTime(startDateStr);
			Date enddate = dateformat.parseDateTime(endDateStr);
			long timeDiff =  enddate.getTime() - startdate.getTime();
			duration = DurationFormatUtils.formatDuration(timeDiff, Util.xlatLookup(ics, "dvin/UI/TimeFormatForDurationUtils", false, false), false);
			if (Character.isDigit(duration.charAt(0)))
				duration = duration.replaceAll("(?<!\\d)0.*?(?=\\d|\\z)", "");
			else
				duration = duration.replaceAll("[^\\d]+0", "");
			if (!Utilities.goodString(duration))
				duration = Util.xlatLookup(ics, "dvin/UI/zeroseconds", true, true);
			toolTip += "<tr><td> " + Util.xlatLookup(ics, "dvin/UI/TotalTime", true, true) + " </td><td>" + duration + "</td></tr>";
		}
		if("done".equals(ics.GetVar("pubsess:status"))){
			toolTip += "<tr><td> " + Util.xlatLookup(ics,"dvin/UI/AssetCount", true, true) + " </td><td>" + ics.GetVar("pubsess:assetcount") + "</td></tr>";
		} else {
			toolTip += "<tr><td NOWRAP=NOWRAP> " + Util.xlatLookup(ics, "dvin/UI/StatusMessage", true, true) + " </td><td>" + ics.GetVar("pubsess:statusmsg") + "</td></tr>";
		}
		toolTip += "</table>";
		ics.SetVar("pubsess:toolTip",toolTip.replaceAll("'", "\\\\'"));
	} else if("setDepMapInICS".equals(ics.GetVar("publishConsoleFrontAction"))){
		HashMap<String,List> odMap = (HashMap)session.getAttribute("ODQueue:" + ics.GetVar("target"));
		if(odMap != null){
		ics.SetObj("ODQueue:" + ics.GetVar("target"),odMap);
		ics.SetVar("ODQueue:Length",odMap.size());
	}
}%>
</cs:ftcs>

<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.*"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.services.ui.beans.LabelValueBean"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="org.codehaus.jackson.type.TypeReference"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><xlat:lookup key="UI/Search/ViewFullSizeImage" escape="true" varname="viewfullsizeimage"/>
<xlat:lookup key="UI/Search/NoImage" escape="true" varname="noimage"/>
<%
try {
	
	//get the json data from client and convert to java object
	// this data is for display text we show for each image
	String jsonData = request.getParameter("displayData");
	List<LabelValueBean> displayBeans = new ArrayList<LabelValueBean>();
	if(StringUtils.isNotBlank(jsonData)) {
		displayBeans =  new ObjectMapper().readValue(jsonData, new TypeReference<List<LabelValueBean>>(){});
	}
	String id = StringUtils.defaultString(request.getParameter("id"));
	String type = StringUtils.defaultString(request.getParameter("type"));
	String url = StringUtils.isNotBlank(request.getParameter("id")) ? "ImageRendererServlet?id=" + id + "&assettype=" + type + "&attribute=" + StringUtils.defaultString(request.getParameter("attribute")) : "";
	String name = StringUtils.defaultString(request.getParameter("name"));
	String viewMode = StringUtils.defaultString(request.getParameter("viewMode"));
	String docType = StringUtils.defaultString(request.getParameter("docType"), "asset");
	String docId = StringUtils.defaultString(request.getParameter("docId"), type+ ":"+id);
	String tooltipImageUrl = url;
	StringBuilder buf = new StringBuilder();
	StringBuilder builder = new StringBuilder();
	String fileName = name;
	if(GenericUtil.isSupported(ics,type)){
		builder.append("<a href= \"#\" onclick=\"fw.ui.GridFormatter.open('").append(docType).append("' , '").append(docId).append("')\"");
		if(StringUtils.equals(viewMode, "normal")){
			builder.append(" title=\"" + name + "\"");
		}
		builder.append(">"+name+"</a>");
	}
	else{
		builder.append(name);
	}
	if(StringUtils.isNotBlank(url)) {
		tooltipImageUrl = url;
		buf.append("<div class='thumbnailSearchContent'>");
		buf.append("<div class='thumbnailImage'><a><img src='");
		if(StringUtils.equals(viewMode, "normal")) {
			url += "&width=170&height=170";
		} else if(StringUtils.equals(viewMode, "dock")) {
			url += "&width=96&height=96";
		}
		buf.append(url);
		buf.append("' alt='' /></a></div>");
		if(CollectionUtils.isNotEmpty(displayBeans)) {
			buf.append("<div class='thumbnailSearchLabel'>");
			for(LabelValueBean displayBean : displayBeans) {
				if(StringUtils.equalsIgnoreCase(displayBean.getLabel(), "name")) {
					buf.append("<div class='thumbnailSearchLabelTitle'><div class='ellipsis'><strong>").append(builder).append("</strong></div></div>");
					fileName = displayBean.getValue();
				} else {
					if(displayBean.getValue() != null && StringUtils.isNotBlank(displayBean.getValue())){
						buf.append("<strong>").append(displayBean.getLabel()).append(":</strong> ").append(displayBean.getValue()).append("<br />");
					}
				}
				// For "dock" view show the first item from the display list
				if(StringUtils.equals(viewMode, "dock"))
					break;
			}
			buf.append("</div>");
		}	
		buf.append("<div class='enlargeImageIcon'><a href='#' alt='' title='"+ ics.GetVar("viewfullsizeimage")+"' onclick=\"fw.ui.GridFormatter.openFullImage('").append(fileName).append("','").append(tooltipImageUrl).append("')\">&nbsp;</a></div>");
	} else {
		buf.append( "<img src='js/fw/images/ui/ui/search/noImage.png' alt='"+ics.GetVar("noimage")+"' width='170' height='170' />");
	}
%><%=buf.toString()%><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
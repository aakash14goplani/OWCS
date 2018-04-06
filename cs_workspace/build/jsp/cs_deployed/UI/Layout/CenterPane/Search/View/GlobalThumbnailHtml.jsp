<%@page import="com.fatwire.ui.util.FileCheckUtil"
%><%@page import="org.codehaus.jackson.type.TypeReference"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ page import="com.fatwire.services.ui.beans.LabelValueBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><xlat:lookup key="UI/Search/NoImage" escape="true" varname="noimage"/><%
try {
	String jsonData = request.getParameter("displayData");
	List<LabelValueBean> displayBns = null;
	if(StringUtils.isNotBlank(jsonData)) {
		displayBns = GenericUtil.emptyIfNull((List<LabelValueBean>) (new ObjectMapper().readValue(jsonData, new TypeReference<List<LabelValueBean>>(){})));	
	}

	String url = "";
	StringBuffer buf = new StringBuffer();
	String name = StringUtils.defaultString(request.getParameter("name"));
	String id = StringUtils.defaultString(request.getParameter("id"));
	String type = StringUtils.defaultString(request.getParameter("type")).replaceAll(" ", "_");
	String subType = StringUtils.defaultString(request.getParameter("subtype")).replaceAll(" ", "_");
	String viewMode = StringUtils.defaultString(request.getParameter("viewMode"));
	String imageFolder = "images/search/";
	String docType = StringUtils.defaultString(request.getParameter("docType"), "asset");
	String docId = StringUtils.defaultString(request.getParameter("docId"), type+ ":"+id);
	StringBuilder builder = new StringBuilder();
	if(GenericUtil.isSupported(ics,type)){
		builder.append("<a href= \"#\" onclick=\"fw.ui.GridFormatter.open('").append(docType).append("' , '").append(docId).append("')\"");
		if(StringUtils.equals(viewMode, "normal")){
			builder.append(" title=\"" + name + "\"");
		}
		builder.append(">"+name+"</a>");
	}else{
		builder.append(name);
	}
	if(StringUtils.isNotBlank(type)) {
		if(StringUtils.equals(viewMode, "normal")) {
			if(!subType.equalsIgnoreCase("")){
				url = imageFolder + type +"-"+subType+ "_large.jpg";
				//if the image for assetType-subType doesn't exists fall back to just assetType image
				if(!FileCheckUtil.exists(application, url)) {
					url = imageFolder + type + "_large.jpg";
				}
			}else{
				url = imageFolder + type + "_large.jpg";
			}	
			if(!FileCheckUtil.exists(application, url)) {
				url = imageFolder+"Default_large.jpg";
			}
		} else if(StringUtils.equals(viewMode, "dock")) {
			if(!subType.equalsIgnoreCase("")){
				url = "images/search/" + type +"-"+subType+ ".jpg";
				//if the image for assetType-subType doesn't exists fall back to just assetType image
				if(!FileCheckUtil.exists(application, url)) {
					url = imageFolder + type + ".jpg";
				}
			}else{
				url = imageFolder + type +".jpg";
			}	
			if(!FileCheckUtil.exists(application, url)){
				url = imageFolder+"Default.jpg";
			}
		}
		buf.append("<div class='thumbnailSearchContent'>").append("<div class='thumbnailImage'><a><img src='").append(url).append("' alt='' /></a></div>");
		if(CollectionUtils.isNotEmpty(displayBns)) {
			buf.append("<div class='thumbnailSearchLabel'>");
			for(LabelValueBean bn : displayBns) {
				if(bn.getLabel() != null && bn.getLabel().equalsIgnoreCase("name")) {
					buf.append("<div class='thumbnailSearchLabelTitle'><div class='ellipsis'><strong>").append(builder).append("</strong></div></div>");
				} else {
					if(bn.getValue() != null && StringUtils.isNotBlank(bn.getValue())){
						buf.append("<strong>" + bn.getLabel() + ":</strong> " + bn.getValue()).append("<br />");
					}
				}
				// For dock view show the first item
				if(StringUtils.equals(viewMode, "dock"))
					break;
			}
			buf.append("</div>");
		}else{
			buf.append("</div>");
		}
	} else {
		buf.append( "<img src='js/fw/images/ui/ui/search/noImage.png' alt='"+ics.GetVar("noimage")+"' width='170' height='170' />");
	}
%><%=buf%><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
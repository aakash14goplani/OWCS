<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="org.codehaus.jackson.type.TypeReference"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<cs:ftcs>
<xlat:lookup key="CG/ViewFullSizeImage" escape="true" varname="viewfullsizeimage"/>
<xlat:lookup key="CG/NoImage" escape="true" varname="noimage"/>
<ics:setvar name="cgId" value='<%=StringUtils.defaultString(request.getParameter("id"))%>'/>
<ics:setvar name="cgAssetType" value='<%=StringUtils.defaultString(request.getParameter("type"))%>'/>
<ics:callelement element="CG/GetParameters"/>
<%
try {
	
	String jsonData = request.getParameter("displayData");
	List<LabelValueBean> displayBeans = new ArrayList<LabelValueBean>();
	if(StringUtils.isNotBlank(jsonData)) {
		displayBeans =  new ObjectMapper().readValue(jsonData, new TypeReference<List<LabelValueBean>>(){});
	}
	String bigImageUrl = ics.GetVar("cgManagementUrl");
	String smallImageUrl = ics.GetVar("cgManagementUrl");
	if ("CGGadget".equals(ics.GetVar("cgAssetType")))
	{
		bigImageUrl  += "/gadgets-rest/v0.1/" + ics.GetVar("cgSiteName") + "/registry/" + ics.GetVar("cgPreviewImg") + "/preview.png";
	 	smallImageUrl  += "/gadgets-rest/v0.1/" + ics.GetVar("cgSiteName") + "/registry/" + ics.GetVar("cgThumbnailImg") + "/thumbnail.png";
	}
	else 
	{
		bigImageUrl  += "/images/cg-integration/170x170/" + ics.GetVar("cgFullTagName") + ".jpg";
	 	smallImageUrl  += "/images/cg-integration/96x96/" + ics.GetVar("cgFullTagName") + ".jpg";
	}

	String name = StringUtils.defaultString(request.getParameter("name"));
	String title = "<a href=\"#\" onclick=\"fw.ui.GridFormatter.open('" + name + "','proxy','" + request.getParameter("docId") + "')\">" + name + "</a>";
	String viewMode = StringUtils.defaultString(request.getParameter("viewMode"));//normal, dock
%>

<div class="thumbnailSearchContent">
	<div class="thumbnailImage"><a><img src="<%=smallImageUrl%>" alt="" /></a></div>
	<div class="thumbnailSearchLabel">
	<%
		for (LabelValueBean displayBean : displayBeans)
		{
			if (StringUtils.equalsIgnoreCase(displayBean.getLabel(), "name"))
			{
				%><div class='thumbnailSearchLabelTitle'><div class='ellipsis'><strong><%=title%></strong></div></div><%
			}
			else if (displayBean.getValue() != null && StringUtils.isNotBlank(displayBean.getValue()))
			{
				%><strong><%=displayBean.getLabel()%></strong>: <%=displayBean.getValue()%><br /><%
			}
			if (StringUtils.equals(viewMode, "dock"))
			{
				break;
			}
		}
	%>
	</div>
	<div class="enlargeImageIcon"><a href="#" alt="" title="<%=ics.GetVar("viewfullsizeimage")%>" onclick="fw.ui.GridFormatter.openFullImage('<%=name%>','<%=bigImageUrl%>')">&nbsp;</a></div>
<%	
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>
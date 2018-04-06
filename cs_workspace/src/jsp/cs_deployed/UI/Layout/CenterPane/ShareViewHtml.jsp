<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Layout/CenterPane/Search/View/SaveSearchViewHtml
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
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.net.URLEncoder"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<cs:ftcs>


<%
	StringBuffer urlBuf = new StringBuffer();
	urlBuf.append("ContentServer?pagename=fatwire/ui/controller/controller&elementName=UI/Actions/Asset/Share/EnabledSites&responseType=json");
	String assetData = StringUtils.defaultString(request.getParameter("assetData"));
	assetData = URLEncoder.encode(assetData, "UTF-8");
    if(assetData != null)
    {
    	urlBuf.append("&assetData="+assetData);
    }   
%>

<div id="shareViewContainer" class="shareSearchContainer searchDisplayPaneContainer">
	<h3><xlat:stream key="UI/UC1/Layout/ShareContent1"/></h3>
	<div><xlat:stream key="UI/UC1/Layout/ShareContent2"/></div>
	<div dojoType="dojo.data.ItemFileReadStore"
		jsId="sitestore"
		url="<%=urlBuf.toString()%>"
		requestMethod="post">
	</div>
	<div id="transferBoxId" class="transferBox">
		<select dojotype="fw.dijit.UITransferBox"
			id="siteTransferBox"
			name="siteTransferBox"
			required="true"
			size="8"
			store="sitestore"
			storeStructure="{title:'name', value:'id'}"
			title1="<xlat:stream key="dvin/Common/Available"/>" title2="<xlat:stream key="dvin/Common/Selected"/>">
		</select>
	</div>
	<input id="allSiteCheck" data-dojo-type="dijit.form.CheckBox" data-dojo-props="name:'allSiteCheck',checked:false" />
	<label for="allSiteCheck"><xlat:stream key="UI/UC1/Layout/ShareContent3"/></label>
</div>
	
</cs:ftcs>
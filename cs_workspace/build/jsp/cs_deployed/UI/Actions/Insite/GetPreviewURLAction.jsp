<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.dao.helper.Tags"%>
<%@page import="COM.FutureTense.Interfaces.*"
%><%@page import="COM.FutureTense.Util.*"
%><%@page import="com.fatwire.services.constants.ServiceConstants"
%><%@page import="java.text.ParseException"
%><%@page import="java.text.SimpleDateFormat"
%><%@page import="java.text.DateFormat"
%><%@page import="java.util.Date"
%><%@page import="java.util.TimeZone"
%><%@page import="com.openmarket.xcelerate.publish.PubConstants"
%><%@page import="com.openmarket.xcelerate.util.ConverterUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@page import="com.fatwire.services.ui.beans.UIPreviewURLBean"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="com.fatwire.mobility.beans.SkinInfoBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@ page import="com.openmarket.xcelerate.asset.SitePlanAsset"%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils, java.util.List"%>
<%@ page import="com.fatwire.cs.ui.framework.LocalizedMessages"%>

<%!
// site Preview related util methods:
public static Date toDate(final String strDate) {
	Date date = null;
	try {
		date = new SimpleDateFormat(ServiceConstants.DB_DATE_FORMAT).parse(strDate);
	} catch (ParseException ex) {
		date = null;
	}
	return date;
}
%><cs:ftcs>

<%
	//Call to filter/encode all request Input Parameter Strings
%>
<ics:callelement element="UI/Utils/encodeParameters"/> 
<ics:getproperty file="futuretense_xcel.ini" name="xcelerate.previewhost" output="preview-host"/>
<ics:getproperty file="futuretense_xcel.ini" name="xcelerate.previewservlet" output="preview-servlet"/>
<%
// TODO 1 - move this logic to InsiteDataService.buildPreviewURL(...)
// TODO 2 - common customization = modify preview URL to point to third-party system in 
//			charge of delivery => no c/cid which should effectively disable presentation
//			editing capabilities (Slots cannot work without a primary asset id/type)
//			Make sure that this use case is easily doable with new framework.
//

try{
String assetId = ics.GetVar("cid");
String assetType = ics.GetVar("c");
String mode = ics.GetVar("mode");
String tname = ics.GetVar("tname");
String suffix = ics.GetVar("suffix");
String deviceid = ics.GetVar("deviceid");

/* if (null == ics.GetVar("suffix"))
{
	SitePlanAsset spAsset = MobilityUtils.getSiteplanForAsset(ics, ics.GetVar("c"), Long.parseLong(ics.GetVar("cid")));
	System.out.println("spAsset: " + spAsset);
	List<SkinInfoBean> skinList = null;
	if (null != spAsset)
	{
		skinList = MobilityUtils.getSkinsForSiteplan(ics, Long.parseLong(spAsset.Get("id")));
		if (skinList.size() > 0)
			suffix = skinList.get(0).getDeviceGroupSuffix();
	}
	else
	{
		//skinList = MobilityUtils.getSkinsForSite(ics);
		suffix = "";
	}
} */

if (null == ics.GetVar("suffix"))
	suffix = "";

tname = MobilityUtils.getBaseTemplateName(ics, tname);
UIPreviewURLBean previewURLBean = new UIPreviewURLBean();


if (!Utilities.goodString(mode)) {
	mode = "preview";
}


if (!Utilities.goodString(tname)) {%>
	<asset:load name="theAsset" type='<%=assetType%>' objectid='<%=assetId%>' />
	<asset:get name="theAsset" field="template" output="previewTemplate" />
	<%
	// TODO - what if the template is not shared on the current site
	tname = ics.GetVar("previewTemplate");
}

/*
 * For wrappers the precedence is as follows:
 * 1. Check if there is a wrapper specified in the request
 * 2. Check if the site has a default wrapper
 * 3. Query the list of wrappers and choose the first value
 * If at the end of this the wrapper is still null, the if tags take care not to pass it
 */
 
 	TimeZone userTimeZone = TimeZone.getTimeZone(ics.GetSSVar("time.zone"));
 	String userLocale = LocalizedMessages.getLocaleString(ics);

// Check the request
	String wrapper = ics.GetVar("wrapper");
	if (!Utilities.goodString(wrapper)) {
		// Check in the site %>
		<publication:load name='theSite' objectid='<%= ics.GetSSVar("pubid")%>' />
		<publication:get name='theSite' field='cs_wrapperasset' output='wrapperAssetId' /><%
		// TODO: We might need to revisit whether we want to have the pagename reference in the SiteEntry record.
		String wrapperAssetId = ics.GetVar("wrapperAssetId");
		if (Utilities.goodString(wrapperAssetId)) {
			String [] wrapperAssetIdArr = wrapperAssetId.split(":");
			String c = wrapperAssetIdArr[0];
			String cid = wrapperAssetIdArr[1]; %>
			<asset:load name='wrapperAsset' type='<%= c%>' objectid='<%= cid%>' />
			<asset:get name='wrapperAsset' field='pagename' output='wrapper' /><%
			wrapper = ics.GetVar("wrapper");
		}
		if (!Utilities.goodString(wrapper)) {
			// Query the list of wrappers %>
			<asset:list type="SiteEntry" list="wrapperList" field1="cs_wrapper" value1="y" pubid='<%=ics.GetSSVar("pubid") %>' excludevoided="true" /><%
			// Pick the first one
			IList wrapperList = ics.GetList("wrapperList");
			if (wrapperList != null && wrapperList.hasData()) {
				wrapper = wrapperList.getValue("pagename");
			}
		}
	}

	// Site Preview Date is now set in the session
	boolean isDatePreviewEnabled = ftMessage.cm.equals(ics.GetProperty(ftMessage.cssitepreview, "futuretense.ini", true));
		if (isDatePreviewEnabled) {
			String sitePreviewDate = ics.GetVar("sitePreviewDate");			
			if (Utilities.goodString(sitePreviewDate) && toDate(sitePreviewDate) != null) {
				previewURLBean.setSitePreviewDate(ConverterUtils.getLocalizedDate(toDate(sitePreviewDate), userTimeZone, userLocale));
				sitePreviewDate = ConverterUtils.convertJDBCDate(sitePreviewDate,ics.GetSSVar("time.zone"),TimeZone.getDefault().getID());
				ics.SetSSVar("__insiteDate", sitePreviewDate);
				
			} else {
				if (ics.GetSSVar("__insiteDate") != null) {
					ics.RemoveSSVar("__insiteDate");
				}
				String startDate = ics.GetVar("startDate");
				//if there is startdate , set the startdate as preview date else set to current date.
				if (Utilities.goodString(startDate) && toDate(startDate) != null){
					ics.SetSSVar("__insiteDate", startDate);
					previewURLBean.setSitePreviewDate(ConverterUtils.getLocalizedDate(toDate(startDate), userTimeZone, userLocale));
				}
				else{
					Date dt = new Date();
					DateFormat df = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", ConverterUtils.getLocaleObj(userLocale));
					sitePreviewDate = df.format(dt);
					ics.SetSSVar("__insiteDate", sitePreviewDate);
					previewURLBean.setSitePreviewDate(ConverterUtils.getLocalizedDate(toDate(sitePreviewDate), userTimeZone, userLocale));
				}
			}
		}
		// if date preview is not enabled show the current date in user timezone.
		else{
			Date dt = new Date();
			DateFormat df = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", ConverterUtils.getLocaleObj(userLocale));
			String sitePreviewDate = df.format(dt);
			previewURLBean.setSitePreviewDate(ConverterUtils.getLocalizedDate(toDate(sitePreviewDate), userTimeZone, userLocale));
		}

		Tags.getPageName(ics, assetType, tname, "pageName");		
		String previewhost = ics.GetVar("preview-host");		
		String previewServlet= ics.GetVar("preview-servlet");
		boolean isSatellite = "Satellite".equals(previewServlet);
		boolean isCustomURL = false;
		if(StringUtils.isNotBlank(previewhost))
		{	
			int index = previewhost.indexOf("//");			
			if(index > 0) {
				try {
				String scheme = previewhost.substring(0,previewhost.indexOf("//")-1);			
				String hostname =previewhost.substring(previewhost.indexOf("//")+ 2);		
			%><render:getpageurl	
					outstr="previewURL"	
					pagename='<%=ics.GetVar("pageName")%>'	
					c='<%=assetType%>'	
					cid='<%=assetId%>'
					satellite='<%= ""+isSatellite%>'
					scheme='<%=scheme %>'
					d='<%=suffix%>' 
					authority ='<%= hostname%>'
					wrapperpage = '<%= wrapper%>' 
					>					
				<render:argument name="rendermode" value='<%=mode %>'/>
				<render:argument name="deviceid" value='<%=deviceid %>'/>
			</render:getpageurl>
			<%
				isCustomURL = true;
				} catch(Exception e)
				{
					// wrong format host name is passed so using default
				}
			}
		}
		if (!isCustomURL) { 
			%><render:getpageurl
			outstr="previewURL"	
			pagename='<%=ics.GetVar("pageName")%>'	
			c='<%=assetType%>'	
			cid='<%=assetId%>'
			d='<%=suffix%>' 
			satellite='<%= ""+isSatellite%>'		
			wrapperpage = '<%= wrapper%>'
			>
			<render:argument name="rendermode" value='<%=mode %>'/>
			<render:argument name="deviceid" value='<%=deviceid %>'/>
			</render:getpageurl>
			<% 	
		}
		
		String segments = ics.GetVar("segments");
		
		if (segments != null)
		{	
			if ("_nosegments_".equals(segments))
				segments = "";
		%>
			<commercecontext:setsegments names="<%=segments%>" />
		<%			
		}
		
		previewURLBean.setPreviewURL(ics.GetVar("previewURL"));
		previewURLBean.setMode(mode);
		previewURLBean.setTname(tname);
		previewURLBean.setWrapper(wrapper);
		request.setAttribute("previewURLBean", previewURLBean);
		
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>
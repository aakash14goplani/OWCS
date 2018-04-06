<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Layout/CenterPane/SitePlanApprovalAction
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
<cs:ftcs>

<%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.ApprovalService"
%><%@page import="java.util.List"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.beans.entity.DestinationBean"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.services.beans.asset.ApprovalBean"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.ui.beans.UIDestinationBean"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="com.openmarket.xcelerate.asset.Asset,
				  com.openmarket.xcelerate.asset.SitePlanAsset,
				  com.openmarket.xcelerate.site.SitePlanNode,
				  COM.FutureTense.Interfaces.IList,
				  com.fatwire.mobility.util.MobilityUtils,
				  com.fatwire.mobility.beans.DeviceGroupBean,
				  com.fatwire.mobility.beans.SkinInfoBean,
				  com.openmarket.xcelerate.asset.AssetIdImpl"

%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%!

	private static final List<UIApprovalBean> getApprovalInfo(final ICS _ics, List<AssetId> assetIds, final long destinationId) {
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
		
		final ApprovalService approvalService = servicesManager.getApprovalService();
		final AssetService assetService = servicesManager.getAssetService();
		
		List<UIApprovalBean> result = GenericUtil.transformSourceList(assetIds, new GenericUtil.Transformer<AssetId, UIApprovalBean>() {
			public UIApprovalBean transform(AssetId assetId) {
				UIApprovalBean uiBean = null;
				try {
						ApprovalBean approvalState = approvalService.getState(destinationId, assetId);
						AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME));
						Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
						String name = nameData == null ? "" : String.valueOf(nameData);
						String type = AssetUtil.getAssetTypeDescription(assetData);
						uiBean = new UIApprovalBean(_ics, name, type, approvalState);
						uiBean.setSuccess(true);
				} catch (ServiceException e) {
					throw new UIException(e);
				}
				return uiBean;
			}
		}, new GenericUtil.Predicate<AssetId> () {
			public boolean evaluate(AssetId assetId) {
				try{
					return assetService.exists(assetId);
				}catch(ServiceException e){
					throw new UIException(e);	
				}
			}
		});
		
		return result;
	}


	private static final <T> void addApprovalBeansToList(ICS _ics, String assetType, final long destinationId, List<T> sourceList, List<UIApprovalBean> destinationList) {
		if (null == sourceList || null == destinationList) return;
		
		List<String> assets = new ArrayList<String>();
		
		try {
			for (T t : sourceList) {
				assets.add(assetType + ":" + t.getClass().getMethod("getId").invoke(t));
			}
		} catch (Exception e) {}
		
		List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(assets))));
		List<UIApprovalBean> approvalBeans = getApprovalInfo(_ics, assetIds, destinationId);
		
		if ( null != approvalBeans )
			destinationList.addAll(approvalBeans);
	}
	
	
	private static final void addApprovalBeansToList(ICS _ics, String assetType, final long destinationId, IList sourceList, List<UIApprovalBean> destinationList) {
		if (null == sourceList || null == destinationList) return;
		
		List<String> assets = new ArrayList<String>();
		
		try {
			if (sourceList.hasData())	{
				for (int i = 1; sourceList.moveTo(i); i++) {
					assets.add(assetType + ":" + sourceList.getValue("Id"));
				}
			}	
		} catch (java.lang.NoSuchFieldException e) {}
		
		List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(assets))));
		List<UIApprovalBean> approvalBeans = getApprovalInfo(_ics, assetIds, destinationId);
		
		if ( null != approvalBeans )
			destinationList.addAll(approvalBeans);
	}
%>
<cs:ftcs>
<%
	//Call to filter/encode all request Input Parameter Strings
%>
<ics:callelement element="UI/Utils/encodeParameters"/>  
<%
try {
	final ICS _ics = ics;
	final long destinationId = NumberUtils.toLong(request.getParameter("destinationId"), -1);
	final String destinationName = StringUtils.defaultString(request.getParameter("destinationName"));
	final String destinationType = StringUtils.defaultString(request.getParameter("destinationType"));
	final String responseType = ics.GetVar("responseType");
	
	List<UIApprovalBean> spAllRelatedApprovalBeans = new ArrayList<UIApprovalBean>();	
	
	// Add SitePlan
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(GenericUtil.asList(request.getParameterValues("assetIds"))))));
	spAllRelatedApprovalBeans.addAll(getApprovalInfo(_ics, assetIds, destinationId));
	
	if (null != responseType && !"html".equalsIgnoreCase(responseType)) {
		
		AssetId selectedSitePlan = AssetUtil.toAssetId(request.getParameterValues("assetIds")[0]);
%>
		<asset:load name="spAsset" type='<%= selectedSitePlan.getType() %>' objectid='<%= String.valueOf(selectedSitePlan.getId()) %>' />
		<asset:getsitenode name="spAsset" output="spNodeId" />
		<siteplan:load name="spNode" nodeid='<%= ics.GetVar("spNodeId") %>'/>
		<siteplan:listpages name="spNode" placedlist="spAllPlacedPages" /> 
<%
		IList spAllPlacedPages = ics.GetList("spAllPlacedPages");
				
		// Add Pages
		addApprovalBeansToList(_ics, "Page", destinationId, spAllPlacedPages, spAllRelatedApprovalBeans);
		
		// Add Device Images
		addApprovalBeansToList(_ics, "Device", destinationId, MobilityUtils.getSkinsForSiteplan(_ics, selectedSitePlan.getId()), spAllRelatedApprovalBeans);
		
		// Add Device Groups
		addApprovalBeansToList(_ics, "DeviceGroup", destinationId, MobilityUtils.getDeviceGroupsForSiteplan(_ics, selectedSitePlan.getId()), spAllRelatedApprovalBeans);
	}

	UIDestinationBean uiDestinationBean = new UIDestinationBean(ics, destinationName, destinationType, destinationId);
	
	request.setAttribute("destination", uiDestinationBean);
	request.setAttribute("result", spAllRelatedApprovalBeans);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>

</cs:ftcs>
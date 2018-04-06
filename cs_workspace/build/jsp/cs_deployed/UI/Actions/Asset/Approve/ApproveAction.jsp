<%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="org.apache.commons.lang.ArrayUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="org.apache.commons.lang.BooleanUtils"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="java.util.List"
%><%@page import="java.util.Arrays"
%><%@page import="java.util.ArrayList"
%><%@page import="java.util.Collections"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.assetapi.data.AttributeData"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.ApprovalService"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.beans.asset.ApprovalBean"
%><%@page import="com.fatwire.services.beans.entity.DestinationBean"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="java.util.Collections.*"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	long destinationId = NumberUtils.toLong(request.getParameter("destinationId"), -1);
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(GenericUtil.asList(request.getParameterValues("assetIds"))))));
	boolean recursive = BooleanUtils.toBoolean(request.getParameter("recursive"));
	String actionToDo = StringUtils.defaultString(request.getParameter("action"));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	AuthorizationService authService = servicesManager.getAuthorizationService();
	ApprovalService approvalService = servicesManager.getApprovalService();
	AssetService assetService = servicesManager.getAssetService();
	SiteService siteService = servicesManager.getSiteService();

	List<AssetId> assetsToApprove = new ArrayList<AssetId>();
	List<UIApprovalBean> result = new ArrayList<UIApprovalBean>();
	List<String> fieldNames = Arrays.asList(IAsset.NAME);
	for(AssetId assetId : assetIds) {
		AssetData assetData = assetService.read(assetId, fieldNames);
		Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
		String name = nameData == null ? "" : String.valueOf(nameData);
		String type = AssetUtil.getAssetTypeDescription(assetData);
		if(StringUtils.equalsIgnoreCase("unapprove", actionToDo)) {
			approvalService.unapprove(destinationId, Collections.singletonList(assetId));
			ApprovalBean state = approvalService.getState(destinationId, assetId);
			boolean success = !state.isApproved();
			UIApprovalBean uiBean = new UIApprovalBean(ics, name, type, state);
			uiBean.setSuccess(success);
			if(!success) {
				uiBean.setDetail(LocalizedMessages.UnApproveFailed.getLocalizedValue(ics));
			}
			result.add(uiBean);
		} else {
			PermissionBean<VersioningAuthorizationBean> approvePermission = authService.canApprove(assetId);
			boolean permitted = approvePermission.isPermitted();
			if(permitted) {
				assetsToApprove.add(assetId);
			} else {
				UIApprovalBean uiBean = new UIApprovalBean(ics, name, type, assetId);
				uiBean.setLastPublishedDate(approvalService.getLastPublishDate(destinationId, assetId));
				uiBean.setSuccess(false);
				uiBean.setStatus(LocalizedMessages.NeedsApproval.getLocalizedValue(ics));
				uiBean.setDetail(approvePermission.getMessages().get(0));
				result.add(uiBean);
			}
		}
	}
	if(CollectionUtils.isNotEmpty(assetsToApprove)) {
		approvalService.approve(destinationId, assetsToApprove, recursive);
		for(AssetId assetId : assetsToApprove) {
			AssetData assetData = assetService.read(assetId, fieldNames);
			Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
			String name = nameData == null ? "" : String.valueOf(nameData);
			String type = AssetUtil.getAssetTypeDescription(assetData);
			ApprovalBean state = approvalService.getState(destinationId, assetId);
			UIApprovalBean uiBean = new UIApprovalBean(ics, name, type, state);
			boolean success = state.isApproved();
			uiBean.setSuccess(success);
			if(!success) {
				uiBean.setDetail(LocalizedMessages.ApproveFailed.getLocalizedValue(ics));
			}
			result.add(uiBean);
		}
	}
	request.setAttribute("result", result);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
<%@page import="com.fatwire.services.ui.beans.UIDestinationBean"
%><%@page import="java.util.HashMap"
%><%@page import="java.util.Map"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.ApprovalService"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.beans.ServiceResponse"
%><%@page import="com.fatwire.services.beans.asset.ApprovalBean"
%><%@page import="com.fatwire.services.beans.entity.DestinationBean"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>
<%
	//Call to filter/encode all request Input Parameter Strings
%>
<ics:callelement element="UI/Utils/encodeParameters"/>  
<%
try {
	final long destinationId = NumberUtils.toLong(request.getParameter("destinationId"), -1);
	final String destinationName = StringUtils.defaultString(request.getParameter("destinationName"));
	final String destinationType = StringUtils.defaultString(request.getParameter("destinationType"));
	AssetId assetId = AssetUtil.toAssetId(ics.GetVar("assetId"));
	List<AssetId> blockingAssetsToApprove = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(GenericUtil.asList(request.getParameterValues("blockingAssets"))))));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	ApprovalService approvalService = servicesManager.getApprovalService();
	AssetService assetService = servicesManager.getAssetService();
	final AuthorizationService authService = servicesManager.getAuthorizationService();

	List<PermissionBean<VersioningAuthorizationBean>> assetApprovalPermissions = GenericUtil.transformList(blockingAssetsToApprove, new GenericUtil.Transformer<AssetId, PermissionBean<VersioningAuthorizationBean>> () {
		public PermissionBean<VersioningAuthorizationBean> transform(AssetId assetId) {
			try {
				return authService.canApprove(assetId);
			} catch(ServiceException e) {
				throw new UIException(e);
			}
		}
	});

	final Map<AssetId, PermissionBean<VersioningAuthorizationBean>> assetsCannotBeApproved = new HashMap<AssetId, PermissionBean<VersioningAuthorizationBean>>();
	List<AssetId> assetsCanBeApproved = GenericUtil.transformSourceList(assetApprovalPermissions, new GenericUtil.Transformer<PermissionBean<VersioningAuthorizationBean>, AssetId>() {
		public AssetId transform(PermissionBean<VersioningAuthorizationBean> perm) {
			return perm.getAsset();
		}
	}, new GenericUtil.Predicate<PermissionBean<VersioningAuthorizationBean>> () {
		public boolean evaluate(PermissionBean<VersioningAuthorizationBean> perm) {
			boolean permitted = perm.isPermitted();
			if(!permitted) {
				assetsCannotBeApproved.put(perm.getAsset(), perm);
			}
			return permitted;
		}
	});

	approvalService.approve(destinationId, assetsCanBeApproved, false);

	List<AssetId> blockingAssets = GenericUtil.emptyIfNull(approvalService.getBlockingAssets(destinationId, assetId));
	List<UIApprovalBean> result = new ArrayList<UIApprovalBean>();
	List<String> fieldNames = Arrays.asList(IAsset.NAME);
	for(AssetId blockingAsset : blockingAssets) {
		AssetData assetData = assetService.read(blockingAsset, fieldNames);
		Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
		String name = nameData == null ? "" : String.valueOf(nameData);
		String type = AssetUtil.getAssetTypeDescription(assetData);

		// Blocking assets are unapproved assets
		ApprovalBean app = new ApprovalBean();
		app.setAsset(blockingAsset);
		app.setApproved(false);
		UIApprovalBean uiBean = new UIApprovalBean(ics, name, type, app);
		// If this was previously blocked due to permissions, add the detail
		if(assetsCannotBeApproved.containsKey(blockingAsset)) {
			uiBean.setDetail(assetsCannotBeApproved.get(blockingAsset).getMessages().get(0));
		} else {
			uiBean.setSuccess(true);
		}
		result.add(uiBean);
	}
	UIDestinationBean uiDestinationBean = new UIDestinationBean(ics, destinationName, destinationType, destinationId);
	request.setAttribute("destination", uiDestinationBean);
	request.setAttribute("result", result);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
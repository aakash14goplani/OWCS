<%@page import="com.fatwire.services.beans.response.MessageCollectors.VersioningMessageCollector"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.asset.VersionBean"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.ui.beans.UIVersionBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.VersioningService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="org.apache.commons.lang.BooleanUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	final List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(GenericUtil.asList(request.getParameterValues("assetIds"))))));
	final boolean keepCheckedOut = BooleanUtils.toBoolean(request.getParameter("keepCheckedOut"));
	final String comment = StringUtils.defaultString(request.getParameter("comment"));
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	
	final VersioningService versioningService = servicesManager.getVersioningService();
	final AuthorizationService authService = servicesManager.getAuthorizationService();
	final AssetService assetService = servicesManager.getAssetService();
	final ICS _ics = ics;

	List<UIVersionBean> result = GenericUtil.transformList(assetIds, new GenericUtil.Transformer<AssetId, UIVersionBean>() {
		public UIVersionBean transform(AssetId assetId) {
			UIVersionBean uiBean = null;
			try {
				AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME));
				Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String name = nameData == null ? "" : String.valueOf(nameData);
				String type = AssetUtil.getAssetTypeDescription(assetData);
				PermissionBean<VersioningAuthorizationBean> checkinPermission = authService.canCheckin(assetId);
				if(checkinPermission.isPermitted()) {
					VersioningMessageCollector vc = new VersioningMessageCollector();
					VersionBean revision = versioningService.checkin(assetId, comment, keepCheckedOut, vc);
					if(revision == null) {
						uiBean = new UIVersionBean(_ics, name, type, assetId);
						uiBean.setSuccess(false);
						uiBean.setDetail(vc.getMessage(assetId));
					} else {
						uiBean = new UIVersionBean(_ics, name, type, revision);
						uiBean.setSuccess(true);
					}
				} else {
					VersioningAuthorizationBean authBean = checkinPermission.getEntity();
					if(authBean != null && authBean.isTracked()) {
						VersionBean revision = versioningService.getCurrentRevision(assetId);
						uiBean = new UIVersionBean(_ics, name, type, revision);
					} else {
						uiBean = new UIVersionBean(_ics, name, type, assetId);
					}
					uiBean.setSuccess(false);
					uiBean.setDetail(checkinPermission.getMessages().get(0));
				}
			} catch (ServiceException e) {
				throw new UIException(e);
			}
			return uiBean;
		}
	});
	request.setAttribute("result", result);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
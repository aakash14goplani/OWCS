<%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.ui.beans.UIReferenceBean"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	Session ses = SessionFactory.getSession(ics);
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );

	final AssetService assetService = servicesManager.getAssetService();
	final AuthorizationService authService = servicesManager.getAuthorizationService();
	final ICS _ics = ics;

	String strAssetId = StringUtils.defaultString(request.getParameter("assetId")).replace("\'", "\"");
	AssetId assetId = JsonUtil.jsonToId(strAssetId);
	List<AssetId> references = assetService.getReferences(assetId);
	List<UIReferenceBean> result = GenericUtil.transformList(references, new GenericUtil.Transformer<AssetId, UIReferenceBean> () {
		public UIReferenceBean transform(AssetId reference) {
			UIReferenceBean uiBean = null;
			try {
				PermissionBean<VersioningAuthorizationBean> permission = authService.canEdit(reference);
				AssetData assetData = assetService.read(reference, Arrays.asList(IAsset.NAME));
				Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String name = nameData == null ? "" : String.valueOf(nameData);
				String type = AssetUtil.getAssetTypeDescription(assetData);
				uiBean = new UIReferenceBean(_ics, name, type, permission);
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
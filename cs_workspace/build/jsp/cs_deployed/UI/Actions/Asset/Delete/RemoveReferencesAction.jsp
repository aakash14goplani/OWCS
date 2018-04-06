<%@page import="com.fatwire.services.beans.response.MessageCollectors.RemoveReferenceMessageCollector"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.fatwire.services.ui.beans.UIReferenceBean"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="java.util.Arrays"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	AssetId assetId = JsonUtil.jsonToId(StringUtils.defaultString(request.getParameter("assetId")));
	List<AssetId> referenceIds = JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("referenceIds")));
	Session ses = SessionFactory.getSession(ics);
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	final AuthorizationService authService = servicesManager.getAuthorizationService();
	final AssetService assetService = servicesManager.getAssetService();
	final ICS _ics = ics;
	
	final RemoveReferenceMessageCollector collector = new RemoveReferenceMessageCollector();
	List<AssetId> remRef = assetService.removeReferences(assetId, referenceIds, collector);
	
	final List<AssetId> removedReferences = GenericUtil.emptyIfNull(remRef);
	final List<UIReferenceBean> result = GenericUtil.emptyIfNull(GenericUtil.transformList(referenceIds, new GenericUtil.Transformer<AssetId, UIReferenceBean>() {
		public UIReferenceBean transform(AssetId reference) {
			UIReferenceBean uiBean = null;
			try {
				AssetData assetData = assetService.read(reference, Arrays.asList(IAsset.NAME));
				Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String name = nameData == null ? "" : String.valueOf(nameData);
				String type = AssetUtil.getAssetTypeDescription(assetData);
				uiBean = new UIReferenceBean(_ics, name, type, reference);
				boolean removed = removedReferences.contains(reference);
				uiBean.setSuccess(removed);
				if(removed) {
					uiBean.setDetail(LocalizedMessages.RemovedReference.getLocalizedValue(_ics));
				} else {
					if(collector.getMessage(reference) == null || StringUtils.isEmpty(collector.getMessage(reference))){
						uiBean.setDetail(LocalizedMessages.CannotRemoveReference.getLocalizedValue(_ics));
					}
					else{
						uiBean.setDetail(collector.getMessage(reference));
					}
				}
			} catch (ServiceException e) {
				throw new UIException(e);
			}
			return uiBean;
		}
	}));
	request.setAttribute("result", result);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
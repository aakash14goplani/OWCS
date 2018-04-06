<%@page import="com.fatwire.services.beans.response.MessageCollectors.DeleteAssetsMessageCollector"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.beans.asset.authorization.DeleteAuthorizationBean"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="java.util.Arrays"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.ui.beans.UIDeleteBean"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<AssetId> assetsToDelete = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetIds")))));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	final AuthorizationService authService = servicesManager.getAuthorizationService();
	final AssetService assetService = servicesManager.getAssetService();
	final ICS _ics = ics;
  
	List<UIDeleteBean> result = GenericUtil.transformList(assetsToDelete, new GenericUtil.Transformer<AssetId, UIDeleteBean>() {
		public UIDeleteBean transform(AssetId assetId) {
			UIDeleteBean uiBean = null;
			try {
				AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME));
				Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String name = nameData == null ? "" : String.valueOf(nameData);
				String type = AssetUtil.getAssetTypeDescription(assetData);
				
				// Encode and Clean for XSS 
				name =  GenericUtil.cleanString(name);				
				// Double check for permissions in case this element gets called stand-alone
				PermissionBean<DeleteAuthorizationBean> permission = authService.canDelete(assetId);
				// even if we have green flag for deletion we have to check if this asset type supports delete operation
				// if not set the permission to false and set the messagae
				boolean supported = GenericUtil.isSupported(_ics, assetId.getType());
				if(!supported){
					permission.setPermitted(false);
					permission.addMessage(LocalizedMessages.deleteOperationNotSupported.getLocalizedValue(_ics));
				}
				if(!permission.isPermitted() || (permission.getEntity() != null && permission.getEntity().getReferences().size() > 0)) {
					
					uiBean = new UIDeleteBean(_ics, name, type, permission);
				} else {
					uiBean = new UIDeleteBean(_ics, name, type, assetId);
					DeleteAssetsMessageCollector collector = new DeleteAssetsMessageCollector();
					boolean success = assetService.delete(assetId, collector);
					uiBean.setSuccess(success);
					if(!success) {
						uiBean.setDetail(collector.getMessage(assetId));
					}
					uiBean.setRefreshKey("Parent:"+ assetId.getId());
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
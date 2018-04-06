<%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="java.util.Arrays"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.beans.asset.VersionBean"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.ui.beans.UIVersionBean"
%><%@page import="com.fatwire.services.VersioningService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="java.util.List"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<AssetId> assetIds = JsonUtil.jsonToIdList(request.getParameter("assetIds"));
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	
	final VersioningService versioningService = servicesManager.getVersioningService();
	final AssetService assetService = servicesManager.getAssetService();
	final ICS _ics = ics;
	
	List<UIVersionBean> result = GenericUtil.transformList(assetIds, new GenericUtil.Transformer<AssetId, UIVersionBean>() {
		public UIVersionBean transform(AssetId assetId) {
			UIVersionBean uiBean = null;
			try {
				boolean tracked = versioningService.isTracked(assetId.getType());
				AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME));
				Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String name = nameData == null ? "" : String.valueOf(nameData);
				String type = AssetUtil.getAssetTypeDescription(assetData);
				if(tracked) {
					VersionBean revision = versioningService.getCurrentRevision(assetId);
					uiBean = new UIVersionBean(_ics, name, type, revision);
				} else {
					uiBean = new UIVersionBean(_ics, name, type, assetId);
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
<%@page import="java.util.HashSet"
%><%@page import="com.fatwire.services.beans.search.BookmarkBean"
%><%@page import="com.fatwire.services.beans.asset.AssetBean.Status"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.ui.beans.UIAssetMetadataBean"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="java.util.Arrays"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.assetapi.common.AssetAccessException"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.beans.asset.VersionBean"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.VersioningService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="java.util.List"
%><%@page import="java.text.SimpleDateFormat"
%><%@page import="java.text.DateFormat"
%><%@page import="com.openmarket.xcelerate.util.ConverterUtils"
%><%@ page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<AssetId> assetIds = new ArrayList<AssetId>(new HashSet<AssetId>(GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(request.getParameter("assets")))));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());

	final VersioningService versioningService = servicesManager.getVersioningService();
	final AssetService assetService = servicesManager.getAssetService();
	final AuthorizationService authService = servicesManager.getAuthorizationService();
	final SearchService searchService = servicesManager.getSearchService();
	final ICS _ics = ics;
	
	List<UIAssetMetadataBean> result = GenericUtil.transformList(assetIds, new GenericUtil.Transformer<AssetId, UIAssetMetadataBean>() {
		public UIAssetMetadataBean transform(final AssetId assetId) {
			UIAssetMetadataBean uiBean = new UIAssetMetadataBean(_ics, assetId);
			try {
				AssetData assetData;
				boolean isProxy = com.fatwire.assetapi.util.AssetUtil.isProxyAssetType(_ics, assetId.getType());
				if (isProxy) {
					assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME, IAsset.STATUS, IAsset.TEMPLATE, "externalid"));
				}
				else {
					assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME, IAsset.STATUS, IAsset.STARTDATE, IAsset.TEMPLATE));
				}
				 
				if(assetData != null) {
					Object statusData = AssetUtil.getAttribute(assetData, IAsset.STATUS);
					Status status = Status.toEnum(statusData == null ? "" : String.valueOf(statusData));
					uiBean.setStatus(status);
					Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
					String name = nameData == null ? "" : String.valueOf(nameData);
					uiBean.setName(name);
					
					Object startDateData = AssetUtil.getAttribute(assetData, IAsset.STARTDATE);
					String startDate = "";
					if(startDateData != null){
						java.util.Date dt = (java.util.Date)startDateData;
						DateFormat df = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss", ConverterUtils.getLocaleObj(LocalizedMessages.getLocaleString(_ics)));
						startDate = df.format(dt);
					}
					uiBean.setStartDate(startDate);
					
					Object tnameData = AssetUtil.getAttribute(assetData, IAsset.TEMPLATE);
					String tname = tnameData == null ? "" : String.valueOf(tnameData);
					uiBean.setTname(tname);
					String type = AssetUtil.getAssetTypeDescription(assetData);
					uiBean.setTypeDescription(type);
					String subType = AssetUtil.getAssetSubType(assetData);
					uiBean.setSubtype(subType);
					VersionBean revision = versioningService.getCurrentRevision(assetId);
					uiBean.setLockStatus(revision);
                                        uiBean.setFlex(AssetUtil.isFlexAsset(_ics, assetId.getType()));
                                        uiBean.setComplex(AssetUtil.isComplexAssetType(_ics, assetId.getType()));
					PermissionBean<VersioningAuthorizationBean> permission = authService.canShare(assetId);
					uiBean.setShareable(permission);

					List<BookmarkBean> bookmarks  = GenericUtil.emptyIfNull(searchService.getBookmarks());
					boolean bookmarked = GenericUtil.some(bookmarks, new GenericUtil.Predicate<BookmarkBean>() {
						public boolean evaluate(BookmarkBean each) {
							return each.getAssetId().equals(assetId);
						}
					});
					uiBean.setBookmarked(bookmarked);
					
					if (isProxy) {
						Object externalIdData = AssetUtil.getAttribute(assetData, "externalid");
						uiBean.setExternalid(externalIdData == null ? "" : String.valueOf(externalIdData));
					}
				}
			} catch (Exception e) {
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
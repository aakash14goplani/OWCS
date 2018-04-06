<%@page import="com.fatwire.services.beans.response.MessageCollectors.VersioningMessageCollector"
%><%@page import="com.fatwire.services.authorization.Function"
%><%@page import="com.fatwire.services.ui.beans.UIAccessRightsBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@page import="com.fatwire.services.VersioningService"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.AuthorizationService"
%><%@page import="com.fatwire.services.beans.asset.VersionBean"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.fatwire.services.beans.asset.authorization.VersioningAuthorizationBean"
%><%@page import="com.fatwire.services.ui.beans.UIVersionBean"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="java.util.Arrays"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><cs:ftcs>
<%
	try 
	{
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());		
		final AuthorizationService authService = servicesManager.getAuthorizationService();	
		final VersioningService versioningService = servicesManager.getVersioningService();
		final AssetService assetService = servicesManager.getAssetService();
		final ICS _ics = ics;
		String asset =  request.getParameter("asset");
		AssetId assetId = JsonUtil.jsonToId(asset);		
		if (asset != null && StringUtils.isNotBlank(asset))
		{
			//get permission for this asset
			UIAccessRightsBean permission = GenericUtil.transform(assetId, new GenericUtil.Transformer<AssetId, UIAccessRightsBean>()
			{
				public UIAccessRightsBean transform(AssetId assetId)
				{
					UIAccessRightsBean uiBean = null;
					try
					{
						PermissionBean<Object> assetPermission = authService.hasAccess(assetId, Function.edit);
						uiBean = new UIAccessRightsBean(_ics, assetPermission);
					} 
					catch(ServiceException e)
					{
						throw new UIException(e);
					}
					return uiBean;
				}
			});
			request.setAttribute("assetPermission", permission);			
			// if permitted then check whether it is tracked.
			if(permission.isPermitted())
			{
				//if tracked checkout.
				if(versioningService.isTracked(assetId.getType()))
				{
					UIVersionBean checkout = GenericUtil.transform(assetId, new GenericUtil.Transformer<AssetId, UIVersionBean>() 
					{
						public UIVersionBean transform(AssetId assetId)
						{
							UIVersionBean uiBean = null;
							try 
							{
								AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME));
								Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
								String name = nameData == null ? "" : String.valueOf(nameData);
								String type = AssetUtil.getAssetTypeDescription(assetData);
								PermissionBean<VersioningAuthorizationBean> checkoutPermission = authService.canCheckout(assetId);
								if(checkoutPermission.isPermitted()) 
								{
									VersioningMessageCollector vc = new VersioningMessageCollector();
									VersionBean revision = versioningService.checkout(assetId, vc);
									if(revision == null) {
										uiBean = new UIVersionBean(_ics, name, type, assetId);
										uiBean.setSuccess(false);
										uiBean.setDetail(vc.getMessage(assetId));
									} else {
										uiBean = new UIVersionBean(_ics, name, type, revision);
										uiBean.setSuccess(true);
									}
								} 
								else
								{
									VersioningAuthorizationBean authBean = checkoutPermission.getEntity();
									if(authBean != null && authBean.isTracked()) 
									{
										VersionBean revision = versioningService.getCurrentRevision(assetId);
										uiBean = new UIVersionBean(_ics, name, type, revision);
									} 
									else 
									{
										uiBean = new UIVersionBean(_ics, name, type, assetId);
									}
									uiBean.setSuccess(false);
									uiBean.setDetail(checkoutPermission.getMessages().get(0));
								}
							} 
							catch (ServiceException e) 
							{
								throw new UIException(e);
							}
							return uiBean;
						}
					});					
					request.setAttribute("checkout", checkout);					
				}				
			}			
		}
		
	} catch(UIException e) {		
		request.setAttribute(UIException._UI_EXCEPTION_, e);
	
	} catch(Exception e) {		
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}

%>



</cs:ftcs>
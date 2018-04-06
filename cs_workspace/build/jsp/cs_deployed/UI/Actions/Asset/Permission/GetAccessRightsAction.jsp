<%@page import="com.fatwire.services.ui.beans.UIAccessRightsBean"
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
%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
%>
<cs:ftcs><%
try {
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	final AuthorizationService authService = servicesManager.getAuthorizationService();
	final ICS _ics = ics;
	
	String functionId = ics.GetVar("functionid");
	if(StringUtils.equals(functionId, "insite")) 
		functionId = "preview";
	final String function = functionId;
	String json = ics.GetVar("slots");
	if (StringUtils.isNotBlank(json)) {
		List<AssetId> slots = JsonUtil.jsonToIdList(json);
		List<UIAccessRightsBean> slotPermissions = GenericUtil.transformList(slots, new GenericUtil.Transformer<AssetId, UIAccessRightsBean>() {
			public UIAccessRightsBean transform(AssetId assetId) {
				UIAccessRightsBean uiBean = null;
				try {
					PermissionBean<Object> slotPermission = authService.canAccessSlot(assetId, function);
					uiBean = new UIAccessRightsBean(_ics, slotPermission);
				} catch(ServiceException e) {
					throw new UIException(e);
				}
				return uiBean;
			}
		});
		request.setAttribute("slotPermissions", slotPermissions);
	}
	json = ics.GetVar("assets");
	if (StringUtils.isNotBlank(json)) {
		List<AssetId> assetIds = JsonUtil.jsonToIdList(json);
		List<UIAccessRightsBean> assetPermissions = GenericUtil.transformList(assetIds, new GenericUtil.Transformer<AssetId, UIAccessRightsBean>() {
			public UIAccessRightsBean transform(AssetId assetId) {
				UIAccessRightsBean uiBean = null;
				try {
					PermissionBean<Object> assetPermission = authService.hasAccess(assetId, function);
					uiBean = new UIAccessRightsBean(_ics, assetPermission);
					if(!uiBean.isPermitted()) {
						List<String> messages = uiBean.getMessages();
						if (messages.size() > 0) {
							StringBuilder builder = new StringBuilder(assetId.toString() + " - ");
							int i = 0;
							for ( String str : messages) {
								if (i > 0)
									builder.append(" ");
								builder.append(str.replaceAll("(?i)<br\\s*\\/?\\s*>", " "));
								i++;
							}		
							_log.error(builder.toString());
						}	
					}
				} catch(ServiceException e) {
					throw new UIException(e);
				}
				return uiBean;
			}
		});
		request.setAttribute("assetPermissions", assetPermissions);
	}
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
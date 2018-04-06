<%@page import="com.fatwire.assetapi.data.AssetData"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="com.fatwire.services.util.AssetUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="java.util.List,com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIAssetStatusBean"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try{
	AssetId assetId = new AssetIdImpl(StringUtils.defaultString(request.getParameter("type")), NumberUtils.toLong(request.getParameter("id")));
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	AssetService assetService = servicesManager.getAssetService();
	AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME, IAsset.STATUS));
	
	Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
	String name = nameData == null ? "" : String.valueOf(nameData);
	
	Object statusData = AssetUtil.getAttribute(assetData, IAsset.STATUS);
	String status = statusData == null ? "" : String.valueOf(statusData);
	
	//create the presentation bean and set the values.
	UIAssetStatusBean statusBean = new UIAssetStatusBean();
	statusBean.setName(name);
	statusBean.setStatus(status);
	request.setAttribute("statusBean", statusBean);
	
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>
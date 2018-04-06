<%@page import="com.fatwire.services.beans.response.MessageCollectors.SaveAssetsMessageCollector"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"
%><%@page import="com.fatwire.services.beans.ServiceResponse"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.AssetService"
%><%@ page import="com.fatwire.assetapi.data.MutableAssetData"
%><%@ page import="com.fatwire.assetapi.data.AttributeData"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.services.beans.asset.TypeBean"
%><%@ page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@ page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><cs:ftcs><%
try {
	ServiceResponse resp = new ServiceResponse();
	String type = GenericUtil.cleanString(request.getParameter("type"));
	String subtype = GenericUtil.cleanString(request.getParameter("subtype"));
	String startmenuid = GenericUtil.cleanString(request.getParameter("startmenuid"));
	String name = GenericUtil.cleanString(request.getParameter("name"));
	String template = GenericUtil.cleanString(request.getParameter("tname"));
	// Populating name and template for the assetType
	//TODO populate other attributes based on the Startmenu
	if(type != null && startmenuid != null && name != null) {
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
		AssetService assetService = servicesManager.getAssetService();
		
		StartMenuBean startMenuBean= new StartMenuBean();
		startMenuBean.setId(new Long(startmenuid));
		AssetData assetData = assetService.newAsset(type, subtype,startMenuBean);
		AttributeData nameAttribute = assetData.getAttributeData("name", true);
		nameAttribute.setData(name);
		AttributeData templateAttribute = assetData.getAttributeData("template", true);
		templateAttribute.setData(template);
		SaveAssetsMessageCollector collector = new SaveAssetsMessageCollector();
		AssetSaveStatusBean status = assetService.save(assetData , collector);
		List<String> errorMessages = collector.getErrorMessages();		
		request.setAttribute("saveStatus", status);
		request.setAttribute("errorMessages", errorMessages);
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>

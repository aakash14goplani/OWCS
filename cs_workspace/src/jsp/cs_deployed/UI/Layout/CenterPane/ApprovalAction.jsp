<%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.ApprovalService"
%><%@page import="java.util.List"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.beans.entity.DestinationBean"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.services.beans.asset.ApprovalBean"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.fatwire.services.ui.beans.UIDestinationBean"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>
<%
	//Call to filter/encode all request Input Parameter Strings
%>
<ics:callelement element="UI/Utils/encodeParameters"/>  
<%
try {
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	
	final ApprovalService approvalService = servicesManager.getApprovalService();
	final AssetService assetService = servicesManager.getAssetService();
	final ICS _ics = ics;
	
	final long destinationId = NumberUtils.toLong(request.getParameter("destinationId"), -1);
	final String destinationName = StringUtils.defaultString(request.getParameter("destinationName"));
	final String destinationType = StringUtils.defaultString(request.getParameter("destinationType"));
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(AssetUtil.toAssetId(GenericUtil.toObjectList(GenericUtil.asList(request.getParameterValues("assetIds"))))));
	
	List<UIApprovalBean> result = GenericUtil.transformSourceList(assetIds, new GenericUtil.Transformer<AssetId, UIApprovalBean>() {
		public UIApprovalBean transform(AssetId assetId) {
			UIApprovalBean uiBean = null;
			try {
					ApprovalBean approvalState = approvalService.getState(destinationId, assetId);
					AssetData assetData = assetService.read(assetId, Arrays.asList(IAsset.NAME));
					Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
					String name = nameData == null ? "" : String.valueOf(nameData);
					String type = AssetUtil.getAssetTypeDescription(assetData);
					uiBean = new UIApprovalBean(_ics, name, type, approvalState);
					uiBean.setSuccess(true);
			} catch (ServiceException e) {
				throw new UIException(e);
			}
			return uiBean;
		}
	}, new GenericUtil.Predicate<AssetId> () {
		public boolean evaluate(AssetId assetId) {
			try{
				return assetService.exists(assetId);
			}catch(ServiceException e){
				throw new UIException(e);	
			}
		}
	});
	UIDestinationBean uiDestinationBean = new UIDestinationBean(ics, destinationName, destinationType, destinationId);
	
	request.setAttribute("destination", uiDestinationBean);
	request.setAttribute("result", result);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
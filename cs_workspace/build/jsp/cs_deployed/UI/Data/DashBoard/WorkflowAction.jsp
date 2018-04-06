<%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.services.ui.beans.UIAssignmentBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.WorkflowService"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.services.beans.entity.AssignmentBean"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	final ICS _ics = ics;
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	WorkflowService workflowService = servicesManager.getWorkflowService();
	final AssetService assetService = servicesManager.getAssetService();
	
	List<AssignmentBean> assignments = workflowService.getAssignments();
	List<UIAssignmentBean> result = GenericUtil.transformList(assignments, new GenericUtil.Transformer<AssignmentBean, UIAssignmentBean>() {
		public UIAssignmentBean transform(AssignmentBean assignment) {
			UIAssignmentBean uiBean = null;
			try {
				AssetData assetData = assetService.read(assignment.getAsset(), Arrays.asList(IAsset.NAME, IAsset.DESCRIPTION));
				Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String name = nameData == null ? "" : String.valueOf(nameData);
				Object descriptionData = AssetUtil.getAttribute(assetData, IAsset.NAME);
				String description = descriptionData == null ? "" : String.valueOf(descriptionData);
				String type = AssetUtil.getAssetTypeDescription(assetData);
				uiBean = new UIAssignmentBean(_ics,name , description, type, assignment);
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
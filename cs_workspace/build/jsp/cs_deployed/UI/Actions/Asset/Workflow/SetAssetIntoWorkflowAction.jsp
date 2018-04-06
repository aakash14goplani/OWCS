<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.WorkflowService"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@ page import="com.fatwire.services.beans.entity.WorkflowBean"
%><%@ page import="com.fatwire.services.beans.entity.AssignmentBean"
%><%@ page import="com.fatwire.services.beans.entity.RoleBean"
%><%@ page import="com.fatwire.services.beans.entity.UserBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	WorkflowService workflowService = servicesManager.getWorkflowService();
	
	AssetId assetId = new AssetIdImpl(request.getParameter("assetType"), NumberUtils.toLong(request.getParameter("assetId")));
	long processId = NumberUtils.toLong(ics.GetVar("workflowId"), -1);
	long startmenuId = NumberUtils.toLong(ics.GetVar("startmenuId"), -1);
	WorkflowBean workflow = workflowService.getWorkflow(processId);
	Map<RoleBean, List<UserBean>> roleUserMapping = GenericUtil.toRoleUserMapping(StringUtils.defaultString(request.getParameter("workflowAssignees")));
	request.setAttribute("success", Boolean.valueOf(workflowService.startWorkFlow(assetId , startmenuId, workflow, null, roleUserMapping)));
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
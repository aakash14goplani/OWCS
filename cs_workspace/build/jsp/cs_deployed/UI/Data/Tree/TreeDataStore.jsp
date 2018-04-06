<%@page import="com.fatwire.services.beans.entity.TreeNodeBean"%>
<%@page import="com.fatwire.services.TreeService"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="java.util.List,com.fatwire.services.ServicesManager"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><cs:ftcs><%
try{
	String id = ics.GetVar("id");

	// for tree pagination only: TODO describe legal values
	String oper = ics.GetVar("oper");

	// Get the passed loadUrl 
	String loadUrl = ics.GetVar("loadUrl");
	
	// Get the showParentsOnly property - it controls whether only parent nodes
	// should be rendered in the tree or not. The value has to be explicitly
	// set to false in order to show child nodes.
	boolean showParentsOnly = !"false".equals(ics.GetVar("showParentsOnly"));
	
	// for tree pagination only: index of the child node to be retrieved
	int start = 0;
	try {
		String paramStart = ics.GetVar( "startQpnt" );
		if ( paramStart != null )
		{
			start = Integer.parseInt( paramStart );
		}
	}
	catch(NumberFormatException e) {}
	
	// get tree data service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	TreeService treeDataService = servicesManager.getTreeService();
		
	// get the list of tree nodes to display	
	List<TreeNodeBean> nodeList = treeDataService.getChildren(loadUrl, oper, start, showParentsOnly);
	request.setAttribute("nodeList", nodeList);
	
	// If filter configured and deployed Apply Tab custom filter 
	String filter = ics.GetVar("filter");
	if ( Utilities.goodString(filter) )
	{
		ics.CallElement(filter, null);
	}
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>
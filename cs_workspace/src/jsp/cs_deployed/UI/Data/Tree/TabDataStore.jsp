<%@page import="com.fatwire.services.beans.entity.TreeNodeBean"%>
<%@page import="com.fatwire.services.TreeService"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List,com.fatwire.services.ServicesManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="java.util.*"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>

<cs:ftcs>
<%
try{
	// This element generates a tree store representing the top-level roots of the tree.
	// (it basically get the list of tabs for the current site/user, 
	// as defined in the "Tree" admin section)	
	// get the list of tabs to include (comma-separated list of tree tab fwuids)
	String tabsArg = ics.GetVar("tabs");
	 
	// get the list of tabs to excluded (comma-separated list of tree tab fwuids)				
	String extabsArg = ics.GetVar("exclude");
	
	List<String> tabs = null;
	
	List<TreeNodeBean> filterList = new ArrayList<TreeNodeBean>();
		
	// TODO trim extra white spaces
	if (tabsArg != null) 
	  tabs = Arrays.asList(StringUtils.split(tabsArg, ","));
	
	String loadUrl = ics.GetVar("loadUrl");
		
	// get tree data service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	TreeService treeDataService = servicesManager.getTreeService();
	
	// get the tree ROOT tab nodes for the given list of tabs
	List<TreeNodeBean> treeList = treeDataService.getRoots(tabs);
	
	// Filter and build the configured list apply excluded tabs 
	if ( extabsArg != null )  {
		for ( TreeNodeBean node : treeList ) {
			if ( !extabsArg.contains(node.getName())) {
		      filterList.add(node) ; 
		    }
		}
		// Merge Filtered List 
		treeList=filterList ;			
	}

	// put list in request scope
	request.setAttribute("nodeList", treeList);
	
	// if configured we now apply the OOTB and/or customized tree pane filter, 
	// for all non show roots Tree Pane Tabs
	String filter = ics.GetVar("filter"); 	

	// if specfied call  custom tree node filter 
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
%>
</cs:ftcs>
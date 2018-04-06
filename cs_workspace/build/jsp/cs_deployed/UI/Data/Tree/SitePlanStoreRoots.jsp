<%@page import="com.fatwire.services.beans.entity.TreeNodeBean"%>
<%@page import="com.fatwire.services.TreeService"%>
<%@page import="java.util.List,com.fatwire.services.ServicesManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="java.util.*"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<cs:ftcs>
<%
try{
	// This element fetches the nodes representing 
	// the top-level roots for the SitePlan Tree 
	// in essence all of the defined SitePlan 
	// for the user logged in Site 

	String tabsArg = ics.GetVar("tabs");
	 	
	List<String> tabs = null;
			
	// Get the Site Tree Tab identifier 
	if (tabsArg != null) 
	  tabs = Arrays.asList(StringUtils.split(tabsArg, ","));
	
	// get tree data service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	TreeService treeDataService = servicesManager.getTreeService();
	
	// get the tree ROOT tab nodes for the given list of tabs
	List<TreeNodeBean> treeList = treeDataService.getRoots(tabs);
	
	// showRoot=false means we don't want to show the folder corresponding to the tree tab
	List<TreeNodeBean> nodeList = new ArrayList<TreeNodeBean>();
	
	// Use the Site Plan LoadURL to initilize with roots 
	for (TreeNodeBean node: treeList) {
	  	List<TreeNodeBean> children = treeDataService.getChildren(node.getLoadUrl(), "Load", 0, true )   ; 		
		if (children != null) {
			nodeList.addAll(children);
		}
	}
		
	// put siteplan roots in the node list request scope
	request.setAttribute("nodeList", nodeList);
	
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
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.services.TreeService"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>

<cs:ftcs>

<!--   
Purpose:   In this tree action phase the following tasks 
           must be performed. 
           
           1) Determine if the logged in user has at the 
              minimum access to at least one root tree tab 
              then user can access the tree pane..              
 -->
<%

try{
	// get tree data service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	TreeService treeDataService = servicesManager.getTreeService();
	
	// Query and fetch all TREE tabs accessible by the current user
	// has permisions and roles to view 
	Map<String,String> tabs = treeDataService.getTreeTabs();

	// Get the panes content rendering data 
	Map<String,Object> content = (Map<String,Object>)request.getAttribute("content");

	// We are OOBOX Tree Rendering ELEMENT get the content tree data Map 
	Map<String,Object> treeData = (Map<String,Object>)content.get("tree"); 

	//Set the tree map data now that one or both canAccess and datastoreUrl has be set 
	request.setAttribute( "tree", treeData );

	// By Default user can not access any tabs 
	Boolean  canAccess = false ; 

	// Get the included root tabs for this tree 
	List<String> includedTabs = (List<String>)treeData.get("includedTabs") ; 
		
	//Get the set of excluded root tabs for this tree 	
	List<String> excludedTabs = (List<String>)treeData.get("excludedTabs") ; 

	//list of tab uids which will be actually rendered
	List<String> filteredTabs = new ArrayList<String>();

	if ( includedTabs != null ) {
		for ( String tabUID: includedTabs ) {
			if (tabs.containsKey( tabUID )) {
				filteredTabs.add( tabUID );
			}
		}
	}
	
	if ( excludedTabs != null && !excludedTabs.isEmpty()) {
		Set<String> tabUIDs = tabs.keySet();
		for (String tabUID: tabUIDs) {
			// we keep only the tabs which are not on the exclusion list
			if ( !excludedTabs.contains( tabUID ) ) {
				filteredTabs.add(tabUID);
			}
		}
	}
	// make the list of tabs available as a comma-separated string
	treeData.put("tabs", StringUtils.join(filteredTabs, ","));

	// make the list of tabs that will be excluded in essence 
	// filtered out as a comma-separated string			
	treeData.put("excludetabs", StringUtils.join(excludedTabs, ","));

	// user has access to the pane if it can access at least one tab in the list
	for(String tab :filteredTabs)
	{
		if(tabs.keySet().contains(tab))
		{
			canAccess = true ; 
			break;
		}
	}		
    // Place if user has permission at least one tab ...
	treeData.put("canAccess", canAccess);

	// Does the user have access to the tree 
	// Via the UIController 
	if ( canAccess ) {
	%>
		<!--   Create the Tree Data Store URL   -->
		<satellite:link pagename="fatwire/ui/controller/controller" outstring="datastoreUrl" assembler="query">
			<satellite:argument name="elementName" value="${tree.datastore}" />
			<satellite:argument name="responseType" value="json" />
			<satellite:argument name="treeid" value='${tree.id}' />
		</satellite:link>
	<% 
		treeData.put("datastoreUrl",ics.GetVar( "datastoreUrl" )) ; 
	}
}
catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>

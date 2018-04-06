<%@page import="org.codehaus.groovy.util.StringUtil"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.apache.commons.configuration.HierarchicalConfiguration"%>
<%@page import="org.apache.commons.configuration.Configuration"%>
		
<cs:ftcs>
<%
try{	
	// configuration bean
	ConfigurationDynaBean bean = (ConfigurationDynaBean)request.getAttribute("leftnavconfig");
	Configuration conf = bean.getConfiguration();
	HierarchicalConfiguration panes = (HierarchicalConfiguration) conf.subset("panes");
	int nbPanes = 0;
	if(panes != null) {
		List<HierarchicalConfiguration> items = panes.configurationsAt("pane");
		nbPanes = items.size();
	}
		
	List<Map<String,Object>> paneList = new ArrayList<Map<String,Object>>(); // will be passed to the presentation content
	for ( int i = 0; i < nbPanes; i++ ) {
		
		// Root Level  <pane>
		Map<String,Object> paneData = new HashMap<String,Object>();
		// bean property name for the current top-level item
		String root = nbPanes > 1 ? "panes.pane(" + i + ")" : "panes.pane";
			
		String rootLabel = (String)bean.get(root + "[@label]");
		paneData.put("id", bean.get(root + "[@id]"));
		paneData.put("label", bean.get(root + "[@label]"));
		
		Boolean  canAccess = true ; 
		
		// Does the pane have the optional  canAccess Permission flag 
		// to display the content pane to the user 
		if (bean.contains(root, ".canAccess")) {
			canAccess = new Boolean ( (String)bean.get(root + ".canAccess")) ; 
			paneData.put("canAccess", canAccess);
		}
		if(!canAccess)	{
			continue;
		}
		// Must set the panData access 
		paneData.put("canAccess", canAccess );
	
		// System.out.println(" Pane@"+paneData.get("label")+" canAccess "+(Boolean)paneData.get("canAccess") );
		// Collect the content data 
		Map<String,Object> contentData = new HashMap<String,Object>();	
		// Place the contentData in pane Map key=content 
		
		paneData.put("content", contentData);	
		contentData.put("source", bean.get(root + ".content.source"));
		
		String  contentTreeRoot = root + ".content.tree" ; 
		// Does the content render a tree ? 	
		try {
			// Is it a Out of the Box Tree 
			Object  tree = bean.get(root + ".content.tree");
			// Yes we have a Tree collect all tree properties
	     	Map<String,Object> treeData = new HashMap<String,Object>();		
			// Place the treeData in content Map key=tree 
			contentData.put("tree", treeData);
			// Collect the content.tree  properties 
			// id	- tree unique identifier
			treeData.put("id", bean.get(contentTreeRoot+"[@id]"));
			// label- tree root label
			treeData.put("label", bean.get(contentTreeRoot+"[@label]"));
			
			// datastore - configured tree pane datasource source element 
			treeData.put("datastore",bean.get(root+".content.tree.datastore") );	
			
			// roots -  configure custom element to fetch forest of root nodes
			//			in essence the top-level roots of the tree pane.
			if (bean.contains(root+".content.tree", "roots")) {			
				treeData.put("roots",bean.get(root+".content.tree.roots") );	 
			}	
			
			// show parents only 
			if (bean.contains(root+".content.tree","[@showParentsOnly]")) {
				treeData.put("showParentsOnly", bean.get(root + ".content.tree[@showParentsOnly]"));
			}			
			// Collect the List of DOJO Tree properties 			
			Map<Object,Object> args = new HashMap<Object,Object>();
			treeData.put("arguments", args);
	
			Collection<?> arguments  = (Collection<?>)bean.get(root + ".content.tree.arguments.argument[@name]");
			int nbArguments = arguments.size();
			
			//System.out.println("Dojo Tree Args="+nbArguments) ;
			for ( int j = 0; j < nbArguments; j++ ) {
				String argRoot = root + ".content.tree.arguments.argument(" + j + ")";
				args.put(bean.get(argRoot + "[@name]"), bean.get(argRoot + "[@value]"));
			}			
			// Get and set the included root tabs for this tree 
			List<String> includedTabs = new ArrayList<String>();
			treeData.put("includedTabs",includedTabs) ; 			
			// Collect the tab UID to include 
			try {
				Object value = bean.get(root + ".content.tree.include.uid");
				if ( value instanceof List ) {
					includedTabs.addAll((List)value);
				}
				else {
					includedTabs.add((String)value);
				}
			}
			catch( IllegalArgumentException e ) {}

			// Collect the tab UID to exclude 		
			List<String> excludedTabs = new ArrayList<String>();
			// Get and set the exncluded root tabs for this tree 
			treeData.put("excludedTabs",excludedTabs) ; 
			
			try {
				Object value = bean.get(root + ".content.tree.exclude.uid");
				if ( value instanceof List ) {
					excludedTabs.addAll((List)value);
				}
				else {
					excludedTabs.add((String)value);
				}           
			}
			catch( IllegalArgumentException e ) {}
		}
		catch(IllegalArgumentException e) {}
		
		// Add to the pane Data 
		paneList.add(paneData);
	}
	// place the pane can be a  tree and/or
	// custom content pane 	
	request.setAttribute("panes", paneList);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>
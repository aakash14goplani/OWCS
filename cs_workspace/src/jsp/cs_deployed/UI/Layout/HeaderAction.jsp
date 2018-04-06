<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ page import="org.apache.commons.lang.BooleanUtils"
%><%@ page import="java.util.*"
%><cs:ftcs><%
// configuration bean
ConfigurationDynaBean bean = (ConfigurationDynaBean)request.getAttribute("headerconfig");
if ( bean != null && bean.containsKey("menu") ) {
	// get top-level menu items
	Collection<?> roots = (Collection<?>)bean.get("menu.item[@label]");
	int nbRoots = roots.size();
	List<Map<String,Object>> rootItems = new ArrayList<Map<String,Object>>(); // will be passed to the presentation element
	for ( int i = 0; i < nbRoots; i++ ) {
		// rootData is a Map storing all data relevant to each menu item.
		//
		// For any menu item, the following data is defined:
		//
		//	key			value
		//	--------	-------------------------------------------------------
		//	children 	List<Map> - a list of child menu items
		//	functionid	String - corresponding CS function (see fw.ui.view.Config.functions)
		//	topic		String - optional, indicates an actionable menu item - only if functionid unspecified
		//	topicArgs	String - optional, if topic is defined
		//	label		String - displayable label
		//	deferred	String - URL returning child menu items
		//	popup		String - element to execute to get the child menu items
		//
		// valid combinations:
		//		label/topic/topicArgs/functionId
		//		label/deferred/functionId
		//		label/popup/functionId
		//		label/children/functionId
		//
		Map<String,Object> rootData = new HashMap<String,Object>();
		// bean property name for the current top-level item
		String root = "menu.item(" + i + ")";
		// get label property
		String rootLabel = (String)bean.get(root + "[@label]");
		// store label
		rootData.put("label", rootLabel);
		// level 1 menu items
		try {
			// store children (_buildMenu recursively go though all children)
			rootData.put("children", _buildMenu(root, bean));
			// add root data to the list of roots
			rootItems.add(rootData);
		}
		catch(IllegalArgumentException e) {
			// TODO
		}
		
		request.setAttribute("roots", rootItems);
	}
}
%>
<%!
//
// goes recursively through each child of the starting point, and build
// the required data to build the menu items
//
public List<?> _buildMenu(String startingPoint, ConfigurationDynaBean bean) {
	// get the children from the bean
	Collection<?> menuItems = (Collection<?>)bean.get(startingPoint + ".children.item[@label]");
	List<Object> children = new ArrayList<Object>(); // this is the result list
	
	// go through child menu item
	for ( int i = 0; i < menuItems.size(); i++ ) {
		Map<String,Object> data = new HashMap<String,Object>(); // records the menu item data
		String currentChildAccessor = startingPoint + ".children.item(" + i + ")";
		if (bean.contains(currentChildAccessor, "[@label]")) {
			data.put("label", bean.get(currentChildAccessor + "[@label]").toString());
		}
		if (bean.contains(currentChildAccessor, "[@action]")) {
			data.put("action",  bean.get(currentChildAccessor + "[@action]"));
		}
		if (bean.contains(currentChildAccessor, "[@alwaysEnabled]")) {
			String alwaysEnabled = String.valueOf(bean.get(currentChildAccessor + "[@alwaysEnabled]"));
			data.put("alwaysEnabled", BooleanUtils.toBoolean(alwaysEnabled));
		} else {
			data.put("alwaysEnabled", new Boolean(false));
		}
		if (bean.contains(currentChildAccessor, "[@responsetype]")) {
			data.put("responsetype",  bean.get(currentChildAccessor + "[@responsetype]"));
		}
		
		if (bean.contains(currentChildAccessor, "[@popup]")) {
			data.put("popup", bean.get(currentChildAccessor + "[@popup]"));
		}
		else if (bean.contains(currentChildAccessor, "[@deferred]")) {
			data.put("deferred", bean.get(currentChildAccessor + "[@deferred]"));
		}
		else if (bean.contains(currentChildAccessor+".children.item", "[@label]")) {
			// this menu item has explicitly defined children - let's explore recursively
			data.put("children", _buildMenu(currentChildAccessor, bean));
		}
		else {
			// FIXME not used any more
			if (bean.contains(currentChildAccessor, "[@topic]")) {
				data.put("topic", bean.get(currentChildAccessor + "[@topic]"));
			}
			if (bean.contains(currentChildAccessor, "[@topicArgs]")) {
				data.put("topicArgs", bean.get(currentChildAccessor + "[@topicArgs]"));
			}
		}
		children.add(data);
	}
	return children;
}
%></cs:ftcs>
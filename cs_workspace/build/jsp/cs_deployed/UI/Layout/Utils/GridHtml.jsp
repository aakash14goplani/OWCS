<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ page import="org.apache.commons.configuration.HierarchicalConfiguration"
%><%@ page import="org.apache.commons.configuration.Configuration"
%><%@page import="org.apache.commons.lang.StringEscapeUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%>
<%
// This element creates a grid with the given parameters. The grid created will be an instance of 
// fw.ui.dojox.grid.EnhancedGrid. The parameters to be passed are
//storeURL      : url for the grid store to fetch data.
//storeId       : Unique id of the grid store.
//gridId        :  Unique id of the grid
//storeType     : The dojo store class, it can be dojo.data.ItemFileReadStore or dojo.data.ItemFileWriteStore or extensions of these.
//contextMenuId : The id of the context menu if any to be added for the grid
//selectionMode : What kind of selection is required for the grid.  possible values of selection mode are 'none', 'single', 'multiple' and 'extended'.
//configName    : The configuration element the gird uses to load its columns, for example CustomElements/UI/Layout/Utils/GridConfig
//			     If none is provided it uses UI/Layout/Utils/GridConfig by default.
%>
<cs:ftcs>
	<%! 
		private List<Map<String, String>> getColumnList(ConfigurationDynaBean bn) {
			List<Map<String, String>> columnsToDisplay = new ArrayList<Map<String, String>>();
			if(bn != null) {
				Configuration conf = bn.getConfiguration();
				if(conf != null) {
					HierarchicalConfiguration subConf = (HierarchicalConfiguration)conf.subset("columns");
					if(subConf != null) {
						List<HierarchicalConfiguration> cols = subConf.configurationsAt("column");
						for(HierarchicalConfiguration hConfig : cols) {
							Map<String, String> map = new HashMap<String, String>();
							String fieldName = StringUtils.defaultString(hConfig.getString("fieldname"));
							map.put("fieldname", fieldName);
							String columnName =  StringUtils.defaultString(hConfig.getString("columnname"));
							map.put("columnname", columnName);
							String width =  StringUtils.defaultString(hConfig.getString("width"));
							map.put("width", width);
							String formatter =  StringUtils.defaultString(hConfig.getString("formatter"));
							map.put("formatter", formatter);
							columnsToDisplay.add(map);
						}
					}
				}
			}		
			return columnsToDisplay;
		}
	%>
	<%
		String storeURL = ics.GetVar("storeURL");
		String storeId = ics.GetVar("storeId");
		String gridId = ics.GetVar("gridId");
		String storeType = ics.GetVar("storeType");
		String contextMenuId = StringUtils.defaultString(ics.GetVar("contextMenuId"));
		String contextMenuConfig = StringUtils.defaultString(ics.GetVar("contextMenuConfig"));
		String selectionMode = ics.GetVar("selectionMode");
		ConfigurationDynaBean bn = (ConfigurationDynaBean)request.getAttribute("gridconfig");
		List<Map<String, String>> columnsToDisplay = getColumnList(bn);	
	%>
	<div 
		id="<%=storeId%>"
		data-dojo-id="<%=storeId%>"
		data-dojo-type="<%=storeType%>"
		data-dojo-props="url:'<%=storeURL%>'">
	</div>
	
	<table 
		id='<%=gridId%>'
			data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
			data-dojo-props="
				store: <%=storeId%>,
				noDataMessage: '<span class=gridMessageText>No results</span>',
				sortInfo: 1,
				autoHeight: 10,
				selectionMode:'<%=selectionMode%>',
				plugins: {
					menus: {rowMenu: '<%=contextMenuId%>'}
				}
			">
		<script type="dojo/connect" event="onCellContextMenu" args="row">
				dojo.publish('/fw/ui/contextmenu/update', [this, '<%=contextMenuId%>', row, '<%=contextMenuConfig%>']);
		</script>
		<thead>
			<tr>
			<%
			for(int i=0; i<columnsToDisplay.size(); i++){
				Map<String, String> map = columnsToDisplay.get(i);
				String field = map.get("fieldname");
				String column = map.get("columnname");
				String width = map.get("width");
				String formatter = map.get("formatter");
			%>
				<th field="<%=field%>" formatter="<%=formatter%>" width="<%=width%>"><%=column%></th>
			<%	
			}
			%>
			</tr>
		</thead>
	</table>

</cs:ftcs>
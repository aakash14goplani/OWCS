<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" 
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ page import="org.apache.commons.configuration.HierarchicalConfiguration"
%><%@ page import="org.apache.commons.configuration.Configuration"
%><%@page import="org.apache.commons.lang.StringEscapeUtils"
%><%@page import="org.apache.commons.lang.StringUtils"%>

<cs:ftcs>
	<%
		String searchView = GenericUtil.cleanString(request.getParameter("searchView"));
		String assetType = GenericUtil.cleanString(request.getParameter("assetType"));
		ConfigurationDynaBean bean = (ConfigurationDynaBean)request.getAttribute("searchconfig");
		Map<String, String> assetTypeViewMap = new HashMap<String, String>();
		String listView = "";
		String thumbnailView = "";
		String defaultView = "";
	
		if(bean != null) {
			Configuration conf = bean.getConfiguration();
			listView = conf.getString("listview");
			thumbnailView = conf.getString("thumbnailview");
			defaultView = conf.getString("defaultview");
			
			if(StringUtils.equalsIgnoreCase(defaultView, "listview")){
				defaultView = listView;
			}
			if(StringUtils.equalsIgnoreCase(defaultView, "thumbnailview")){
				defaultView = thumbnailView;
			}

			if(conf != null) {
				HierarchicalConfiguration subConf = (HierarchicalConfiguration)conf.subset("assettypeviews");
				if(subConf != null) {
					List<HierarchicalConfiguration> cols = subConf.configurationsAt("assettype");
					for(HierarchicalConfiguration hConfig : cols) {	
						String assetTypeView = StringUtils.defaultString(hConfig.getRootNode().getValue().toString());
						if(StringUtils.equalsIgnoreCase(assetTypeView, "listview")){
							assetTypeView = listView;
						}
						if(StringUtils.equalsIgnoreCase(assetTypeView, "thumbnailview")){
							assetTypeView = thumbnailView;
						}
						String assetTypeName = StringUtils.defaultString(hConfig.getString("[@name]"));
						assetTypeViewMap.put(assetTypeName, assetTypeView);
					}
				}
			}
		}
	%>
   
    <%
    if(StringUtils.equalsIgnoreCase(searchView, "list")){
    %>
    
    	<controller:callelement elementname="<%=listView%>">
		</controller:callelement>
    <%
    } else if(StringUtils.equalsIgnoreCase(searchView, "thumbnail")){
    %>
    
      	<controller:callelement elementname="<%=thumbnailView%>">
		</controller:callelement>
    
    <%
    }else if(StringUtils.equalsIgnoreCase(searchView, "default")){
    	if(assetType != null && assetTypeViewMap.get(assetType) != null){
    %>
    	<controller:callelement elementname="<%=assetTypeViewMap.get(assetType)%>">
		</controller:callelement>
    
    <%	
    	}else{
    %>
    
    	<controller:callelement elementname="<%=defaultView%>">
		</controller:callelement>
    <%
    	}
    }
    %>

</cs:ftcs>

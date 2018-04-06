<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/BuildWebRefPatternNodes
//
// INPUT
//
// OUTPUT
//%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencePatternBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesPattern"%>
<%@page import="java.util.*"%>
<%@ page import="com.openmarket.basic.interfaces.AssetException" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<cs:ftcs>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
%>
<%
	List<WebReferencePatternBean> patternlist = null;
	try 
	{		
		WebReferencesPattern webReferencesPattern = new WebReferencesPattern(ics);
		patternlist = webReferencesPattern.getForType(ics.GetVar("assettype"));
	} 
	catch (AssetException e) 
	{
		_log.error("Unable to get pattern for given asset type: " + e.getMessage());
	}
	if (patternlist!= null && patternlist.size() > 0) {
		for (WebReferencePatternBean bean : patternlist) 
		{
%>
			<ics:callelement element="OpenMarket/Gator/UIFramework/BuildTreeNodeID">
				<ics:argument name="AdHoc" value='<%=bean.getName()%>'/>
				<ics:argument name="TreeNodeID" value=""/>	
			</ics:callelement>
			
			<ics:removevar name="Description"/>
			<ics:removevar name="LoadURL"/>
			<ics:removevar name="OKActions"/>			
			
			<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/WebRefPattern/PatternUIFront" outstring="ExecuteURL">
				<satellite:argument name="action" value='details'/>
				<satellite:argument name="urlPatternId" value='<%=String.valueOf(bean.getId())%>'/>
				<satellite:argument name="assettype" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			
			<satellite:link assembler="query" pagename="OpenMarket/Gator/UIFramework/TreeOpURL" outstring="OpURL">
				<satellite:argument name="assettype" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			
			<ics:callelement element="OpenMarket/Gator/UIFramework/BuildTreeNode">
				<ics:argument name="Label" value='<%=bean.getName()%>'/>
				<ics:argument name="Description" value='<%=bean.getName()%>'/>
				<ics:argument name="ID" value='<%=ics.GetVar("TreeNodeID")%>'/>
				<ics:argument name="OpURL" value='<%=ics.GetVar("OpURL")%>'/>
				<ics:argument name="ExecuteURL" value='<%=ics.GetVar("ExecuteURL")%>'/>
				<ics:argument name="Image" value='<%=ics.GetVar("cs_imagedir") + "/OMTree/TreeImages/assoc.png"%>'/>
				<ics:argument name="RefreshKeys" value='<%=String.valueOf(bean.getId())%>'/>
			</ics:callelement>
<%
		}
%>
		<ics:removevar name="RefreshKeys"/>
<%		
	}
%>
</cs:ftcs>
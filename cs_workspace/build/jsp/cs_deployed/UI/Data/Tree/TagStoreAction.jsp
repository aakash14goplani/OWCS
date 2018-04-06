<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.fatwire.services.beans.entity.TreeNodeBean"%>
<%@ page import="java.util.List,com.fatwire.services.ServicesManager"%>
<%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"%>
<%@ page import="com.fatwire.system.SessionFactory"%>
<%@ page import="com.fatwire.system.Session"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="com.fatwire.assetapi.data.*"%>
<cs:ftcs>
    <%
        // otherwise, this is normal tree business: 
        // given a current node, we want to determine its child nodes
        //ics.CallElement( "UI/Data/Tree/TreeDataStore", null );
    
        Session ses = SessionFactory.getSession( ics );
        TagManager tagManager = (TagManager) ses.getManager( TagManager.class.getName() );
        List<TagNode> nodeList = tagManager.getSystemTagTree();
	request.setAttribute("nodeList", nodeList);
	
    %>
</cs:ftcs>

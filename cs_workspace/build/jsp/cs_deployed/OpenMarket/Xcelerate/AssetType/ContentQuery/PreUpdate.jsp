<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.fatwire.services.SearchService"%>
<%@page import="com.fatwire.services.SiteService"%>
<%@page import="java.util.*"%>
<%@page import="com.fatwire.ui.util.SearchUtil"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.services.beans.entity.StartMenuBean"%>

<cs:ftcs>
    <ics:if condition='<%="edit".equalsIgnoreCase(ics.GetVar("updatetype"))%>'>
        <ics:then>
            <asset:gather name="theCurrentAsset" prefix="ContentQuery" fieldlist='<%=ics.GetVar("FieldsOnForm")%>'/>      
        </ics:then> 
    </ics:if>
    <ics:if condition='<%="create".equalsIgnoreCase(ics.GetVar("updatetype"))%>'>
        <ics:then>
            <asset:gather name="theCurrentAsset" prefix="ContentQuery" fieldlist='<%=ics.GetVar("FieldsOnForm")%>'/>      
        </ics:then> 
    </ics:if>
    <%
    try{
            Session ses = SessionFactory.getSession();
            ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );		 
            SiteService siteService = servicesManager.getSiteService();            
            long siteId = GenericUtil.getLoggedInSite(ics);
            request.setAttribute("locale", siteService.getLocales(siteId));
            request.setAttribute("author", siteService.getSiteUsers(siteId));	
            List<StartMenuBean> filteredList = GenericUtil.filterStartMenuItems(siteService.getStartMenus(Arrays.asList(StartMenuBean.Type.SEARCH), siteId), ics, true);
            request.setAttribute("assetType", filteredList);	        
            request.setAttribute("mode", "edit");
    } catch(Exception e) {
            request.setAttribute(UIException._UI_EXCEPTION_, new UIException(e));
    }%>
</cs:ftcs>
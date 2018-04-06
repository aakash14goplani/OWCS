<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="com.fatwire.services.util.JsonUtil"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="com.fatwire.assetapi.data.*"%>
<%@page import="com.fatwire.system.*"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<cs:ftcs>
    <%
       Session ses = SessionFactory.getSession();
       TagManager tagManager = (TagManager)ses.getManager( TagManager.class.getName() );
    %>
    <%
    try {
            List<AssetId> assetIds = GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetIds"))));
            String newTags = StringUtils.defaultString(request.getParameter("newTags"));
            String delTags = StringUtils.defaultString(request.getParameter("delTags"));
            String[] newTagList = StringUtils.split(newTags, ';');
            String[] delTagList = StringUtils.split(delTags, ';');
            tagManager.saveTags(assetIds, newTagList, delTagList);
            request.setAttribute("status", "true");
    } catch(Exception e) {
            request.setAttribute(UIException._UI_EXCEPTION_, new UIException(e));
    }%>
</cs:ftcs>
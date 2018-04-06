<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="java.util.List"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="com.fatwire.assetapi.data.*"%>
<%@page import="com.fatwire.system.*"%>

<%@page import="java.lang.StringBuilder"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<cs:ftcs>
    <%
       Session ses = SessionFactory.getSession( ics );
       TagManager tagManager = (TagManager)ses.getManager( TagManager.class.getName() );
    %>
    <%
    StringBuilder sb = new StringBuilder("{\"items\": [");
    try {
            List<String> tagList = tagManager.getSystemTags();
            int size = tagList.size();
            String t = null;
            for(int i = 0; i < size; ) {
                t = tagList.get(i);
                sb.append("{\"name\":\"");
                sb.append(t);
                if(++i != size ) {
                    sb.append("\"},");
                } else {
                     sb.append("\"}");
                }
            }
    } catch(Exception e) {
          request.setAttribute(UIException._UI_EXCEPTION_, new UIException(e));
    } finally {
         sb.append("]}");
    }
%>

    <%=sb.toString()%>

</cs:ftcs>
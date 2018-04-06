<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="com.openmarket.xcelerate.controlpanel.ControlPanel" 
%><%@ page import="com.fatwire.cs.core.uri.Definition" 
%><%@ page import="com.openmarket.basic.seed.TextFormat" 
%><cs:ftcs><% 
    Definition definition = null;
    String c   = null;
    String cid = null;
    String url = ics.GetVar("cs_url");

    if (url != null) 
        definition = ControlPanel.disassemble(url);   
        
    if (definition != null) {
        c = definition.getParameter("c");
        cid = definition.getParameter("cid");
    }
    %>
    	<ics:callelement element='OpenMarket/Xcelerate/Util/validateFields'>
     		<ics:argument name = "columnvalue" value ='<%=cid%>'/>
     		<ics:argument name = "type" value ="Long"/>
     	</ics:callelement>
    <%
    Boolean isValid = new Boolean(ics.GetVar("validatedstatus"));
    if (definition != null && c != null && cid != null && isValid) {
        StringBuffer err = new StringBuffer();              
        String assetTypeDescription = "";
        IList assetType = ics.SQL("AssetType", "select description from AssetType where assettype='" + c + "'",
                                        null, -1, true, err);
        if (assetType != null && assetType.hasData()) {
            assetTypeDescription = assetType.getValue("description");
        }
                
        String pagename = definition.getParameter("pagename");
        String childpagename = definition.getParameter("childpagename");
        IList assetData = ics.SQL(c, "select name, description from " + c + " where id=" + cid,
                                    null, -1, true, err);
        String assetName = "";
        String assetDescription = "";
        String templateName = "";
        String templateDescription =""; 
        String templateSubtype = "";
        if (assetData != null && assetData.hasData()) {
            assetName = assetData.getValue("name");
            assetDescription = assetData.getValue("description");
        }
        String pagelet = (childpagename != null?childpagename:pagename);
        String sql = "select t.name as name, t.description as description, t.subtype as subtype from Template t, SiteCatalog s where t.status!='VO' and s.rootelement=t.rootelement and s.pagename='" + pagelet + "'";
         
        IList templateData = ics.SQL("SiteCatalog,Template", sql,
                                null, -1, true, err);
        if (templateData != null && templateData.hasData()) {
            templateName = templateData.getValue("name");
            templateSubtype = templateData.getValue("subtype");
            if (templateSubtype == null || templateSubtype.length() == 0)
                    templateName = "/" + templateName;
            templateDescription = templateData.getValue("description");
            if (templateDescription == null) templateDescription = "";
        }%>
        {
            "iscspage": true,
            "asset": {
                "id": "<%=cid %>",
                "type": "<%=c %>",
                "name": "<%=TextFormat.EncodeString(assetName) %>",
                "description": "<%=TextFormat.EncodeString(assetDescription) %>",
                "typeDescription": "<%=TextFormat.EncodeString(assetTypeDescription) %>"
            },
            "template": {
                "name": "<%=templateName %>",
                "description": "<%=TextFormat.EncodeString(templateDescription) %>"
            }
        }
    <%} else {%>
        {
            "iscspage": false
        }    
    <%}
%></cs:ftcs>
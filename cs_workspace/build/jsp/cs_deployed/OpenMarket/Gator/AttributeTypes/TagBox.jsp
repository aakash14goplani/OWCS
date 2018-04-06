<%@page import="java.util.List"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.openmarket.basic.seed.TextFormat"%>
<%@page import="java.lang.StringBuilder"%>

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
           %><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
           %><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
           %><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
           %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
           %><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
           %><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
           %><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
           %><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
           %><%@ page import="COM.FutureTense.Interfaces.*,
           COM.FutureTense.Util.ftMessage,
           com.fatwire.assetapi.data.*,
           com.fatwire.assetapi.*,
           COM.FutureTense.Util.ftErrors"
           %><cs:ftcs><%--

INPUT

OUTPUT

    --%>
    <%-- Record dependencies for the SiteEntry and the CSElement --%>
    <ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
    <ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
    <%

    String 	tfWidth = ics.GetVar("width");
    String	inputMaxlength = ics.GetVar("inputMaxlength");
    String	inputValue = ics.GetVar("tagValue");
    String	inputName = "fwtags";
    inputValue = Utilities.goodString(inputValue) ? inputValue : "";
    if (StringUtils.containsAny(URLDecoder.decode(inputValue, "utf-8"), "<>:;%?\'")) {
        inputValue = TextFormat.EncodeString(inputValue);
    }
    Boolean	readOnly = ics.GetVar("readOnly") == null ? true : Boolean.parseBoolean(ics.GetVar("readOnly"));
    Boolean	showCloseButton = ics.GetVar("showCloseButton") == null ? true : Boolean.parseBoolean(ics.GetVar("showCloseButton"));
    String styleClass = "";
    if(readOnly) {
        styleClass = "readonlyTagListInput";
    }
    %>
    <script type="text/javascript">
        dojo.require("dijit.layout.ContentPane");
        dojo.require("fw.dijit.UIDialog");
        dojo.require("dijit.form.TextBox");
        dojo.require("fw.ui.dijit.Button");
        dojo.require("fw.ui.ObjectFactory");
        dojo.require("fw.ui.manager.DialogManager");
        dojo.require("dojox.validate.regexp");
        dojo.require("fw.ui.dojox.form.TagListInput");
        dojo.require("dojo.data.ItemFileReadStore");
    </script>
    
    <div name='<%=inputName %>' value='<%=inputValue %>' delimiter=';' dojoType='fw.ui.dojox.form.TagListInput' readOnlyItem='true' readOnlyInput='<%=readOnly %>' showCloseButtonWhenValid='<%=showCloseButton %>' showCloseButtonWhenInvalid='<%=showCloseButton %>' class='<%=styleClass %>'></div>

    <ics:removevar name="width"/>
    <ics:removevar name="inputMaxlength"/>
    <ics:removevar name="inputValue"/>
    <ics:removevar name="inputName"/>
    <ics:removevar name="readOnly"/>
    <ics:removevar name="showCloseButton"/>

</cs:ftcs>
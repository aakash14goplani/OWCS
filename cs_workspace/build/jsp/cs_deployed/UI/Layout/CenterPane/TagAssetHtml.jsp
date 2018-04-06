<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.util.JsonUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="com.fatwire.assetapi.data.*"%>
<%@page import="com.fatwire.system.*"%>

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<cs:ftcs>
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
    <%
        Session ses = SessionFactory.getSession( ics );
        TagManager tagManager = (TagManager)ses.getManager( TagManager.class.getName() );
    %>
    <%
       String assignTags = "";
       String assignedTags = "";
       try {
            List<AssetId> assetIds = JsonUtil.jsonToIdList(ics.GetVar("assetIds"));
            List<String> assignTagList = tagManager.getCommonTags(assetIds);
            List<String> assignedTagList = tagManager.getAllTags(assetIds);
            assignTags = StringUtils.join(assignTagList, ";");
            assignedTags = StringUtils.join(assignedTagList, ";");
            
       } catch (Exception e) {
           request.setAttribute(UIException._UI_EXCEPTION_, new UIException(e));
       }
    %>

    <div class="saveSearchContainer searchDisplayPaneContainer">
        <label><xlat:stream key="UI/UC1/Layout/TagAppliedToAllAssets"/>:</label>
        <br/>
        <div id='assignTags' name='assignTags' value="<%=assignTags %>" delimiter=';' dojoType='fw.ui.dojox.form.TagListInput' readOnlyItem='true' readOnlyInput='false' showCloseButtonWhenValid='true' showCloseButtonWhenInvalid='true' ></div>
        <br/>
        <label><xlat:stream key="UI/UC1/Layout/TagAppliedToSomeAssets"/>:</label>
        <br/>
        <div id='assignedTags' name='assignedTags' value='<%=assignedTags %>' delimiter=';' dojoType='fw.ui.dojox.form.TagListInput' readOnlyItem='true' readOnlyInput='true' showCloseButtonWhenValid='true' showCloseButtonWhenInvalid='true' ></div>
        <input id='allAssignedTags' name='allAssignedTags' type='hidden' value='<%=assignedTags %>' />
        <input id='allAssignTags' name='allAssignTags' type='hidden' value='<%=assignTags %>' />
        <br/>
    </div>
</cs:ftcs>
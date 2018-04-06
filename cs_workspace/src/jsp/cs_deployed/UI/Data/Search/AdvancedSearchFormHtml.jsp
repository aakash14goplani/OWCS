<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.beans.entity.StartMenuBean"%>
<%@page import="java.util.List"%>
<%@page import="com.fatwire.ui.util.SearchUtil"%>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.services.beans.entity.UserBean"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%><cs:ftcs><%
try {	
    String saveSearchName = StringUtils.defaultString(request.getParameter("saveSearchName"));
    String[] params = request.getParameterValues("roles");
    String roles = StringUtils.join(params, ",");
    String mode = StringUtils.defaultString(request.getParameter("mode"));
    boolean isEdit = StringUtils.equalsIgnoreCase(mode, "edit");
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
<div class="advancedSearchForm">
	<%if(isEdit){ %>
		<h2><xlat:stream key="UI/Search/EditSavedSearch"/></h2>
		<div class="advancedSearchFormContent">
		<!-- Load the context menu -->
		<controller:callelement elementname="UI/Layout/CenterPane/Search/View/SaveSearchView">
			<controller:argument name="saveSearchName" value="<%=saveSearchName%>" />
			<controller:argument name="roles" value="<%=roles%>" />
			<controller:argument name="mode" value="<%=mode%>" />
		</controller:callelement>
	<%}else{%>	
		<h2><xlat:stream key="dvin/UI/advancedsearch"/></h2>
		<div class="advancedSearchFormContent">
	<%} %>
	
        <ics:callelement element="UI/Data/Search/AdvancedFormHtml"/>
	
		<div class='searchButtons'><%
		if(isEdit){
			%><div id='saveSmartListBtn' class="searchButtonNode" dojoType="fw.ui.dijit.Button" label="<xlat:stream key='UI/Forms/Save'/>"></div><%
		}else{%>
				<div id="advancedSearchBtn" class="searchButtonNode" dojoType="fw.ui.dijit.Button" label="<xlat:stream key='UI/UC1/Layout/RunSearch'/>"></div>
				<div id="advancedResetBtn" class="searchButtonNode"dojoType="fw.ui.dijit.Button" label="<xlat:stream key='fatwire/Alloy/UI/Reset'/>"></div><%
		}%></div>
	</div>
</div><%
}catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
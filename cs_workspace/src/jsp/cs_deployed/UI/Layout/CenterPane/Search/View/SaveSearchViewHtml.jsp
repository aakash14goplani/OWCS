<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
try {
	String saveSearchName = StringUtils.defaultString(GenericUtil.cleanString(request.getParameter("saveSearchName")));
	String[] params = request.getParameterValues("roles");
    String roles = StringUtils.join(params, ",");
	String storeUrl = GenericUtil.buildControllerURL("UI/Data/Search/GetRoles", GenericUtil.JSON);
	String mode = StringUtils.defaultString(GenericUtil.cleanString(request.getParameter("mode")));
	boolean isEdit = StringUtils.equalsIgnoreCase(mode, "edit");
%><div id="smartListContainer" class="saveSearchContainer searchDisplayPaneContainer">
	<h3><xlat:stream key="dvin/UI/SaveSearch"/></h3>
	<div class="searchField">
		<%if(isEdit){ %>
			<div class="label"><strong><xlat:stream key="UI/UC1/Layout/SmartListName"/></strong></div>
		<%}%>
		<input type="text"
			dojoType="fw.dijit.UIInput"
			id="saveSearchNameBox"
			class="saveSearchNameBox"
			placeHolder="<xlat:stream key='UI/UC1/Layout/EnterName'/>"
			required="true"
			showErrors="true"
			value="<%=saveSearchName%>"	
			maxLength="64"
			missingMessage="<xlat:stream key='UI/UC1/Layout/PleaseEnterName'/>" />
		<span id="saveSearchShareButton" dojoType="fw.ui.dijit.Button" <%if(!isEdit){ %>buttonStyle="greySmall"<%}%> label="<xlat:stream key='dvin/Common/Share'/>" title="<xlat:stream key='UI/Search/SavedSearchMessage8'/>"></span>
	</div>
	<div id="transferBoxDiv" class="transferBox" style="display:none">
		<div dojoType="dojo.data.ItemFileReadStore"  url="<%=storeUrl%>" jsId="rolesstore"></div>
		<select dojotype="fw.dijit.UITransferBox"
			id="rolesTransferBox"
			name="rolesTransferBox"
			required="true"
			size="8"
			store="rolesstore"
			selectedItems="<%=roles%>"
			storeStructure="{title:'name', value:'name'}"
			title1="<xlat:stream key="UI/Search/Rolestosharewith"/>" title2="<xlat:stream key="dvin/Common/Selected"/>">
		</select>
	</div>
</div><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
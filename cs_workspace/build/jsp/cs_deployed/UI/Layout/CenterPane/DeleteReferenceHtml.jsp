<%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.ui.beans.KeyValuePair"
%><%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="org.apache.commons.lang.math.NumberUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<cs:ftcs>
<%
	long aId = NumberUtils.toLong(request.getParameter("assetId"));
	String aType = StringUtils.defaultString(request.getParameter("assetType"));
	
	String aName = StringUtils.defaultString(request.getParameter("assetName"));
	// Encode and Clean for XSS 	
	aName = GenericUtil.cleanString(aName)  ; 		
	
	String numRef = StringUtils.defaultString(request.getParameter("numRef"));
	int gridLoadSize = NumberUtils.toInt(numRef);
	AssetId assetId = new AssetIdImpl(aType, aId);
	String strAssetId = String.valueOf(assetId).replaceAll(":", "_");
	String storeId = "deleteRefStore_" + strAssetId;
	String gridId = "deleteRefGrid_" + strAssetId;
	String numRefId = "deleteRefNum_" + strAssetId;
	String jsonAssetId = JsonUtil.toJson(assetId);
	String buttonId = "deleteAllRefsButton_" + StringUtils.defaultString(request.getParameter("activeViewId"));
	KeyValuePair<String, String> assetIdParam = new KeyValuePair<String, String>("assetId", jsonAssetId);
	String storeURL = GenericUtil.buildControllerURL("UI/Data/Asset/GetReferringAssets", GenericUtil.JSON, assetIdParam);
	storeURL = storeURL.replace("\"", "\\\'");
%><div class="titleArea">
	<h2><xlat:stream key="UI/UC1/Layout/AssetsReferences" evalall="false">
			<xlat:argument name="assetname" value='<%=aName%>'/>
		</xlat:stream></h2>
</div>
<div class="messageArea">
	<div id="deleteReferencesHelp" class="helpMessage"><a href="#"><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></a> <img src="wemresources/images/ui/wem/helpIcon.png" height="19" width="19" alt="<xlat:stream key="UI/UC1/Layout/HowDoesItWork"/>" /></div>
	<div data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'deleteReferencesHelp', position:'below','class':'helpTextTooltip'">
		<xlat:stream key="UI/UC1/Layout/ReferenceHelpText"/>
	</div>
	<a href="#" onclick="fw.ui.GridFormatter.selectAllRows('<%=gridId%>')"><xlat:stream key="dvin/Common/SelectAll"/></a>
</div>

<div data-dojo-type="fw.ui.dojox.data.CSItemFileWriteStore" 
	 jsId='<%=storeId%>' 
	 data-dojo-props="url:'<%=storeURL%>',requestMethod: 'get'">
</div>
<table 
	id='<%=gridId%>'
	data-dojo-type="fw.ui.dojox.grid.DataGrid"
	data-dojo-props="
		store: <%=storeId%>,
		noDataMessage: '<xlat:stream key="UI/UC1/Layout/SearchInfo1" escape="true"/>',
		rowsPerPage: <%=gridLoadSize%>,
		autoHeight: 10,
		autoWidth: true
	">
	<thead>
		<tr>
			<th field="name" formatter="fw.ui.GridFormatter.nameFormatter" width="250px"><xlat:stream key="dvin/Common/Name"/></th>
			<th field="type" width="120px"><xlat:stream key="dvin/Common/Type"/></th>
			<th field="detail" width="390px"><xlat:stream key="UI/UC1/Layout/Detail"/></th>
			<th field="actiontext" formatter="fw.ui.GridFormatter.deleteReferenceAction" width="130px"><xlat:stream key="dvin/UI/Admin/Action"/></th>
		</tr>
	</thead>
</table>
<div class="buttons">
	<div
		id="<%=buttonId%>"
		data-dojo-type="fw.ui.dijit.Button"
		data-dojo-props="
			onClick: function() {
				SitesApp.event('active', 'remove-references', {assetId: {id: '<%=aId%>', type: '<%=aType%>'}, gridId: '<%=gridId%>'})
			},
			assetId: <%=aId%>,
			assetType: '<%=aType%>',
			assetName: '<%=aName%>'">
		<xlat:stream key="UI/UC1/Layout/RemoveReference"/>
	</div>
</div>

</cs:ftcs>
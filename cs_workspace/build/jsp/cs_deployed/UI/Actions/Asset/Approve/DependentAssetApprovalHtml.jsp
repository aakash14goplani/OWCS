<%@page import="com.fatwire.services.ui.beans.UIDestinationBean"
%><%@page import="com.fatwire.services.beans.entity.DestinationBean.Type"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="java.util.List"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
try {
	List<UIApprovalBean> result = GenericUtil.emptyIfNull((List<UIApprovalBean>) request.getAttribute("result"));
	UIDestinationBean uiDestinationBean = (UIDestinationBean) request.getAttribute("destination");
	if(uiDestinationBean != null) {
		String json = "{\"identifier\":\"id\",\"items\":" + new ObjectMapper().writeValueAsString(result) + "}";
	
		String assetName = ics.GetVar("assetName");
		String assetId = request.getParameter("assetId");
		Type destinationType = Type.toEnum(uiDestinationBean.getType());
	
		String viewId = request.getParameter("viewId");
		String gridId = "approveDependentsGrid_" + viewId;
		String buttonId = "approveDependentsButton_" + viewId;
		String storeId = ("approveDependentsStore_" + viewId).replace('-','_');
%><div dojoType="dojo.data.ItemFileReadStore" data='<%= json%>' jsId="<%=GenericUtil.cleanString(storeId)%>"></div>
<div class="titleArea">
	<h2><xlat:stream key="UI/UC1/Layout/DependenciesFor" evalall="false">
			<xlat:argument name="assetname" value='<%=assetName%>'/>
		</xlat:stream>
	</h2>
</div>
<div class="messageArea">
	<div id="approvalDependentsHelp" class="helpMessage"><a href="#"><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></a> <img src="wemresources/images/ui/wem/helpIcon.png" height="19" width="19" alt="<xlat:stream key="UI/UC1/Layout/HowDoesItWork"/>" /></div>
	<div data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'approvalDependentsHelp', position:'below','class':'helpTextTooltip'"><xlat:stream key="UI/UC1/Layout/DependantsHelpText"/></div>
	<a href="#" onclick="fw.ui.GridFormatter.selectAllRows('<%=GenericUtil.cleanString(gridId)%>')"><xlat:stream key="dvin/Common/SelectAll"/></a>
</div>
<table 
	id="<%=GenericUtil.cleanString(gridId)%>"
	data-dojo-type="fw.ui.dojox.grid.DataGrid"
	data-dojo-props="
		store: <%=storeId%>,
		autoHeight: 10,
		autoWidth: true,
		assetId: '<%=GenericUtil.cleanString(assetId)%>',
		rowsPerPage: <%=result.size()%>,
		assetName: '<%=assetName%>'
	">
	<script type="dojo/connect" event="_onFetchComplete">
		if(this.rowCount === 0) {
			var contentPaneId = "approveDependentContainer_" + "<%= GenericUtil.cleanString(viewId)%>",
				approveDependentContainer = dijit.byId(contentPaneId);
			approveDependentContainer.set('content', '');
		}
	</script>
	<thead>
		<tr>
			<th field="name" formatter="fw.ui.GridFormatter.nameFormatter" width="200px"><xlat:stream key="dvin/Common/Name"/></th>
			<th field="type" width="80px"><xlat:stream key="dvin/Common/Type"/></th><%
			if(destinationType == Type.REAL_TIME) {
				%><th field='lastPublishedDate' formatter="fw.ui.GridFormatter.lastPublishedDate" width="160px"><xlat:stream key="UI/UC1/Layout/LastPublished"/></th><%
			}
			%><th field="status" width="100px"><xlat:stream key="dvin/AT/Common/Status"/></th>
			<th field='detail' formatter="fw.ui.GridFormatter.approveDetail" width="220px"><xlat:stream key="UI/UC1/Layout/Detail"/></th>
			<th field="action" formatter="fw.ui.GridFormatter.blockingAssetsAction" width="130px"><xlat:stream key="dvin/UI/Admin/Action"/></th>
		</tr>
	</thead>
</table>
<div class="buttons">
	<div
		id="<%=GenericUtil.cleanString(buttonId)%>"
		data-dojo-type="fw.ui.dijit.Button"
		data-dojo-props="
			onClick: function() {
				SitesApp.event('active', 'approve-selected-blocking', {parentAssetId: '<%=GenericUtil.cleanString(assetId)%>', parentAssetName: '<%=GenericUtil.cleanString(assetName)%>'});
			}
		"><xlat:stream key="dvin/UI/AssetMgt/Approve"/></div>
</div><%
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
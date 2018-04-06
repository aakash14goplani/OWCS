<%@page import="com.fatwire.services.beans.entity.DestinationBean.Type"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.ui.beans.UIDestinationBean"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
try {
	List<UIApprovalBean> result = GenericUtil.emptyIfNull((List<UIApprovalBean>) request.getAttribute("result"));
	UIDestinationBean uiDestinationBean = (UIDestinationBean) request.getAttribute("destination");
	if(uiDestinationBean != null) {
		String json = "{\"identifier\":\"id\",\"items\":" + new ObjectMapper().writeValueAsString(result) + "}";
		
		String destinationName = uiDestinationBean.getName();
		Type destinationType = Type.toEnum(uiDestinationBean.getType());
		uiDestinationBean.populatePublishEventDetails();
		String publishSchedule = uiDestinationBean.getPublishSchedule();
		String publishEventState = uiDestinationBean.getPublishEventState();

		String viewId = GenericUtil.cleanString(request.getParameter("viewId"));
		String gridId = "approveGrid_" + viewId;
		String scheduleTooltipConnector = "scheduleTooltipConnector_" + viewId;
		String scheduleTooltip = "scheduleTooltip_" + viewId;
		String helpTooltipConnector = "helpTooltipConnector_" + viewId;
		String helpTooltip = "helpTooltip_" + viewId;
		String button1Id = "approveAssetsButton_" + viewId;
		String button2Id = "approveAssetsWithDependenciesButton_" + viewId;
		String contentPaneId = "approveDependentContainer_" + viewId;
		String storeId = "approveStore_" + viewId;
		storeId = storeId.replace('-','_');
%>
<div dojoType="fw.ui.dojox.data.CSItemFileWriteStore" data='<%=json%>' jsId="<%=storeId%>"></div>
<div id='viewContainer_<%= viewId%>' data-dojo-type='dijit.layout.BorderContainer'>
	<controller:callelement elementname='UI/Layout/CenterPane/Toolbar' responsetype='html' />
	<div id='contentPane_<%= viewId%>' data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'fwGridContainer commonViewPane'">
		<div id='loadingWrapper_<%= viewId%>' class='loadingWrapper'>
			<div class='loadingContent'>
				<xlat:lookup key="dvin/UI/Loadingdotdotdot" varname="loadingtext"/>
				<img src="js/fw/images/ui/wem/loading.gif" alt='<%=ics.GetVar("loadingtext")%>' height="32" width="32" /><br />
				<ics:getvar name="loadingtext"/>
			</div>
		</div>
		<div class="pageWrapper">
			<div class="contentWrapper">
				<div class="titleArea">
					<h2><%=destinationName%></h2>
					<xlat:stream key="UI/UC1/Layout/ApprovalViewMessage1"/><br/>
									
					<span id="<%=scheduleTooltipConnector%>" class="helpMessage"><a href="#"><%=publishEventState%></a></span>
					<div id="<%=scheduleTooltip%>" data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="position:'below','class':'helpTextTooltip'">
						<%=publishSchedule%>
					</div>
					
					<br /><br />
					<div class='filters'><xlat:stream key="dvin/Common/Show"/> 
						<div
							data-dojo-type="dijit.form.CheckBox"
							data-dojo-props="
								id: 'gridFilter_1_<%= viewId %>',
								name: 'all'
						" > </div>
						<label for="gridFilter_1_<%= viewId %>"><xlat:stream key="dvin/Common/All"/></label>
						
						<div
							data-dojo-type="dijit.form.CheckBox"
							data-dojo-props="
								id: 'gridFilter_2_<%= viewId %>',
								name: 'page'
						" ></div>
						<label for="gridFilter_2_<%= viewId %>"><xlat:stream key="dvin/TreeApplet/PlacedPages"/></label>
						
						<div
							data-dojo-type="dijit.form.CheckBox"
							data-dojo-props="
								id: 'gridFilter_3_<%= viewId %>',
								name: 'deviceImage'
						" ></div>
						<label for="gridFilter_3_<%= viewId %>"><xlat:stream key="fatwire/admin/DeviceImages"/></label>
						
						<div
							data-dojo-type="dijit.form.CheckBox"
							data-dojo-props="
								id: 'gridFilter_4_<%= viewId %>',
								name: 'deviceGroup'
						" ></div>
						<label for="gridFilter_4_<%= viewId %>"><xlat:stream key="dvin/AdminForms/DeviceGroups"/></label>
					</div>
				</div>	
				
				<div class="messageArea">
					<div id="<%=helpTooltipConnector%>" class="helpMessage"><a href="#"><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></a> <img src="wemresources/images/ui/wem/helpIcon.png" height="19" width="19" alt="<xlat:stream key="UI/UC1/Layout/HowDoesItWork"/>" /></div>
					<div id="<%=helpTooltip%>" data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="position:'below','class':'helpTextTooltip'">
						<xlat:stream key="UI/UC1/Layout/ApproveHelpText" escape="false" encode="false" />
					</div>
					<div><a href="#" onclick="fw.ui.GridFormatter.selectAllRows('<%=gridId%>')"><xlat:stream key="dvin/Common/SelectAll"/></a></div>
				</div>
				
				<table
					id="<%=gridId%>"
					data-dojo-type="fw.ui.dojox.grid.DataGrid"
					data-dojo-props="
						store: <%=storeId%>,
						noDataMessage: '<xlat:stream key="UI/UC1/Layout/NoAssetsForApproval" escape="true"/>',
						autoHeight: 10,
						autoWidth: true,
						rowsPerPage: <%=result.size()%>
					">
					<script type="dojo/connect" event="_onFetchComplete">fw.ui.GridFormatter.selectAllRows('<%=gridId%>');</script>
					<thead>
						<tr>
							<th field='name' formatter="fw.ui.GridFormatter.nameFormatter" width="200px"><xlat:stream key="dvin/Common/Name"/></th>
							<th field='type' width="80px"><xlat:stream key="dvin/Common/Type"/></th><%
							if(destinationType == Type.REAL_TIME) {
								%><th field='lastPublishedDate' formatter="fw.ui.GridFormatter.sitePlanFormatters.lastPublishedDate" width="160px"><xlat:stream key="UI/UC1/Layout/LastPublished"/></th><%
							}
							%><th field='status' width="100px"><xlat:stream key="dvin/AT/Common/Status"/></th>
							<th field='detail' formatter="fw.ui.GridFormatter.approveDetail" width="220px"><xlat:stream key="UI/UC1/Layout/Detail"/></th>
							<th field='actiontype'  formatter="fw.ui.GridFormatter.approveAction" width="130px"><xlat:stream key="dvin/UI/Admin/Action"/></th>
						</tr>
					</thead>
				</table>
				<div class="buttons">
					<div
						id="<%=button1Id%>"
						data-dojo-type="fw.ui.dijit.Button"
						data-dojo-props="
							onClick: function() {
								SitesApp.event('active', 'approve-all');
							}">
							<xlat:stream key="dvin/UI/AssetMgt/Approve"/>
					</div><%
					if(destinationType == Type.REAL_TIME || destinationType == Type.MIRROR) {
					%>
					<div
						id="<%=button2Id%>"
						data-dojo-type="fw.ui.dijit.Button"
						data-dojo-props="
							onClick: function() {
								SitesApp.event('active', 'approve-all-recursive');
							}">
						<xlat:stream key="UI/UC1/Layout/ApproveWithDependencies"/>
					</div><%
					}
				%></div>
			</div><br>
			<div class="contentWrapper">
				<div id="<%=contentPaneId%>" data-dojo-type="dijit.layout.ContentPane"></div>
			</div>
		</div>
	</div>
</div><%
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
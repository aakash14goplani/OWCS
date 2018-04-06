<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.ui.beans.UIVersionBean"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
try {
	List<UIVersionBean> result = GenericUtil.emptyIfNull((List<UIVersionBean>)request.getAttribute("result"));
	String json = new ObjectMapper().writeValueAsString(result);
	String jsonString = new StringBuffer("{\"identifier\":\"id\",\"label\":\"name\",\"items\":").append(json).append("}").toString();

	String viewId = GenericUtil.cleanString(request.getParameter("viewId"));	
	String gridId = "versioningGrid_" + viewId;
	String helpTooltip = "versioningHelp_" + viewId;
	String checkoutButtonId = "checkoutButton_" + viewId;
	String undocheckoutButtonId = "undocheckoutButton_" + viewId;
	String checkinButtonId = "checkinButton_" + viewId;
	String checkInContainerId = "checkInContainer_" + viewId;
	String checkInContainerCommentId = "checkInContainerComment_" + viewId;
	String checkInContainerKeepCheckedOutId = "checkInContainerKeepCheckedOut_" + viewId;
	String checkInContainerCheckinId = "checkInContainerCheckin_" + viewId;
	String storeId = "versioningStore_" + viewId;
	storeId = storeId.replace("-","_");
%>
<div dojoType="fw.ui.dojox.data.CSItemFileWriteStore" 
	 data='<%= jsonString%>' jsId="<%= storeId%>">
</div>
<div id='viewContainer_<%= viewId%>' data-dojo-type='dijit.layout.BorderContainer'>
	<controller:callelement elementname='UI/Layout/CenterPane/Toolbar' responsetype='html' />
	<div id='contentPane_<%= viewId%>' data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'fwGridContainer commonViewPane'">
		<div class="pageWrapper">
			<div class="contentWrapper">
				<div class="titleArea">
					<h2><xlat:stream key="UI/UC1/Layout/AssetToBeCheckedIn"/></h2>
				</div>
				<div class="messageArea">
					<div id="<%=helpTooltip%>" class="helpMessage"><a href="#"><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></a> <img src="wemresources/images/ui/wem/helpIcon.png" height="19" width="19" alt="<xlat:stream key="UI/UC1/Layout/HowDoesItWork"/>" /></div>
					<div data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'<%=helpTooltip%>', position:'below','class':'helpTextTooltip'">
						<xlat:stream key="UI/UC1/Layout/CheckinHelpText"/>
					</div>
					<a href="#" onclick="fw.ui.GridFormatter.selectAllRows('<%=gridId%>')"><xlat:stream key="dvin/Common/SelectAll"/></a>
				</div>
				<table
					id="<%=gridId%>"
					data-dojo-type="fw.ui.dojox.grid.DataGrid"
					data-dojo-props="
						store: <%=storeId%>,
						noDataMessage: '<xlat:stream key="UI/UC1/Layout/SearchInfo1" escape="true"/>',
						rowsPerPage: <%=result.size()%>,
						autoHeight: 10,
						autoWidth: true">
					<script type="dojo/connect" event="_onFetchComplete">fw.ui.GridFormatter.selectAllRows('<%=gridId%>');</script>
					<thead>
						<tr>
							<th field='name' formatter="fw.ui.GridFormatter.nameFormatter" width="240px"><xlat:stream key="dvin/Common/Name"/></th>
							<th field='type' width="80px"><xlat:stream key="dvin/Common/Type"/></th>
							<th field='versionnum' width="50px"><xlat:stream key="dvin/Common/Version"/></th>
							<th field='comment' width="60px" formatter="fw.ui.GridFormatter.checkinComment"><xlat:stream key="dvin/AdminForms/Comment"/></th>
							<th field='status' width="100px"><xlat:stream key="dvin/AT/Common/Status"/></th>
							<th field='detail' width="250px"><xlat:stream key="UI/UC1/Layout/Detail"/></th>
							<th field='actiontext' formatter="fw.ui.GridFormatter.versioningAction" width="90px"><xlat:stream key="dvin/UI/Admin/Action"/></th>
						</tr>
					</thead>
				</table>
				<div class="buttons">
					<div
						id="<%= checkoutButtonId%>"
						data-dojo-type="fw.ui.dijit.Button"
						type="button"
						data-dojo-props="
							onClick: function() {
								SitesApp.event('active', 'checkout-selected');
							}">
						<xlat:stream key="UI/UC1/Layout/Checkout"/>
					</div>
					<div
						id="<%= undocheckoutButtonId%>"
						data-dojo-type="fw.ui.dijit.Button"
						type="button"
						data-dojo-props="
							onClick: function() {
								SitesApp.event('active', 'undocheckout-selected');
							}">
						<xlat:stream key="UI/UC1/Layout/UndoCheckout"/>
					</div>
					<div
						id="<%= checkinButtonId%>"
						data-dojo-type="fw.ui.dijit.Button"
						type="button"
						data-dojo-props="
							onClick: function() {
								SitesApp.event('active', 'checkin-selected');
							}">
						<xlat:stream key="UI/UC1/Layout/Checkin"/>
					</div>
				</div>
				<div id="<%= checkInContainerId%>" class="checkInCommentWrapper" style="display:none">
					<div class="titleArea">
						<h2><xlat:stream key="UI/UC1/Layout/AddComment1"/></h2>
						<xlat:stream key="UI/UC1/Layout/AddComment2"/>
					</div>
					<div class="messageArea">
						<textarea id="<%= checkInContainerCommentId%>" style="width:100%;height=100px"></textarea>
					</div>
					<div class="buttons">
						<button 
							id='<%= checkInContainerCheckinId%>'
							data-dojo-type="fw.ui.dijit.Button"
							type="button">
							<xlat:stream key="UI/UC1/Layout/Checkin"/>
						</button>
						<div class="checkInCheckBox"><input type="checkbox" id="<%= checkInContainerKeepCheckedOutId%>" /> <xlat:stream key="dvin/Common/KeepCheckedOut"/></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;

}%></cs:ftcs>
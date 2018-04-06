<%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ui.beans.UIDeleteBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
try {
	List<UIDeleteBean> result = GenericUtil.emptyIfNull((List<UIDeleteBean>) request.getAttribute("result"));
	String json = new StringBuffer("{\"identifer\":\"id\",\"label\":\"name\",\"items\":").append(new ObjectMapper().writeValueAsString(result)).append("}").toString();
	
	String viewId = GenericUtil.cleanString(request.getParameter("viewId"));
	String gridId = "deleteGrid_" + viewId;
	String contentPaneId = "deleteReferenceContainer_" + viewId;
	String helpTooltip = "deletePageHelp_" + viewId;
	String storeId = "deleteStore_" + viewId;
	storeId = storeId.replace('-','_');
%>
<div dojoType="fw.ui.dojox.data.CSItemFileWriteStore" 
	 data='<%= json%>' jsId="<%=storeId%>">
</div>
<div id="viewContainer_<%= viewId%>" data-dojo-type="dijit.layout.BorderContainer">
	<controller:callelement elementname="UI/Layout/CenterPane/Toolbar" responsetype="html"/>
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
					<h2><xlat:stream key="UI/UC1/Layout/DeleteAssets"/></h2>
				</div>
				<div class="messageArea">
					<div id="<%=helpTooltip%>" class="helpMessage"><a href="#"><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></a> <img src="wemresources/images/ui/wem/helpIcon.png" height="19" width="19" alt="<xlat:stream key="UI/UC1/Layout/HowDoesItWork"/>" /></div>
					<div data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'<%=helpTooltip%>', position:'below','class':'helpTextTooltip'">
						<xlat:stream key="UI/UC1/Layout/DeleteHelpText"/>
					</div>
					<div><a href="#" onclick="fw.ui.GridFormatter.selectAllRows('<%=gridId%>')"><xlat:stream key="dvin/Common/SelectAll"/></a></div>
				</div>
				<table
					id="<%=gridId%>"
					data-dojo-type="fw.ui.dojox.grid.DataGrid"
					data-dojo-props="
						store: <%=storeId%>,
						noDataMessage: '<xlat:stream key="UI/UC1/Layout/NoAssetsForDeletion" escape="true"/>',
						rowsPerPage: <%=result.size()%>,
						autoHeight: 10,
						autoWidth: true
					">
					<script type="dojo/connect" event="_onFetchComplete">fw.ui.GridFormatter.selectAllRows('<%=gridId%>');</script>
					<thead>
						<tr>
							<th field='name' formatter="fw.ui.GridFormatter.nameFormatter" width="250px"><xlat:stream key="dvin/Common/Name"/></th>
							<th field='type' width="120px"><xlat:stream key="dvin/Common/Type"/></th>
							<th field='detail' formatter="fw.ui.GridFormatter.deleteDetail" width="390px"><xlat:stream key="UI/UC1/Layout/Detail"/></th>
							<th field='actionType' formatter="fw.ui.GridFormatter.deleteAction" width="130px"><xlat:stream key="dvin/UI/Admin/Action"/></th>
						</tr>
					</thead>
				</table>
				<div class="buttons">
					<button 
						data-dojo-type="fw.ui.dijit.Button"
						type="button"
						data-dojo-props="
							onClick: function() {
								//fw.ui.app.docController.getActiveController().deleteAssets('<%=gridId%>');
								SitesApp.event('active', 'delete-selected', {'gridId': '<%=gridId%>'});
							}">
						<xlat:stream key="dvin/Common/Delete"/>
					</button>
				</div>
			</div><br>
			<div class="contentWrapper">
				<div id="<%=contentPaneId%>" data-dojo-type="dijit.layout.ContentPane"></div>
			</div>
		</div>
	</div>
</div><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
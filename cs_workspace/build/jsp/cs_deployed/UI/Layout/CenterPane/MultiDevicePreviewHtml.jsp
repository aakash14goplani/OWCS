<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="com.fatwire.mobility.beans.SkinInfoBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceImageBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="javax.imageio.ImageIO, javax.swing.ImageIcon, java.awt.Image, java.net.URL, java.util.List, java.awt.image.BufferedImage"%>
<%@ page import="COM.FutureTense.Mobility.DeviceService,com.fatwire.cs.core.mobility.ServiceLocator,com.fatwire.cs.core.mobility.device.Device,com.fatwire.cs.core.mobility.device.DeviceCapabilities,com.fatwire.cs.core.mobility.DeviceProperties"%>

<cs:ftcs>
<div id='viewContainer_<ics:getvar name="viewId" />' dojoType='dijit.layout.BorderContainer'>
	<xlat:lookup key="UI/UC1/JS/WebView" varname="label"/>
	<controller:callelement elementname='UI/Layout/CenterPane/Toolbar' responsetype='html'>
		<controller:argument name="showRefresh" value="true" />
		<controller:argument name="isWebMode" value="true" />
		<controller:argument name="label" value='<%=ics.GetVar("label")%>' />
	</controller:callelement>
	
	
	<div dojoType="dijit.layout.ContentPane" region="center" class="insiteArea previewArea mobilityMultiDevicePreview">
		<%
			List<DeviceImageBean> listDeviceImages = (List<DeviceImageBean>) request.getAttribute("listDeviceImages");
			List<DeviceGroupBean> deviceGroupList = (List<DeviceGroupBean>) request.getAttribute("deviceGroupList");
			String deviceGroupName = "";
			for (int i = 0; i < deviceGroupList.size(); i++)
			{
				if(String.valueOf(deviceGroupList.get(i).getId()).equals(request.getAttribute("devicegroup")))
					deviceGroupName = deviceGroupList.get(i).getName();
			}
		%>
			<div id='loadingWrapper_<ics:getvar name="viewId" />' class='loadingWrapper mobility'>
				<div class='loadingContent'>
					<div class="loadingImage">
						<xlat:lookup key="dvin/UI/Loadingdotdotdot" varname="loadingtext"/>
						<img src="js/fw/images/ui/wem/loadingBlack.gif" alt='<%=ics.GetVar("loadingtext")%>' height="32" width="32" /><br />
						<ics:getvar name="loadingtext"/>
					</div>
				</div>
			</div>
			<div>
				<div class="headerContainer">
					<div class="deviceInfoContainer">
						<div class="title"><xlat:stream key="UI/MobilitySolution/UC1/MultiDevicePreview" /></div>
						<div class="deviceGroupInfo"><%=deviceGroupName + " (" + listDeviceImages.size() + ")" %></div>
					</div>
					<div class="deviceGroups">
						<span class="title"><strong><xlat:stream key="dvin/AdminForms/DeviceGroups" />:</strong></span>
						<SELECT data-dojo-type="dijit.form.Select">
							<%
								for (int i = 0; i < deviceGroupList.size(); i++) {
									if (!String.valueOf(deviceGroupList.get(i).getId()).equals(request.getAttribute("devicegroup").toString())) {
										%>
											<asset:list type="Device" list="_deviceImagesList" >
												<asset:argument name="ownerid" value="<%=String.valueOf(deviceGroupList.get(i).getId()) %>" />
											</asset:list>
											<ics:if condition='<%=null != ics.GetList("_deviceImagesList") && ics.GetList("_deviceImagesList").hasData()%>'>
											<ics:then>
												<OPTION value='{
													"deviceGroupId": "<%=deviceGroupList.get(i).getId() %>",
													"deviceGroupName": "<%=deviceGroupList.get(i).getName() %>",
													"deviceGroupDescription": "<%=MobilityUtils.encodeCharAsHTML(deviceGroupList.get(i).getDescription().replaceAll("\"", "\\\\\"")) %>",
													"deviceGroupSuffix": "<%=deviceGroupList.get(i).getDeviceGroupSuffix() %>"
												}'><%= deviceGroupList.get(i).getName()%></OPTION>
											</ics:then>
											<ics:else>
												<OPTION disabled="disabled"><%= deviceGroupList.get(i).getName()%></OPTION>
											</ics:else>
											</ics:if>
										<%
									}
									else {
										%><OPTION value='<%= deviceGroupList.get(i).getId()%>' selected="selected"><%= deviceGroupList.get(i).getName()%></OPTION><%
									}
								}
							%>
							<script type="dojo/connect" event="onChange">
										this.value && SitesApp.event("active", "change-devicegroup", JSON.parse(this.value));
									</script>	
						</SELECT>
					</div>
				</div>
				<div class="deviceBase"></div>
				<div class="devicesContainer">
					<%
						float _maxDeviceHeight = 0; 
						float[][] translateX = new float[listDeviceImages.size()][2];
						int _offset = 0, _padding = 70;
						int tabHeight = Integer.parseInt(ics.GetVar("tabHeight"));
						int tabWidth = Integer.parseInt(ics.GetVar("tabWidth")) + 1000;
						final int _INITIAL_PADDING = 70, _DIV_WIDTH = 200;
						int _MAX_DEVICE_HEIGHT = tabHeight - 260;_MAX_DEVICE_HEIGHT = _MAX_DEVICE_HEIGHT - (int)((0.1)*(float)(_MAX_DEVICE_HEIGHT));
						for (int i = 0; i < listDeviceImages.size(); i++)
						{
							DeviceImageBean deviceImageBean = (DeviceImageBean) listDeviceImages.get(i); 
							if (deviceImageBean.getPhysicalDimensions().getDeviceHeight() > _maxDeviceHeight)
								_maxDeviceHeight = deviceImageBean.getPhysicalDimensions().getDeviceHeight();
						}

						for (int i = 0; i < listDeviceImages.size(); i++)
						{
							DeviceImageBean deviceImageBean = (DeviceImageBean) listDeviceImages.get(i);
							translateX[i][0] = _padding;
							float scale = (deviceImageBean.getPhysicalDimensions().getDeviceHeight() * _MAX_DEVICE_HEIGHT / _maxDeviceHeight) / (float) deviceImageBean.getPixelDimensions().getDeviceHeight();
							if (MobilityUtils.DESKTOP_DEVICEIMAGE_NAME.equals(deviceImageBean.getDeviceImageInfo().getDeviceImageName()))
								scale = (float) _MAX_DEVICE_HEIGHT / (float) deviceImageBean.getPixelDimensions().getDeviceHeight();
							%>
								<div data-dojo-type="fw.ui.dijit.insite.DevicePreview" id='deviceImage_<ics:getvar name="viewId" />_<%=i %>'
									data-dojo-props='"deviceImage": {
										deviceGroupInfo: {"deviceGroupId": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupId() %>", "deviceGroupName": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupName() %>", "deviceGroupDescription": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceGroupInfo().getDeviceGroupDescription().replaceAll("\"", "\\\\\"")) %>", "deviceGroupSuffix": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupSuffix() %>"},
										deviceImageInfo: {"deviceImageId": "<%= deviceImageBean.getDeviceImageInfo().getDeviceImageId() %>", "deviceImageName": "<%= deviceImageBean.getDeviceImageInfo().getDeviceImageName() %>", "manufacturer": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceImageInfo().getManufacturer().replaceAll("\"", "\\\\\"")) %>", "deviceImageDescription": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceImageInfo().getDeviceImageDescription().replaceAll("\"", "\\\\\"")) %>", "portraitImageUrl": "<%= deviceImageBean.getDeviceImageInfo().getUrlPortraitImage() %>", "pixelRatio": "<%= deviceImageBean.getDeviceImageInfo().getPixelRatio() %>"},
										pixelDimensions: {"deviceWidth": "<%= deviceImageBean.getPixelDimensions().getDeviceWidth() %>", "deviceHeight": "<%= deviceImageBean.getPixelDimensions().getDeviceHeight() %>", "screenWidth": "<%= deviceImageBean.getPixelDimensions().getScreenWidth() %>", screenHeight: "<%= deviceImageBean.getPixelDimensions().getScreenHeight() %>", "topOffset": "<%= deviceImageBean.getPixelDimensions().getTopOffset() %>", "leftOffset": "<%= deviceImageBean.getPixelDimensions().getLeftOffset() %>"},
										physicalDimensions: {"deviceWidth": "<%= deviceImageBean.getPhysicalDimensions().getDeviceWidth() %>", "deviceHeight": "<%= deviceImageBean.getPhysicalDimensions().getDeviceHeight() %>", "screenWidth": "<%=deviceImageBean.getPhysicalDimensions().getScreenWidth() %>", screenHeight: "<%=deviceImageBean.getPhysicalDimensions().getScreenHeight() %>"},
									},
									"scale": "<%= scale%>", 
									"viewId": "<%= ics.GetVar("viewId")%>",
									"device": <%= MobilityUtils.encodeCharAsHTML(new ObjectMapper().writeValueAsString(deviceImageBean)) %>'>
								</div>
								<style>
									.dj_ie8 #viewContainer_<ics:getvar name="viewId" /> .insiteArea .devicesContainer #deviceImage_<ics:getvar name="viewId" />_<%=i %> iframe {
										filter: progid:DXImageTransform.Microsoft.Matrix(M11=<%=scale * deviceImageBean.getDeviceImageInfo().getPixelRatio()%>, M12=0, M21=0, M22=<%=scale * deviceImageBean.getDeviceImageInfo().getPixelRatio()%>, SizingMethod='auto expand');
										margin-left: <%= deviceImageBean.getPixelDimensions().getLeftOffset() * scale%>px!important;
										margin-top: <%= deviceImageBean.getPixelDimensions().getTopOffset() * scale%>px!important;
									}
								</style>
							<%
							if(scale * deviceImageBean.getPixelDimensions().getDeviceWidth() > _DIV_WIDTH)
								_padding = _padding + (int)(scale * (float) deviceImageBean.getPixelDimensions().getDeviceWidth()) + _INITIAL_PADDING;
							else
								_padding = _padding + _DIV_WIDTH + _INITIAL_PADDING;
						}
					%>
				</div>
				<style type="text/css">
				<%
					for (int i = 0; i < listDeviceImages.size(); i++)
					{
						translateX[i][1] = translateX[i][0] + _padding;
						%>
							/*CSS FOR IE 8*/
							.dj_ie8 #viewContainer_<ics:getvar name="viewId" /> .insiteArea .devicesContainer #deviceImage_<ics:getvar name="viewId" />_<%=i %> {
								top: 0px !important;
								margin-left: <%= translateX[i][0]%>px;
							}

							#viewContainer_<ics:getvar name="viewId" /> .insiteArea .devicesContainer #deviceImage_<ics:getvar name="viewId" />_<%=i %> {
								-webkit-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;
								-moz-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;
								-ms-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;
								transform: <%= "translateX(" + translateX[i][0] + "px)"%>;

								-webkit-animation: <ics:getvar name="viewId" />_SlideInDeviceImages_<%= i%> <%= (float)(1 + 0.2 * i) %>s ease-out 1 forwards;
								-moz-animation: <ics:getvar name="viewId" />_SlideInDeviceImages_<%= i%> <%= (float)(1 + 0.2 * i) %>s ease-out 1 forwards;
							}
							@-webkit-keyframes <ics:getvar name="viewId" />_SlideInDeviceImages_<%= i%>
							{
								0%		{-webkit-transform: <%= "translateX(" + tabWidth +"px)"%>;}
								100%   	{-webkit-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;}
							}
							@-webkit-keyframes <ics:getvar name="viewId" />_SlideOutDeviceImages_<%= i%>
							{
								0%   	{-webkit-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;}
								100%	{-webkit-transform: <%= "translateX(-1000px)"%>;}
							}
							@-moz-keyframes <ics:getvar name="viewId" />_SlideInDeviceImages_<%= i%>
							{
								0%		{-moz-transform: <%= "translateX(" + tabWidth + "px)"%>;}
								100%   	{-moz-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;}
							}
							@-moz-keyframes <ics:getvar name="viewId" />_SlideOutDeviceImages_<%= i%>
							{
								0%   	{-moz-transform: <%= "translateX(" + translateX[i][0] + "px)"%>;}
								100%	{-moz-transform: <%= "translateX(-1000px)"%>;}
							}

							#viewContainer_<ics:getvar name="viewId" /> .insiteArea .devicesContainer #deviceImage_<ics:getvar name="viewId" />_<%=i %> .contentPane_<ics:getvar name="viewId" />.mobileScreen {
								-webkit-animation: <ics:getvar name="viewId" />_FadeInDeviceScreen_<%= i%> 2s linear 1 forwards;
								-moz-animation: <ics:getvar name="viewId" />_FadeInDeviceScreen_<%= i%> 2s linear 1 forwards;
							}
							@-webkit-keyframes <ics:getvar name="viewId" />_FadeInDeviceScreen_<%= i%>
							{
								0%		{opacity: 0;}
								80%   	{opacity: 0;}
								100%   	{opacity: 1;}
							}
							@-moz-keyframes <ics:getvar name="viewId" />_FadeInDeviceScreen_<%= i%>
							{
								0%		{opacity: 0;}
								80%   	{opacity: 0;}
								100%   	{opacity: 1;}
							}
						<%
					}
				%>
				</style>
			</div>

		<iframe id='hiddenPane_<ics:getvar name="viewId" />' src="about:blank" frameborder="0" style="top: -10000px"></iframe>
	</div>
</div>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="com.fatwire.ui.util.GenericUtil"%>
<%@ page import="com.fatwire.mobility.beans.SkinInfoBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceImageBean"%>
<%@ page import="javax.imageio.ImageIO, javax.swing.ImageIcon, java.awt.Image, java.net.URL"%>

<cs:ftcs>
<%
ics.SetVar("viewId" ,GenericUtil.cleanString(ics.GetVar("viewId")));
%>
<div id='viewContainer_<ics:getvar name="viewId" />' dojoType='dijit.layout.BorderContainer' style="position:absolute;bottom:0;top:0;left:0;right:0;">
	<xlat:lookup key="UI/UC1/JS/WebView" varname="label"/>
	<controller:callelement elementname='UI/Layout/CenterPane/Toolbar' responsetype='html'>
		<controller:argument name="showRefresh" value="true" />
		<controller:argument name="isWebMode" value="true" />
		<controller:argument name="label" value='<%=ics.GetVar("label")%>' />
	</controller:callelement>
	
	<% 
		DeviceImageBean deviceImageBean = (DeviceImageBean) request.getAttribute("deviceImageBean");
		if(deviceImageBean != null && !MobilityUtils.DESKTOP_DEVICEIMAGE_NAME.equals(deviceImageBean.getDeviceImageInfo().getDeviceImageName()))
		{
			int availableHeight = Integer.parseInt(ics.GetVar("tabHeight")) - 160;
			int scale = availableHeight * 100 / deviceImageBean.getPixelDimensions().getDeviceHeight();
			String scaleRange = null;
			if (availableHeight <= deviceImageBean.getPixelDimensions().getDeviceHeight())
				scaleRange = "{start: " + scale + ", end: 100}";
			else
				scaleRange = "{start: 100, end: 100}";
			%>
			<div dojoType="dijit.layout.ContentPane" region="center" class="insiteArea mobilityInsiteArea">
				<div id='loadingWrapper_<ics:getvar name="viewId" />' class='loadingWrapper mobility'>
					<div class='loadingContent'>
						<div class="loadingImage">
							<xlat:lookup key="dvin/UI/Loadingdotdotdot" varname="loadingtext"/>
							<img src="js/fw/images/ui/wem/loadingBlack.gif" alt='<%=ics.GetVar("loadingtext")%>' height="32" width="32" /><br />
							<ics:getvar name="loadingtext"/>
						</div>
					</div>
				</div>
				<style type="text/css">
					#viewContainer_<ics:getvar name="viewId" /> .insiteArea {
						background: url(<%= request.getContextPath() %>/js/fw/images/ui/ui/forms/texture.png);
					}

					#viewContainer_<ics:getvar name="viewId" /> .insiteArea .loadingWrapper {
						background: url(<%= request.getContextPath() %>/js/fw/images/ui/ui/forms/texture.png);
					}
					
					#viewContainer_<ics:getvar name="viewId" /> .insiteArea .imageDiv.imageDivPortrait {
						margin-top: 90px !important;
						-webkit-filter: drop-shadow(10px 10px 10px black);
					}

					#viewContainer_<ics:getvar name="viewId" /> .insiteArea .imageDiv.imageDivLandscape {
						margin-top: 90px !important;
						-webkit-filter: drop-shadow(-10px 10px 10px black);
					}
				</style>
				<div data-dojo-type="fw.ui.dijit.insite.DeviceSkin" 
					id='deviceSkin_<ics:getvar name="viewId" />'
					data-dojo-props='deviceImage: {
										pixelDimensions: {"deviceWidth": "<%= deviceImageBean.getPixelDimensions().getDeviceWidth() %>", "deviceHeight": "<%= deviceImageBean.getPixelDimensions().getDeviceHeight() %>", "screenWidth": "<%= deviceImageBean.getPixelDimensions().getScreenWidth() %>", screenHeight: "<%= deviceImageBean.getPixelDimensions().getScreenHeight() %>", "topOffset": "<%= deviceImageBean.getPixelDimensions().getTopOffset() %>", "leftOffset": "<%= deviceImageBean.getPixelDimensions().getLeftOffset() %>"},
										deviceImageInfo: {"deviceImageId": "<%= deviceImageBean.getDeviceImageInfo().getDeviceImageId() %>", "deviceImageName": "<%= deviceImageBean.getDeviceImageInfo().getDeviceImageName() %>", "deviceImageManufacturer": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceImageInfo().getManufacturer().replaceAll("\"", "\\\\\"")) %>", "deviceImageDescription": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceImageInfo().getDeviceImageDescription().replaceAll("\"", "\\\\\"")) %>", "portraitImageUrl": "<%= deviceImageBean.getDeviceImageInfo().getUrlPortraitImage() %>", "thumbnailImageUrl": "<%= deviceImageBean.getDeviceImageInfo().getUrlThumbnailImage() %>", "defaultOrientation": "<%= deviceImageBean.getDeviceImageInfo().getDefaultOrientation() %>", "pixelRatio": "<%= deviceImageBean.getDeviceImageInfo().getPixelRatio() %>"},
										deviceGroupInfo: {"deviceGroupId": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupId() %>", "deviceGroupName": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupName() %>", "deviceGroupDescription": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceGroupInfo().getDeviceGroupDescription().replaceAll("\"", "\\\\\"")) %>", "deviceGroupSuffix": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupSuffix() %>"},
										deviceImageCapabilities: {"touchScreen": "<%= deviceImageBean.getDeviceImageCapabilities().isTouchScreen() %>", "javascript": "<%= deviceImageBean.getDeviceImageCapabilities().isJavascript() %>", "dualOrientation": "<%= deviceImageBean.getDeviceImageCapabilities().isDualOrientation() %>", "isTablet": "<%= deviceImageBean.getDeviceImageCapabilities().isTablet() %>", "flash": "<%= deviceImageBean.getDeviceImageCapabilities().isFlash() %>"}
									},
									deviceCapabalities: {"isRotationSupported": <%= deviceImageBean.getDeviceImageCapabilities().isDualOrientation() %>},
									asset: {"assetId": "<%=ics.GetVar("c") %>", "assetType": "<%=ics.GetVar("cid") %>" },
									displayStatus: {scale: 0, orientation: "Portrait" },
									scaleRange: <%= scaleRange%>,
									viewInfo: {"viewId": "<%=ics.GetVar("viewId") %>"},
									viewMode: "<%=ics.GetVar("mode") %>"'>
				</div>
			</div>
			<%
			}
			else
			{
			%>
				<div dojoType="dijit.layout.ContentPane" region="center" class="insiteArea">
					<div id='loadingWrapper_<ics:getvar name="viewId" />' class='loadingWrapper'>
						<div class='loadingContent'>
							<xlat:lookup key="dvin/UI/Loadingdotdotdot" varname="loadingtext"/>
							<img src="js/fw/images/ui/wem/loading.gif" alt='<%=ics.GetVar("loadingtext")%>' height="32" width="32" /><br />
							<ics:getvar name="loadingtext"/>
						</div>
					</div>
					<iframe id='contentPane_<ics:getvar name="viewId" />' name='viewFrame' src="about:blank" frameborder="0" ></iframe>
				</div>
				<%
			}
		%>
		
		<div jsId='eligibleDevicesStore_<ics:getvar name="viewId" />' data-dojo-type="dojo.store.Memory" data-dojo-props='data: <%=request.getAttribute("eligibleDevices")%>' >
		</div>
		<iframe id='hiddenPane_<ics:getvar name="viewId" />' src="about:blank" frameborder="0" style="top: -10000px"></iframe>
	</div>
</div>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%>
<%@ page import="java.util.*"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="com.fatwire.mobility.beans.DeviceImageBean"%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>

<cs:ftcs>	
<%
	String viewId = GenericUtil.cleanString(ics.GetVar("viewId"));
%>
<div id='viewContainer_<%= viewId%>' dojoType="dijit.layout.BorderContainer">
	<xlat:lookup key="UI/UC1/Layout/FormView" varname="label"/>
	<controller:callelement elementname='UI/Layout/CenterPane/Toolbar' responsetype='html'>
		<controller:argument name="showRefresh" value="true" />
		<!-- Roll back and show versions screen does not have to show the mode  -->
		<%if(!"hide".equals(ics.GetVar("mode"))) {%>
		<controller:argument name="isFormMode" value="true" />
		<%} %>
		<controller:argument name="label" value='<%=ics.GetVar("label")%>' />
	</controller:callelement>
	<div dojoType="dijit.layout.ContentPane" region="center" class="formArea">
		<div id='loadingWrapper_<%= viewId%>' class='loadingWrapper'>
			<div class='loadingContent'>
				<xlat:lookup key="dvin/UI/Loadingdotdotdot" varname="loadingtext"/>
				<img src="js/fw/images/ui/wem/loading.gif" alt='<%=ics.GetVar("loadingtext")%>' height="32" width="32" /><br />
				<ics:getvar name="loadingtext"/>
			</div>
		</div>
		
		<% 
			List<DeviceImageBean> listDeviceImages = (List<DeviceImageBean>) request.getAttribute("listDeviceImages");
			DeviceImageBean deviceImageBean = (DeviceImageBean) request.getAttribute("deviceImageBean");
			if (null != deviceImageBean) {
			%>
				<input type="hidden" id='deviceImage_<ics:getvar name="viewId" />' value='{
												pixelDimensions: {"deviceWidth": "<%= deviceImageBean.getPixelDimensions().getDeviceWidth() %>", "deviceHeight": "<%= deviceImageBean.getPixelDimensions().getDeviceHeight() %>", "screenWidth": "<%= deviceImageBean.getPixelDimensions().getScreenWidth() %>", screenHeight: "<%= deviceImageBean.getPixelDimensions().getScreenHeight() %>", "topOffset": "<%= deviceImageBean.getPixelDimensions().getTopOffset() %>", "leftOffset": "<%= deviceImageBean.getPixelDimensions().getLeftOffset() %>"},
												deviceImageInfo: {"deviceImageId": "<%= deviceImageBean.getDeviceImageInfo().getDeviceImageId() %>", "deviceImageName": "<%= deviceImageBean.getDeviceImageInfo().getDeviceImageName() %>", "deviceImageManufacturer": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceImageInfo().getManufacturer().replaceAll("\"", "\\\\\"")) %>", "deviceImageDescription": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceImageInfo().getDeviceImageDescription().replaceAll("\"", "\\\\\"")) %>", "portraitImageUrl": "<%= deviceImageBean.getDeviceImageInfo().getUrlPortraitImage() %>", "thumbnailImageUrl": "<%= deviceImageBean.getDeviceImageInfo().getUrlThumbnailImage() %>", "defaultOrientation": "<%= deviceImageBean.getDeviceImageInfo().getDefaultOrientation() %>", "pixelRatio": "<%= deviceImageBean.getDeviceImageInfo().getPixelRatio() %>"},
												deviceGroupInfo: {"deviceGroupId": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupId() %>", "deviceGroupName": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupName() %>", "deviceGroupDescription": "<%= MobilityUtils.encodeCharAsHTML(deviceImageBean.getDeviceGroupInfo().getDeviceGroupDescription().replaceAll("\"", "\\\\\"")) %>", "deviceGroupSuffix": "<%= deviceImageBean.getDeviceGroupInfo().getDeviceGroupSuffix() %>"},
												deviceImageCapabilities: {"touchScreen": "<%= deviceImageBean.getDeviceImageCapabilities().isTouchScreen() %>", "javascript": "<%= deviceImageBean.getDeviceImageCapabilities().isJavascript() %>", "dualOrientation": "<%= deviceImageBean.getDeviceImageCapabilities().isDualOrientation() %>", "isTablet": "<%= deviceImageBean.getDeviceImageCapabilities().isTablet() %>", "flash": "<%= deviceImageBean.getDeviceImageCapabilities().isFlash() %>"}
											}' />
			<% 
			} 
		%>
		<input type="hidden" id='noOfDeviceImages_<ics:getvar name="viewId" />' value='<%=listDeviceImages.size() %>' />
	
		<iframe id='contentPane_<%= viewId%>' src="about:blank"  frameborder="0"></iframe>
	</div>
</div>
</cs:ftcs>
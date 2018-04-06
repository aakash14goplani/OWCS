<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<cs:ftcs>
	<assetset:setasset name="home" type="Page" id='<%=ics.GetVar("cid") %>' />
	<assetset:getattributevalues name="home" attribute="teaserText" listvarname="teasers" typename="PageAttribute" />
	<assetset:getattributevalues name="home" attribute="teaserImages" listvarname="teaserImages" typename="PageAttribute" />
	<%
		IList teaserImages = ics.GetList("teaserImages");
		IList teasers = ics.GetList("teasers");
		for (int i = 1; i <= teaserImages.numRows(); i++) {
			teaserImages.moveTo(i);
			teasers.moveTo(i);
			%>
				<div class="page-detail-home">
					<div class="teaser-image">
						<ics:listget listname="teaserImages" fieldname="value" output="imageId" />
						<insite:calltemplate tname="Detail" c="AVIImage" cid='<%=ics.GetVar("imageId") %>' 
											 assettype="Page" assetid='<%=ics.GetVar("cid") %>' cssstyle="aviHomeDetailImage"
											 field="teaserImages" index="<%= String.valueOf(i) %>" title="Teaser image #1" />
						<ics:removevar name="imageId" />
					</div>
					<div class="description">
						<ics:listget listname="teasers" fieldname="value" output="teaser" />
						<insite:edit field="teaserText" index="<%= String.valueOf(i) %>" variable="teaser" editor="ckeditor"
					 				params="{noValueIndicator: '[ Enter Teaser Text ]', toolbar: 'Home', customConfig: '../avisports/ckeditor/config.js'}" />
					</div>
					<ics:removevar name="teaser" />
				</div>
			<%
		}
	%>
</cs:ftcs>
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
	<%
		IList teasers = ics.GetList("teasers");
		for (int i = 1; i <= teasers.numRows(); i++) {
			teasers.moveTo(i);
			%>
				<div class="post">
					<div class="descr">
						<insite:edit 	column="value" 
										list="teasers" 
										editor="ckeditor"
									 	field="teaserText" 
									 	index="<%= String.valueOf(i) %>"
									 	params="{noValueIndicator: '[ Enter Teaser Text #1 ]', width: '205px', toolbar: 'Home', customConfig: '../avisports/ckeditor/config.js'}" />
					</div>
				</div>
			<%
		}
	%>
</cs:ftcs>
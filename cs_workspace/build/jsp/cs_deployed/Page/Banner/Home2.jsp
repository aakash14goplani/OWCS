<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="home" type="Page" id='<%=ics.GetVar("cid") %>' />
<assetset:getattributevalues name="home" attribute="bannerText" listvarname="bannerText" typename="PageAttribute" />
<assetset:getattributevalues name="home" attribute="banner" listvarname="banner" typename="PageAttribute" />
<ics:listget listname="banner" fieldname="value" output="bannerId" />

<insite:calltemplate tname="Detail" c="AVIImage" cid='<%=ics.GetVar("bannerId") %>' field="banner" 
					 cssstyle="aviHome2Banner" />
<div class="teaser">
	<insite:edit field="bannerText" list="bannerText" column="value"
				 params="{noValueIndicator: '[ Enter Text ]', toolbarStartupExpanded: false, width: '410px', height: '90px', toolbar: 'Home', customConfig: '../avisports/ckeditor/config.js'}"
				 editor="ckeditor" />
</div>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<cs:ftcs>

	<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
		</ics:then>
	</ics:if>

	<ics:callelement element="avisports/getdata">
		<ics:argument name="attributes" value="headline,relatedImage,abstract,author,postDate" /> 
	</ics:callelement>
	
	<render:callelement elementname="avisports/GetLink" scoped="global" />
	<div class="summary">
		<div class="text">
			<a href='<%=ics.GetVar("assetUrl")%>'>
				<insite:edit field="headline" value="${asset.headline}" params="{}"/>
			</a>
		</div>
		<div class="icon"></div>
	</div>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<cs:ftcs>
	<ics:callelement element="avisports/getdata">
		<ics:argument name="attributes" value="headline,relatedImage,abstract,author,postDate" /> 
	</ics:callelement>
	
	<render:callelement elementname="avisports/GetLink" scoped="global" />
	<a href='<%=ics.GetVar("assetUrl")%>'>
		<div class="summary-feature">
			<c:if test="${not empty asset.relatedImage}">
				<render:calltemplate tname="Summary" c="AVIImage" d='<%=ics.GetVar("d")%>' cid="${asset.relatedImage.id}" style="pagelet" args="thumbnail" resolvetemplatefordevice="true" />
		    </c:if>
	   		<h3 class="title">
				<insite:edit field="headline" value="${asset.headline}" />
			</h3>
			<p class="description">
				<insite:edit field="abstract" value='${asset["abstract"]}' />
			</p>
	    </div>
    </a>
</cs:ftcs>
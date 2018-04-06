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
		<div class="summary">
			<c:if test="${not empty asset.relatedImage}">
				<div class="thumbnail" class="<ics:getvar name="thumbnail" />">
					<render:calltemplate tname="Summary" c="AVIImage" d='<%=ics.GetVar("d")%>' cid="${asset.relatedImage.id}" style="pagelet" />
				</div>
			</c:if>
			
			<div class="description">
				<span class="headline">
					<insite:edit field="headline" value="${asset.headline}" params="{width: '220px'}"/>
				</span>
				<br/>
				<span class="author">
					<insite:edit field="author" value="${asset.author}" params="{width: '220px'}"/>
				</span>
			</div>
				
			<fmt:formatDate value="${asset.postDate}" dateStyle="long" type="date" var="formattedDate" />
			<div class="date">${formattedDate}</div>
		</div>
	</a>
</cs:ftcs>
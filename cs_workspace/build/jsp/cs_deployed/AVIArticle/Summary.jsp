<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<ics:callelement element="avisports/getdata">
	<ics:argument name="attributes" value="headline,relatedImage,abstract" /> 
</ics:callelement>

<render:callelement elementname="avisports/AVIArticle/GetLink" scoped="global" />
<c:if test="${not empty asset.relatedImage}">
	<a href='<ics:getvar name="articleUrl" />'>
		<render:calltemplate tname="Summary" c="AVIImage" cid="${asset.relatedImage.id}" style="element" args="thumbnail"/>
	</a>
</c:if>

<div class="descr <ics:getvar name="thumbnail" />">
	<h3><a href='<ics:getvar name="articleUrl" />'><insite:edit field="headline" value="${asset.headline}" params="{width: '220px'}"/></a></h3>
	<insite:edit field="abstract" value='${asset["abstract"]}' params="{width: '220px'}" />
</div>
</cs:ftcs>
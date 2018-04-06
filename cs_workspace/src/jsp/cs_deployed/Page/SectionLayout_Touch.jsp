<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<cs:ftcs><!DOCTYPE html>
	<ics:callelement element="avisports/getdata">
		<ics:argument name="attributes" value="banner,Association-named:contentList1,Association-named:contentList2,titleContent1,titleContent2" />
	</ics:callelement>
	
	<html lang="en">
	<head>
		<render:calltemplate tname="/Head" args="c,cid,d" />
	</head>
	<body id="avisports">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" args="d" />
		</div>
		<div id="section">
			<div id="banner">
				<render:calltemplate tname="Banner/Home2" args="c,cid,d" />
			</div>
			<div id="post-wrap" class='<ics:getvar name="bg-color" />'>
				<div class="post">
					<c:set var="index" value="1" />
					<insite:calltemplate tname="Summary/Feature" c="${asset.contentList1[0].type}" cid='${asset.contentList1[0].id}'
										 field="Association-named:contentList1"
										 title="Main List - Top Story" emptytext="[ Drop Article &#35;${index} ]" 
										 index="1" clegal="AVIArticle" />
				</div>
				<c:forEach var="content" items="${asset.contentList1}" begin="1" varStatus="status">
					<c:set var="index" value="${status.index + 1}" />
					<div class="post">
						<insite:calltemplate tname="Summary/SideBar" c="${content.type}" cid='${content.id}'
											 field="Association-named:contentList1"
											 title="Main List - Content &#35;${index}" emptytext="[ Drop Article &#35;${index} ]"
											 index='${index}' clegal="AVIArticle" />
					</div>
				</c:forEach>
				<insite:ifedit>
					<% // in edit mode, draw up to 4 extra empty slots %>
					<c:forEach begin='${index + 1 }' end="5" varStatus="status">
						<div class="post">
							<insite:calltemplate tname="Summary/SideBar" c="${content.type}" cid='${content.id}'
											 field="Association-named:contentList1"
											 title="Main List - Content &#35;${status.index}" emptytext="[ Drop Article &#35;${status.index} ]"
											 index='${status.index}' clegal="AVIArticle" />
						</div>
					</c:forEach>
				</insite:ifedit>
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer_Touch" />
		</div>
	</body>
	</html>
</cs:ftcs>
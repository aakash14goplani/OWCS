<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs><!DOCTYPE html>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<ics:setvar name="context" value='<%="SectionLayout4:" + ics.GetVar("cid") %>' />
<ics:callelement element="avisports/getdata">
	<ics:argument name="attributes" value="banner,Association-named:contentList1,Association-named:contentList2,titleContent1,titleContent2" />
</ics:callelement>
<c:set var="emptyText" value="Drop Article or YouTube video"/> <% // empty indicator for all slots on this page %>
<c:set var="legalTypes" value="AVIArticle,YouTube" /> <% // legal types for all slots on this page %>
<html lang="en">
<head>
	<render:calltemplate tname="/Head" args="c,cid" style="element" />
</head>
<body class="section">
	<div id="main">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" />
		</div>
		<div id="container">
			<div class="content">
				<insite:calltemplate tname="Detail" c="AVIImage" cid='${asset.banner.id}'
									 field="banner" cssstyle="aviSectionBanner" emptytext="Drop Banner Image" />
			</div>
			<div class="center-column blue">
				<div class="post-wrapper">
					<h2 class="title"><insite:edit field="titleContent1" value="${asset.titleContent1}" params='{noValueIndicator: "[ Enter Headline ]"}'/></h2>
					<c:forEach var="content" items="${asset.contentList1}" varStatus="status">
						<c:set var="index" value="${status.index + 1}" />
						<div class="post-large">
							<insite:calltemplate tname="Summary/Feature" c="${content.type}" cid="${content.id}" 
												 field="Association-named:contentList1" index="${index}"
												 title="Main List - Content &#35;${status.index}"
												 emptytext="${emptyText}" clegal="${legalTypes}" />
						</div>
					</c:forEach>
					<insite:ifedit>
						<% // in edit mode, draw up to 2 empty slots %>
						<c:forEach begin="${index + 1}" end="2" varStatus="status">
							<div class="post-large">
								<insite:calltemplate tname="Summary/Feature"
													 field="Association-named:contentList1" index="${status.index}"
								 					 title="Main List - Content &#35;${status.index}"
								 					 emptytext="${emptyText}" clegal="${legalTypes}" />
							</div>
						</c:forEach>
					</insite:ifedit>
				</div>
				<div class="post-wrapper">
					<h2 class="title"><insite:edit field="titleContent2" value="${asset.titleContent2}" params='{noValueIndicator: "[ Enter Headline ]"}'/></h2>
					<c:forEach var="content" items="${asset.contentList2}">
						<c:set var="index" value="${status.index + 1}" />
						<div class="post-large">
							<insite:calltemplate tname="Summary/Feature" c="${content.type}" cid="${content.id}"
												 field="Association-named:contentList2" index="${index}"
												 title="Secondary List - Content &#35;${index}"
												 emptytext="${emptyText}" clegal="${legalTypes}" />
						</div>
					</c:forEach>
					<insite:ifedit>
						<% // in edit mode, draw up to 5 empty slots %>
						<c:forEach begin="${index + 1}" end="2" varStatus="status">
							<div class="post-large">
								<insite:calltemplate tname="Summary/Feature"
													 field="Association-named:contentList2" index="${status.index}"
													 title="Secondary List - Content &#35;${status.index}"
													 emptytext="${emptyText}" clegal="${legalTypes}" />
							</div>
						</c:forEach>
					</insite:ifedit>
				</div>
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer" />
		</div>
	</div>
</body>
</html>
</cs:ftcs>
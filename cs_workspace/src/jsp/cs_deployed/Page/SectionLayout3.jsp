<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs><!DOCTYPE html>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<ics:setvar name="context" value='<%="SectionLayout3:" + ics.GetVar("cid") %>' />
<ics:callelement element="avisports/getdata">
	<ics:argument name="attributes" value="banner,Association-named:contentList1,Association-named:contentList2,titleContent1,titleContent2" />
</ics:callelement>
<c:set var="emptyText" value="Drop Article or YouTube video"/> <% // empty indicator for slots on this page %>
<c:set var="legalTypes" value="AVIArticle,YouTube" />
<html lang="en">
<head>
	<render:calltemplate tname="/Head" args="c,cid" style="element" />
</head>
<body class="section right-col">
	<div id="main">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" />
		</div>
		<div id="container">
			<div class="content">
				<ics:listget listname="section:banner" fieldname="value" output="bannerId" />
				<insite:calltemplate tname="Detail" c="AVIImage" cid='${asset.banner.id}'
									 emptytext="Drop Banner Image" field="banner" cssstyle="aviSectionBanner" />
			</div>
			<div class="center-column">
				<div class="post-wrapper">
					<h2 class="title"><insite:edit field="titleContent1" value="${asset.titleContent1}" /></h2>
					<div class="main-post">
						<c:set var="index" value="1" />
						<insite:calltemplate tname="Summary/Large" c="${asset.contentList1[0].type}" cid='${asset.contentList1[0].id}'
											 field="Association-named:contentList1"  slotname="SectionLayout3-MainSlot"
											 title="Main List - Top Story" index="1"
											 emptytext="${emptyText}" clegal="${legalTypes}" />
					</div>
					<c:forEach var="content" items="${asset.contentList1}" begin="1" varStatus="status">
						<c:set var="index" value="${status.index + 1}" scope="page" />
						<div class="post">
							<insite:calltemplate tname="Summary" c="${content.type}" cid='${content.id}'
												 field="Association-named:contentList1" slotname="SectionLayout3-MainSlot"
												 title="Main List - Content &#35;${index}"
												 emptytext="${emptyText}" clegal="${legalTypes}"/>
						</div>
					</c:forEach>
					<insite:ifedit>
						<% // in edit mode, draw up to 4 extra slots %>
						<c:forEach begin='${index + 1}' end="5" varStatus="status">
							<div class="post">
								<insite:calltemplate tname="Summary" field="Association-named:contentList1"
													 slotname="SectionLayout3-MainSlot"
													 title="Main List - Content &#35;${status.index}"
													 index="${status.index}"
													 emptytext="${emptyText}" clegal="${legalTypes}" />
							</div>
						</c:forEach>
					</insite:ifedit>
				</div>
				<div class="post-wrapper sidebar">
					<h2 class="title"><insite:edit field="titleContent2" value="${asset.titleContent2 }" params="{noValueIndicator: '[ Enter Headline ]'}" /></h2>
					<div class="post">
						<c:set var="index" value="1" />
						<insite:calltemplate tname="Summary/Highlight" c="${asset.contentList2[0].type}" cid="${asset.contentList2[0].id}"
											 slotname="SectionLayout3-Sidebar" field="Association-named:contentList2"
											 title="SideBar - Content #1" index="1"
											 emptytext="${emptyText}" clegal="${legalTypes}" />
					</div>
					<c:forEach var="content" items="${asset.contentList2}" begin="1" varStatus="status">
						<div class="post">
							<c:set var="index" value="${status.index + 1}" />
							<insite:calltemplate tname="Summary/SideBar" c="${content.type}" cid="${content.id}"
												 slotname="SectionLayout3-Sidebar" field="Association-named:contentList2"
												 title="SideBar - Content &#35;${index}" index="${index}"
												 emptytext="${emptyText}" clegal="${legalTypes}" />
						</div>
					</c:forEach>
					<insite:ifedit>
						<% // in edit mode, draw up to 2 extra slots %>
						<c:forEach begin="${index + 1}" end="3" varStatus="status">
							<div class="post">
								<insite:calltemplate tname="Summary/SideBar" slotname="SectionLayout3-Sidebar" field="Association-named:contentList2"
													 title="SideBar - Content &#35;${status.index}"
													 index='${status.index}'
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
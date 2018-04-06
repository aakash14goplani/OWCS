<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<cs:ftcs>
	<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
		</ics:then>
	</ics:if>
	<ics:callelement element="avisports/getdata">
		<ics:argument name="attributes" value="headline,subheadline,author,body,relatedStories,relatedImage,postDate,category,Group_Category" /> 
	</ics:callelement>
	
	<fmt:formatDate value="${asset.postDate}" dateStyle="long" type="date" var="formattedDate" />
	<div class="article-detail">
		<h4 class="section-title">
			<insite:calltemplate field="Group_Category" tname="Link" 
					c="ArticleCategory" cid='${not empty asset.Group_Category ? asset.Group_Category.id : ""}' 
					emptytext="[ Drop Article Category ]" title="Category"
					cssstyle="aviArticleCategory" />
		</h4>
		
		<div class="article">
			<insite:calltemplate tname="Summary" c="AVIImage" d='<%=ics.GetVar("d")%>' cid="${asset.relatedImage.id}" emptytext="[ Drop Image ]" field="relatedImage" style="pagelet" args="thumbnail" />
	
			<h2 class="headline">
				<insite:edit field="headline" value='${asset.headline}' params="{constraints: {formatLength: 'long'}, noValueIndicator: '[ enter headline ]'}"/>
			</h2>
			
			<h3 class="subheadline">
				<insite:edit field="subheadline" value="${asset.subheadline}" params="{noValueIndicator: '[ enter subheadline ]'}" />
			</h3>
			<div class="author">			  
		  		BY <insite:edit field="author" value='${asset.author}' params="{constraints: {formatLength: 'long'}, noValueIndicator: '[ enter author name ]'}"/>
			</div>
			<br/>
			<div class="body">
				<insite:edit field="body" value="${asset.body}" editor="ckeditor" 
					 params="{noValueIndicator: 'Enter body ', toolbar: 'Article', customConfig: '../avisports/ckeditor/config.js'}"/>			
			</body>
			
			<ics:if condition='<%=ics.GetVar("p") != null%>'>
			<ics:then>	
				<div>
					<div class="innerHeader">
						<h2 class="post-Innertitle">Related Articles</h2>
		            </div>
					<ics:callelement element="avisports/getdata">
						<ics:argument name="attributes" value="banner,content1,content2,titleContent1,titleContent2" />
						<ics:argument name="type" value="Page" />
						<ics:argument name="id" value='<%=ics.GetVar("p")%>' />
					</ics:callelement>
				   
					<ics:removevar name="id" />
					<ics:removevar name="type" />
					<c:forEach var="article" items="${asset.content2}" begin="1" varStatus="status">
						<c:set var="index" value="${status.index + 1}" />							
						<div class="innerArticleDiv">
							<div class="text">								
								<render:calltemplate tname="Link" c="AVIArticle" cid="${article.id}" d='<%=ics.GetVar("d")%>'>
									<render:argument name="p" value='<%=ics.GetVar("p")%>' />
								</render:calltemplate>
							</div>
							<div class="icon"></div>
						</div>
					</c:forEach>
				</div>
			</ics:then>
			</ics:if>
		</div>
	</div>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="home" type="Page" id='<%=ics.GetVar("cid") %>' />
<assetset:getmultiplevalues name="home" prefix="home">
	<assetset:sortlistentry attributetypename="PageAttribute" attributename="banner"/>
	<assetset:sortlistentry attributetypename="PageAttribute" attributename="topArticles"/>
	<assetset:sortlistentry attributetypename="PageAttribute" attributename="bannerTitle"/>
</assetset:getmultiplevalues>
<ics:listget listname="home:banner" fieldname="value" output="bannerId" />

<insite:calltemplate tname="Detail" c="AVIImage" cid='<%=ics.GetVar("bannerId") %>'
					 field="banner" cssstyle="aviHomeBanner" />
<div class="top-stories">
	<ics:listget listname="home:bannerTitle" fieldname="value" output="value"/>
	<string:encode variable="value" varname="value"/>
	<h2><insite:edit field="bannerTitle" variable="value" 
					 params="{noValueIndicator: '[ Enter Headline ]'}" /></h2>
	<ul>
		<ics:ifnotempty list="home:topArticles">
		<ics:then>
			<ics:listloop listname="home:topArticles" maxrows="2">
				<ics:listget listname="home:topArticles" fieldname="value" output="articleId" />
				<ics:listget listname="home:topArticles" fieldname="#curRow" output="index" />
				<li><insite:calltemplate tname="Summary" c="AVIArticle" cid='<%=ics.GetVar("articleId") %>'
										 field="topArticles" index='<%=ics.GetVar("index") %>' 
										 title="Top Article #$(Variables.index)"
										 cssstyle="aviHomeTopStories"/>
		</ics:listloop>
		</ics:then>
		</ics:ifnotempty>
		<% // make sure we have at least 2 empty slots %>
		<insite:ifedit>
			<ics:listget listname="home:topArticles" fieldname="#numRows" output="nbArticles" />
			<ics:setvar name="nbArticles" value='<%=ics.GetVar("nbArticles") != null ? ics.GetVar("nbArticles") : "0" %>' />
			<c:forEach begin='<%=Integer.valueOf(ics.GetVar("nbArticles")) + 1 %>' end="2" varStatus="status">
				<li>
					<insite:calltemplate tname="Summary"
								field="topArticles"
					 			title="Top Story - &#35;${status.index}"
					 			emptytext="[ Drop Article &#35;${status.index} ]"
								index="${status.index}"
								cssstyle="aviHomeTopStories" />
				</li>
			</c:forEach>
		</insite:ifedit>
	</ul>
</div>
</cs:ftcs>

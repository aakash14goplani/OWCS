<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="dimensionset" uri="futuretense_cs/dimensionset.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.StringTokenizer"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<div id="SearchDetailView">
<%-- This page relies on context-based data (session data).  We need to be very
     careful about page caching here, or else we could run into problems with
     the context data.
     
     On Satellite Server, the DetailView template is rendered as a separate 
     pagelet, so that means that there is no cached wrapper around this 
     particular page invocation.  That means our context data is safe.  However,
     while FirstSiteII is designed for use with Satellite Server, users can
     still run it directly through Content Server.  If this were to happen,
     we would run into a page caching problem as soon as we try to access the
     session variables.  
     
     Therefore, as a safety measure for users who are requesting this page
     through Content Server only, we need to forcibly disable caching of this
     page and all parent pages (but not nested pagelets).  This represents
     an acceptable use of the ics:disablecache tag.  Mis-use of this tag can
     lead to catastrophic performance problems.  Any page that was otherwise
     going to be cached until invocation of this tag will be served 
     single-threaded, meaning that it will be a performance bottleneck.  In this
     case, however, the page was never going to be cached anyway, so its use is 
     safe because Satellite Server is being used. --%>
<ics:disablecache recursive="false"/>

<%-- If a keyword is passed then create a keyword list and search against Keyword, Name, SKU and
     ShortDescription. If no keyword is passed then use a blank search state. --%>
<render:lookup key="GlobalDimSet" varname="GlobalDimSet" match=":x"/>
<render:lookup key="ProductType" varname="ProductType" />
<render:lookup key="ProductAttr" varname="ProductAttr" />
<render:lookup key="KeywordAttr" varname="KeywordAttr" match=":x" />
<render:lookup key="ProductNameAttr" varname="ProductNameAttr" match=":x" />
<render:lookup key="ProductShortDescAttr" varname="ProductShortDescAttr" match=":x" />
<render:lookup key="SKUAttr" varname="SKUAttr" match=":x" />
<render:lookup key="SummaryTname" varname="SummaryTname" />

<%-- First, populate the searchstate --%>
<ics:if condition='<%= ics.GetVar("keyword") != null && !ics.GetVar("keyword").equals(ics.GetVar("empty")) %>'>
<ics:then>
	<p class="SearchPhrase">Search results matching keyword(s) '<%=ics.GetVar( "keyword" ) %>'</p>
	<searchstate:create name="Search" op="or"/>
	<listobject:create name="myList" columns="value"/>
	<%
	StringTokenizer st = new StringTokenizer(ics.GetVar("keyword"),",");
	while (st.hasMoreTokens())
	{
		String sKeywords = "%" + st.nextToken() + "%";
		%><listobject:addrow name="myList"><listobject:argument name="value" value='<%= sKeywords %>'/></listobject:addrow><%
	}
	%>
	<listobject:tolist name="myList" listvarname="KeywordList"/>
	<searchstate:addlikeconstraint name="Search" typename='<%=ics.GetVar("ProductAttr")%>' attribute='<%=ics.GetVar("KeywordAttr")%>' list="KeywordList" caseinsensitive="true"/>
	<searchstate:addlikeconstraint name="Search" typename='<%=ics.GetVar("ProductAttr")%>' attribute='<%=ics.GetVar("ProductNameAttr")%>' list="KeywordList" caseinsensitive="true"/>
	<searchstate:addlikeconstraint name="Search" typename='<%=ics.GetVar("ProductAttr")%>' attribute='<%=ics.GetVar("ProductShortDescAttr")%>' list="KeywordList" caseinsensitive="true"/>
	<searchstate:addlikeconstraint name="Search" typename='<%=ics.GetVar("ProductAttr")%>' attribute='<%=ics.GetVar("SKUAttr")%>' list="KeywordList" caseinsensitive="true"/>
</ics:then>
<ics:else>
	<p class="SearchPhrase">Search results matching keyword(s) 'empty'</p>
	<searchstate:create name="Search"/>
</ics:else>
</ics:if>

<%-- Now do the lookup and display the results --%>
<assetset:setsearchedassets name="ProductSet" constraint="Search" assettypes='<%=ics.GetVar("ProductType")%>'/>
<assetset:getassetlist name="ProductSet" listvarname="ProductList"/>

<%-- look up the dimension set and filter the ProductList results --%>
<asset:load name="GlobalDimSet" type="DimensionSet" field="name" value='<%=ics.GetVar("GlobalDimSet")%>' />
<dimensionset:filter name="GlobalDimSet" tofilter="ProductList" list="ProductList">
    <dimensionset:asset assettype="Dimension" assetid='<%=ics.GetVar("locale")%>'/>
</dimensionset:filter>

<%-- Display the filtered results --%>
<ics:if condition='<%= ics.GetList("ProductList") != null && ics.GetList("ProductList").hasData() %>'>
<ics:then>
	<div id="SearchResultsList">
		<ics:listloop listname="ProductList">
			<ics:listget listname="ProductList" fieldname="assettype" output="c"/>
			<ics:listget listname="ProductList" fieldname="assetid" output="cid"/>
			<div class="SearchResult">
				<render:calltemplate tname='<%=ics.GetVar("SummaryTname")%>' args="c,cid,p,locale" context="" />
			</div>
		</ics:listloop>
	</div>
</ics:then>
</ics:if>
</div>
</cs:ftcs>
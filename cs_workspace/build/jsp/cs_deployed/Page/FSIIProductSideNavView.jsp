<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<div id="ProductSideNavView">
<%-- This template is rendered on all product pages.  However,
     it never varies from one product to the next, so instead
     of caching one for each product, this template is uncached,
     and it dispatches all of its requests to a SiteEntry, which
     is cached but without any page critiera of significance.
     
     For this reason, it will always perform exceptionally well.
     The drawback is that when anything on the nav changes, the 
     whole nav bar will need to be flushed and regenerated.  But,
     since it's only one page that needs to be re-built, this is
     not a significant issue.
	 
	 The Search Box, however, is a little different - it needs to
	 construct a proper URL back to the caller, so we need to render
	 it based on c and cid.  It's uncached but lightweight so there
	 is no performance issue. --%>
<div id="SearchBox">
	<%-- The lightweight, standard, search form posts to the wrapper page 
	     which processes the search then renders the appropriate results page. --%>
	<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
	<render:lookup varname="LayoutVar" key="Layout" />
	<render:gettemplateurlparameters outlist="args" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
	<satellite:form method="post" id="SearchForm">
		<fieldset>
		<legend>ContentServer dynamic page generation fields</legend>
		<ics:listloop listname="args">
			<input type="hidden" name="<string:stream list="args" column="name"/>" value="<string:stream list="args" column="value"/>"/>
		</ics:listloop>
		<input id="SearchFormFormToProcessField" type="hidden" name="form-to-process" value="SearchForm"/>
		</fieldset>
	<h4><xlat:stream key="dvin/Common/EnterKeyword"/></h4>
	<fieldset>
	<legend>Search fields</legend>
	<input id="KeywordField" type="text" name="keyword" SIZE="20"/>
	<input id="SearchFormSubmitButton" type="submit" name="submit" value="Search"/>
	</fieldset>	
	</satellite:form>
</div>

<render:lookup varname="SideNavSiteEntry" key="SideNavSiteEntry" match=":x"/>
<render:satellitepage pagename='<%=ics.GetVar("SideNavSiteEntry")%>'>
    <render:argument name="p" value='<%=ics.GetVar("p")%>'/>
    <render:argument name="locale" value='<%=ics.GetVar("locale")%>'/>
    <render:argument name="sitepfx" value='<%=ics.GetVar("sitepfx")%>'/>
    <render:argument name="site" value='<%=ics.GetVar("site")%>'/>
</render:satellitepage>
</div>
</cs:ftcs>
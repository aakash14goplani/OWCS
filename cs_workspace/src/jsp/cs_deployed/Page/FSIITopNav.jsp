<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<%-- The top nav bar / header.  This template's job is to render the top nav
     bar and header for the site.  Its input criteria is c, cid, p.  However,
     the only difference between one version of the top nav and another is 
     simply that the current page is highlighted.  This is a bad reason to re-
     generate another copy of the navbar.  Instead, we will generate client-side
     code in this template that will be used in conjunction with the unchanging
     nav bar code to highlight the current page.  
	 
	 Using the current value of c, define the javascript function that 
     will set the style for the section page to be different.  Note that this 
     function must be executed onLoad! --%>
<render:lookup varname="TopNavJavaScriptVar" key="TopNavJavaScript" match=":x"/>
<render:callelement elementname='<%=ics.GetVar("TopNavJavaScriptVar")%>' >
    <render:argument name="cid" value='<%=ics.GetVar("cid")%>'/>
</render:callelement>

<%-- Now that we've set the style for the layer, we can call the shared site
     plan nav bar.  --%>
<render:lookup varname="TopNavVar" key="TopNav" match=":x"/>
<render:satellitepage pagename='<%=ics.GetVar("TopNavVar")%>'>
	<render:argument name="sitepfx" value='<%=ics.GetVar("sitepfx")%>'/>
	<render:argument name="site" value='<%=ics.GetVar("site")%>'/>
    <render:argument name="locale" value='<%=ics.GetVar("locale")%>'/>
</render:satellitepage>

<%-- Display the locale selection form.  We'll rely on javascript to set the
     input c and cid variables.  Locale, however, we do have to set so that
     any language on the form can be appropriately translated. --%>
<render:lookup varname="LocaleForm" key="LocaleForm" match=":x"/>
<render:satellitepage pagename='<%=ics.GetVar("LocaleForm")%>'>
    <render:argument name="sitepfx" value='<%=ics.GetVar("sitepfx")%>'/>
    <render:argument name="site" value='<%=ics.GetVar("site")%>'/>
    <render:argument name="locale" value='<%=ics.GetVar("locale")%>'/>
</render:satellitepage>
</cs:ftcs>
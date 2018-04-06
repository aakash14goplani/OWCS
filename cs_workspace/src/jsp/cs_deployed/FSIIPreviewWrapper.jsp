<%@ page contentType="text/html; charset=UTF-8" language="java"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if><%
%><ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if><%
%><%--

    This CSElement re-sets the preferred_locale
    session variable to the locale of the incoming asset.

    It is to be used only when selecting the wrapper to use
    by the preview functionality of CS Direct.  Once it has
    been accessed once, all subsequent links will be generated
    through the regular wrapper, which will result in normal
    locale viewing behaviour.

    This wrapper is handy because the regular FSII wrapper will set
    a default locale session variable on every page view if it
    does not exist already, and this makes it difficult for users
    to preview content not in the default locale.

    Because this wrapper in turn calls the regular wrapper, it
    must not emit any whitespace at all prior to the call to the
    regular wrapper, or XML correctness will break.

--%><%
    %><asset:getlocale type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' prefix="incoming_asset_locale" /><%
    %><ics:setssvar name="preferred_locale" value='<%=ics.GetVar("incoming_asset_locale:OBJECTID")%>' /><%
    %><%--

    Now, another handy thing to do here is to set the variable
    "p" if it has not already been set.  It's not normally set
    during preview.  To do this, look up the p value from the
    home page asset.

    The home page asset that is mapped to this CSElement is in
    just one language, so we look up the asset, then we filter
    it to look up the right translation.

    The filter element expects c and cid to be in the environment,
    so we have to save them so they do not get re-set.

    --%><%
    %><ics:if condition='<%=ics.GetVar("p") == null && !"Page".equals(ics.GetVar("c"))%>'><ics:then><%
        %><render:lookup varname="HomePageName" key="HomePage" ttype="CSElement" match=":x"/><%
        %><asset:load name="HomePage" type="Page" field="name" value='<%=ics.GetVar("HomePageName")%>'/><%
        %><ics:setvar name="c.save" value='<%=ics.GetVar("c")%>' /><ics:setvar name="c" value="Page"/><%
        %><ics:setvar name="cid.save" value='<%=ics.GetVar("cid")%>' /><asset:get name="HomePage" field="id" output="cid"/><%
        %><render:lookup varname="Filter" key="Filter" match=":x" ttype="CSElement" /><%
        %><render:callelement elementname='<%=ics.GetVar("Filter")%>' scoped="global"/><%
        %><ics:setvar name="p" value='<%=ics.GetVar("cid")%>' /><%
        %><ics:setvar name="c" value='<%=ics.GetVar("c.save")%>'/><ics:removevar name="c.save"/><%
        %><ics:setvar name="cid" value='<%=ics.GetVar("cid.save")%>' /><ics:removevar name="cid.save"/><%
    %></ics:then></ics:if><%
    %><%--

    Finally, call the regular wrapper page element with global
    scoping to allow all variables to pass through.  Note that
    we are bypassing the wrapper's site entry.  There is no
    benefit in going through it, and by skipping it we avoid
    an unnecessary round-trip from SS to CS (though, if the
    user is previewing  using co-resident SS, this benefit
    is probably negligible).

    --%><%
    %><render:lookup varname="wrappervar" key="Wrapper" match=":x" ttype="CSElement" /><%
    %><render:callelement elementname='<%=ics.GetVar("wrappervar")%>' scoped="global"/><%
    %></cs:ftcs>

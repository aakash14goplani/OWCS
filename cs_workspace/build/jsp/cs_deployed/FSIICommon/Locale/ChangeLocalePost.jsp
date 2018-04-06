<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
        %><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
        %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
        %><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
        %><%@ taglib prefix="dimensionset" uri="futuretense_cs/dimensionset.tld"
        %><cs:ftcs><%-- Record dependencies for the SiteEntry and the CSElement --%>
    <ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
    <ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

    <%-- The user wants to change the locale... so change it in the session
         based on the incoming parameter. --%>
    <%-- [KGF 2008-08-xx] Now that the locale drop-down uses gettemplateurl
         and is no longer a form, need to unpack the selected locale from packedargs. --%>

    <render:unpackarg packed='<%=ics.GetVar("packedargs")%>'
            unpack="preferred_locale" outvar="packedargs" remove="true"/>
    <ics:if condition='<%=ics.GetVar("preferred_locale").equals(ics.GetSSVar("preferred_locale"))%>'>
        <ics:then>
            <%-- Nothing to do here at all - the user is trying to switch
                 to the locale that he's alredy using... --%>
        </ics:then>
        <ics:else>

            <%-- First step - set the user's locale into his session for all
                 subsequent requests --%>
            <ics:setssvar name="preferred_locale" value='<%=ics.GetVar("preferred_locale")%>'/>

            <%-- Then, look up the translation of the Home page that corresponds to
                 the new locale so the user lands on the right page.

                 If we wanted the user to land elsewhere (like for example, the
                 originating page, only in another language) we could handle that
                 here.  However, because this specific site may not have all of its
                 assets translated into all locales, we don't want to take the
                 visitor to page that might end up appearing blank!

                 One way around this is to do what we're doing below - force
                 the user to be redirected directly to the home page, which
                 must be translated in all locales.  ("Must" here is a business
                 rule, not really a programmatically enforced requirement.
                 However common sense dictates that a localized site without
                 a home page is not very user-friendly!)

                 The other way would be to replace the DimensionFilter class
                 used in the site's DimensionSet with one that is smart enough to
                 always return an asset from the filter, even if it's not in
                 the visitor's chosen locale.  This type of Dimension Filter is
                 called a fallback dimension filter.  If we used this filter, then
                 this element wouldn't have to do anything more, because the
                 fallback filter would always return an asset when it is invoked.

                 For this sample site, we chose to go with the home page redirect
                 strategy for its simplicity.  Using a fallback filter
                 can result in somewhat un-intuitive behaviour for both the visitor
                 and a developer trying to figure out what's going on (while
                 the developer could be enlightened by turning on asset debugging,
                 the visitor doesn't have this advantage).  Besides, the fallback
                 filter can't perform as well as a lookup or simple filter due
                 to the extra lookups required.

                 So, we let's get started.  Look up the home page, find its translation,
                 and re-set c, p, and cid to point to it.
                 --%>
            <render:lookup ttype="CSElement" key="HomePage" varname="HomePageName" match=":x"/>
            <asset:load name="HomePage" type="Page" field="name" value='<%=ics.GetVar("HomePageName")%>'/>
            <asset:getrelatives name="HomePage" list="relatives" />
            <ics:setvar name="c" value="Page"/>
            <ics:listget listname="relatives" fieldname="OBJECTID" output="cid" />
            <ics:setvar name="p" value='<%=ics.GetVar("cid")%>'/>
        </ics:else>
    </ics:if>
</cs:ftcs>

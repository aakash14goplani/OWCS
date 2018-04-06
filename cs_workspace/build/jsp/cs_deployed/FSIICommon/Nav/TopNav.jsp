<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<%-- This SiteEntry/CSElement combination display the unchanging components
     of the site plan nav bar.  They are fully cacheable and can be re-used
     among all pages in this language in this site.
     
     First, though we must display the site name --%>
<div id="SiteName"><h5><string:stream variable="site"/></h5></div>

<%-- Now, as we have mapped the home page asset to this CSElement, we can
     load the siteplantree for this node.
     --%>
<render:lookup varname="HomePageName" key="HomePage" ttype="CSElement" match=":x"/>
<asset:load name="home.page.in.primary.locale" type="Page" field="name" value='<%=ics.GetVar("HomePageName")%>'/>
<ics:setvar name="c" value="Page"/>
<asset:get name="home.page.in.primary.locale" field="id" output="cid"/>
<%-- Next, execute the Dimension filter to look up the translated version of the
     home page asset that is attached to this element. --%>
<render:lookup varname="FilterElement" key="FilterElement" match=":x" ttype="CSElement" />
<render:callelement elementname='<%=ics.GetVar("FilterElement")%>' scoped="global"/>
<%-- Now that we've filtered the home page asset, we have to re-load it so that
     we can look up the site plan node for the TRANSLATED asset, instead of the
     home page asset in the original language.
     --%>
<ics:if condition='<%=ics.GetVar("cid") == null%>'>
    <ics:then>
        <%-- Oops! Somebody forgot to translate the home page!! --%>
        <ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="error" msg='<%="A translation of the home page asset for site "+ics.GetVar("site") +" in locale "+ics.GetVar("locale")+" was not found!"%>'/>
    </ics:then>
    <ics:else>
        <asset:load name="HomePage" type="Page" objectid='<%=ics.GetVar("cid")%>' />

        <render:lookup varname="LinkVar" key="Link" ttype="CSElement" />
        <%-- Render the link to it.  Note that we don't need to cache individual home
             page links here, we just cache the whole nav bar instead.  So we set the
             style to "element" --%>
        <div id="PageList"><div id="PageListNested"><div id="PageListUtil">
        <ul>
        <li><render:calltemplate tname='<%=ics.GetVar("LinkVar")%>' args="c,cid,p,locale"
        						 context="" ttype="CSElement">
                <render:argument name="a-id-prefix" value='TopNav'/>
            </render:calltemplate></li>
        <%-- Get the sitenode object so we can load the home page's children --%>
        <asset:getsitenode name="HomePage" output='HomePageNodeId' />

        <%-- load the site plan into memory --%>
        <siteplan:load name='HomeNode' nodeid='<%=ics.GetVar( "HomePageNodeId" )%>' />
        <%-- list all the key first level pages, then loop over them--%>
        <siteplan:listpages name='HomeNode' placedlist='SectionPageList' level='1' />
        <ics:if condition='<%=ics.GetList("SectionPageList") != null%>'>
            <ics:then>
                <%-- Unfortunately, if the node has no kids, no list is set so we
                     have to explicitly check for children --%>
                <ics:listloop listname='SectionPageList'>
                    <ics:listget listname='SectionPageList' fieldname='Id' output='SectionPageId' />
                    <%-- Render the link to it.  Note that we don't need to cache individual home
                         page links here, we just cache the whole nav bar instead.  So we set the
                         style to "element" --%>
                    <li><render:calltemplate tname='<%=ics.GetVar("LinkVar")%>' c="Page" cid='<%=ics.GetVar("SectionPageId")%>'
                            args="p,locale" ttype="CSElement" context="">
                        <render:argument name="a-id-prefix" value='TopNav'/>
                    </render:calltemplate></li>
					<render:logdep cid='<%=ics.GetVar("SectionPageId")%>' c="Page"/>
                </ics:listloop>
            </ics:then>
        </ics:if>
        </ul>
        </div></div></div><%-- PageList divs --%>
    </ics:else>
</ics:if>
</cs:ftcs>

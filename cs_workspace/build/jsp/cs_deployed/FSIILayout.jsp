<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="java.util.*,java.text.*"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%>
<cs:ftcs><%-- This is the page responsible for determining the layout of the
                site.  It must support xhtml 1.0, as well as fully comply
                with css rules.
                
                The first thing any template needs to do is record itself as
                a compositional dependency on the rendered page.  This helps
                the cache management module remove this page from cache when 
                the template asset is saved... --%>

<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>

<%-- Execute the Dimension filter to look up the translated asset that
     corresponds to the locale that the visitor requested. --%>
<render:lookup varname="Filter" key="Filter" match=":x" />
<render:callelement elementname='<%=ics.GetVar("Filter")%>' scoped="global"/>

<%-- Now begin with the opening tag... --%>
<head>
<%-- Display head content that is constant across all pages.  

 First, display the stylesheet.  The web element folder
 is named based on the site.  These style sheets are 
 designed to be rendered by all media types, however
 it would be trivial to use medium-specific styles by
 invoking a different stylesheet based on a parameter
 passed to the layout by the wrapper.  Of course it would
 have to be described as a page criteria parameter... --%>
 
<%
	if (ics.LoadProperty("futuretense.ini;futuretense_xcel.ini"))
    {
		/*
			Disable caching if site preview is enabled. This disabling is required at the layout template
			because, if the layout gets cached, subsequent requests for child pages will not be executed.
			The cached layout page will always be returned.
		*/
		if(ics.GetProperty("cs.sitepreview").equals(ftMessage.cm))
		{
			ics.DisableFragmentCache();
		}
		
		/*
			If a date value is available at this point, set it in the session so that it is available for 
			subsequent requests. For eg. when the user previews an October version of the site, 
			we need to preserve the date when he navigates to the Products, Shopping cart or other
			sections of the site. This date value is required for properly loading the appropriate style sheets 
			that are required for rendering the page.
		*/
		if(ics.GetVar("__insiteDate")!= null)			
			ics.SetSSVar("__insiteDate",ics.GetVar("__insiteDate"));
		// TODO - clean up millisec mess...
		//String currentInsiteDate = ics.GetSSVar( "__insiteDate" );
		//if (!currentInsiteDate.endsWith(".000"))
		//	ics.SetSSVar("__insiteDate", currentInsiteDate+".000");
%>
		<render:lookup varname="StyleSheetTemplate" key="StyleSheetResolver" />			
		<render:lookup varname="RecoAssetId" key="StyleSheetReco" match=":x"/>
		<render:lookup varname="RecoAssetType" key="StyleSheetReco" match="x:"/>
		<render:calltemplate tname='<%=ics.GetVar("StyleSheetTemplate")%>' c='<%=ics.GetVar("RecoAssetType")%>' cid='<%=ics.GetVar("RecoAssetId")%>'
								args="p,locale" context="" style="element" />
<%
	}
%>
<%-- Display head content that is asset-specific --%>
	<render:lookup varname="HeadVar" key="Head" />
	<render:calltemplate context="" tname='<%=ics.GetVar("HeadVar")%>' args="c,cid,p,locale" />
</head>
<body>
<div id="Container">
<%-- First comes the top nav.  This template is for a Page asset and it only
 needs to know the page id of the page being rendered.  The top nav is a 
 global nav bar, so there are not many different variations of it.  In fact,
 the only thing that varies from page to page for the top nav is which 
 entry is actually highlighted, to indicate what page the user is on.
 This template should be smart enough to be able to scale well, so that it
 does not result in excessive page generation.  In particular, it probably
 makes sense to have just one version of the pagelet cached, while using
 a client-side tool like DHTML to highlightthe current page. --%>
	<div id="HeaderContainer">
		<div id="TopNav1">
			<div id="TopNav2">
				<render:lookup varname="TopNavVar" key="TopNav" />
				<render:calltemplate tname='<%=ics.GetVar("TopNavVar")%>' c='Page' cid='<%=ics.GetVar("p")%>'
									 args="locale" context="" style="embedded" />
			</div>
		</div>
	</div>

	<div id="HomePageBanner">
		<render:lookup varname="BannerListId" key="BannerList" match=":x"/>
		<render:lookup varname="BannerListType" key="BannerList" match="x:"/>
		<render:lookup varname="BannerTemplateName" key="BannerTemplate" />		
		<render:calltemplate tname='<%=ics.GetVar("BannerTemplateName")%>' c='<%=ics.GetVar("BannerListType")%>' cid='<%=ics.GetVar("BannerListId")%>'
							 args="p,locale" context="" style="element" />
	</div>		

<%-- Load the main body.  The main body contains a section-specific part
 as well as an asset-specific part.  --%>
	<div id="BodyContainer">
<%-- The section nav displays section-specific stuff, like product categories
 for product pages, recommendations for generic pages, and so-on. --%>
		<div id="SideNavContainer">
			<div id="SideNav1">
				<div id="SideNav2">
					<render:lookup varname="SideNavVar" key="SideNav" />
                    <render:calltemplate tname='<%=ics.GetVar("SideNavVar")%>' args="c,cid,p,locale" 
                    					 style='element' context="" />
				</div>
			</div>
		</div>
		<div id="MainBodyContainer">
			<div id="MainBody1">
				<div id="MainBody2">
					<%-- The Page asset's templates, in this framework, 
						 dispatch to cached views.  For performance then,
						 we call the Detail template as an element instead
						 of as a pagelet. (this reduces a round-trip between
						 Satellite Server and Content Server). --%>
					<render:lookup varname="DetailVar" key="Detail" />
					<%-- Relay the form to render through to the body page, in case it's required --%>
					<render:calltemplate tname='<%=ics.GetVar("DetailVar")%>' args="c,cid,p,locale,form-to-render" style='<%="Page".equals(ics.GetVar("c")) ? "element" : null%>' />
				</div>
			</div>
		</div>
	</div>
<%-- Finally, the footer nav bar --%>
	<div id="FooterContainer">
		<div id="BottomNavContainer">
			<div id="BottomNav1">
				<div id="BottomNav2">
					<render:lookup varname="BottomNavVar" key="BottomNav" />
					<render:calltemplate tname='<%=ics.GetVar("BottomNavVar")%>' c='Page' cid='<%=ics.GetVar("p")%>' 
										context="" style="embedded" args="locale" />
				</div>
			</div>
		</div>
<%-- for good measure, verify xhtml/css validity --%>
		<div id="ValidityCheckerContainer">
			<div id="ValidityChecker1">
				<div id="ValidityChecker2">
					Validate: <a href="http://validator.w3.org/check/referer" title="Check the validity of this site&#8217;s XHTML">xhtml</a> &nbsp; <a href="http://jigsaw.w3.org/css-validator/check/referer" title="Check the validity of this site&#8217;s CSS">css</a> 
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</cs:ftcs>

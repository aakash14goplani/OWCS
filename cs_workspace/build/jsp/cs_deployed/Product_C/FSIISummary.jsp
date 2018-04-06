<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%>
<%-- The cs:ftcs tag creates an ICS object which provides access to Content
     Server functionality.  The tag also buffers output for caching.  It is
     required in all Content Server JSPs. --%>
<cs:ftcs>
<div class="ProductSummary">
<%-- The template that contains this JSP file needs to record itself as existing
     on this pagelet when the pagelet is rendered.  The render:logdep tag exists
     for this purpose.  
     
     Dependency tracking is done so that cached pages can be identified as
     invalid when content on them changes.  Upon publish of a given asset, all
     pages that have been rendered that use the given asset will be flushed and
     then subsequently regenerated.  --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<%-- Several variables are passed into every template.  There is usually a 
     variable "c" which is the asset type of the asset being rendered.  "cid" is
     the id of the asset being rendered.  "site" is the name of the current site
     and "sitepfx" is a short prefix name for the given site.
     
     All of these variables are required to render assets. 
     
     First, create an asset set that contains only the single asset we want to
     render. --%>
<assetset:setasset name="ProductSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />
<%-- Now that we've created a set (of one asset in this case) that we want to 
     render, we can now retrieve the attributes belonging to that set.
     
     All attributes can be retrieved using assetset:getattributevalue(s), but
     if we know in advance that we are going to retrieve more than one attribute
     then we should instead use the assetset:getmultiplevalues tag, becaue it
     is much more efficient than making multiple calls to 
     assetset:getattributevalue(s).  In particular, there is a lot less database
     access with a single assetset:getmultiplevalues call.
     
     Text and blob attributes, however, cannot be retrieved using the 
     assetset:getmultiplevalues tag, and they must be retrieved individually.
     
     Attribute names can change when a site is replicated, so we have to look
     up the actual attribute name in a database table maintained by the 
     template asset.  We assigned an arbitrary key to the name of the attribute
     (that co-incidentally correpsonds to the name of the attribute in the 
     original site).  The render:lookup tag is used to look up asset
     references. 
     
     
     First, look up the attribute type name --%>
<render:lookup key="ProductAttrType" varname="ProductAttrType" />
<%-- Next, look up each of the attributes we're going to render --%>
<render:lookup key="NameAttrName" match=":x" varname="NameAttrName" />
<render:lookup key="ShortDescription" match=":x" varname="ShortDescription" />
<render:lookup key="PriceAttrName" match=":x" varname="PriceAttrName" />
<render:lookup key="ImageAttrName" match=":x" varname="ImageAttrName" />
<%-- Retrieve them. --%>

<assetset:getmultiplevalues name="ProductSet" prefix="product" immediateonly="true" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("NameAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("ShortDescription")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("PriceAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("ImageAttrName")%>'/>
</assetset:getmultiplevalues>

<%-- Now render the content.  
     
     Be sure to check to see if optional fields actually have data specified.
     Required fields must have data and the UI enforces it, so it is not 
     necessary to check.

--%>
<ics:if condition='<%=ics.GetList("product:"+ics.GetVar("ImageAttrName")) != null && ics.GetList("product:"+ics.GetVar("ImageAttrName")).hasData()%>'>
<ics:then>
	<ics:listget listname='<%="product:"+ics.GetVar("ImageAttrName")%>' fieldname="value" output="ImageID"/>
	<render:lookup key="ImageType" varname="ImageType" />
	<render:lookup key="ImageSummary" varname="ImageSummary" />
	<render:calltemplate tname='<%=ics.GetVar("ImageSummary")%>' c='<%=ics.GetVar("ImageType")%>' cid='<%=ics.GetVar("ImageID")%>'
						 context="" args="p,locale" />
</ics:then>
</ics:if>

<%--
     
     We want to render a link to the item.  The headline will serve as the
     link text, so we just need to come up with the URL.
     
     URLs are generated using the render:gettemplateurl tag.  The tag needs
     a variety of parameters but basically it needs to know the layout page
     name and the uncached wrapper's page name, plus information about the asset
     to be rendered by the link. 
     
     An alternative to creating the link inline here would be to call the 
     Link template.  
     
     Tradeoffs to consider:  Using the link template reuses code.  Using an 
     inline link simlifies the control flow. --%>
<render:lookup varname="LayoutVar" key="Layout" />
<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
<%-- This parameter 'recid' is used in Analytics Engage report --%>
<render:gettemplateurl outstr="aUrl" args="c,cid,p,locale,recid" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
<a href='<string:stream variable="aUrl"/>' class="summaryLink"><string:stream list='<%="product:"+ics.GetVar("NameAttrName")%>' column="value" /></a>
<ics:if condition='<%=ics.GetList("product:"+ics.GetVar("ShortDescription")) != null && ics.GetList("product:"+ics.GetVar("ShortDescription")).hasData()%>'>
<ics:then>
	<p class="abstract summaryLink"><string:stream list='<%="product:"+ics.GetVar("ShortDescription")%>' column="value"/></p>
</ics:then>
</ics:if>

<%-- spit out the price and any discounts or promotions... --%>
<ics:if condition='<%=ics.GetList("product:"+ics.GetVar("PriceAttrName")) != null%>'>
<ics:then>
	<ics:listget listname='<%="product:"+ics.GetVar("PriceAttrName")%>' fieldname="value" output="Price"/>
	<div class="ProductPrice">
		<currency:create name="currencyobj"/>
		<currency:getcurrency name="currencyobj" value='<%=ics.GetVar("Price")%>' varname="currencyvalue"/>
		<p>Price Per Unit: $<string:stream variable="currencyvalue"/></p>
	</div>
</ics:then>
</ics:if>
</div><%-- ProductSummary --%>
</cs:ftcs>

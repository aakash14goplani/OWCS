<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%>
<%-- The cs:ftcs tag creates an ICS object which provides access to Content
     Server functionality.  The tag also buffers output for caching.  It is
     required in all Content Server JSPs. --%>
<cs:ftcs>
<div id="ProductDetail">
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
<render:lookup key="LongDescAttrName" varname="LongDescAttrName" match=":x"/>
<assetset:getattributevalues name="ProductSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("LongDescAttrName")%>' listvarname="LongDescription"/>

<%-- Next, look up each of the attributes we're going to render --%>
<render:lookup key="NameAttrName" match=":x" varname="NameAttrName" />
<render:lookup key="ImageAttrName" match=":x" varname="ImageAttrName" />
<render:lookup key="PriceAttrName" match=":x" varname="PriceAttrName" />
<%-- Now get the values from the repository --%>
<assetset:getmultiplevalues name="ProductSet" prefix="product" immediateonly="true" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("NameAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("ImageAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("PriceAttrName")%>'/>
</assetset:getmultiplevalues>

<div id="ProductName">
	<h3><insite:edit field="name" 
					 list='<%="product:"+ics.GetVar("NameAttrName")%>' column="value" /></h3>
</div>
<div id="ProductImage">
	<render:lookup key="ImageType" varname="ImageType" />
	<render:lookup key="ImageDetail" varname="ImageDetail" />
	<insite:calltemplate tname='<%=ics.GetVar("ImageDetail")%>' slotname="ProductImage" clegal='<%=ics.GetVar("ImageType")%>'
						 c='<%=ics.GetVar("ImageType")%>' cid='<%=ics.GetList("product:"+ics.GetVar("ImageAttrName")).getValue("value")%>'
						 parentfield='<%="Attribute_" + ics.GetVar("ImageAttrName")%>'
						 parentid='<%=ics.GetVar("cid")%>' parenttype='<%=ics.GetVar("c")%>'
						 args="p,locale" />
</div>

<div id="ProductLongDescription">
	<insite:edit field='<%=ics.GetVar("LongDescAttrName")%>'
				 list="LongDescription" column="value" editor='ckeditor'/>
</div>

<%-- If the document asset type has been defined (this is done by the document schema) then
     we will render any associated documents --%>
<render:lookup key="DocumentAssetType" varname="DocumentAssetType" />
<ics:if condition='<%=ics.GetVar("DocumentAssetType")!=null%>'>
<ics:then>
	<div id="ProductDocs">
		<render:lookup key="Link" varname="Link" />

		<%-- Info sheet --%>
		<asset:children type='<%=ics.GetVar("c")%>' assetid='<%=ics.GetVar("cid")%>' code="InfoSheet" list="InfoSheetList" />
		<ics:if condition='<%= ics.GetList("InfoSheetList") != null && ics.GetList("InfoSheetList").hasData() %>'>
		<ics:then>
			<div id="ProductInfoSheet">
				<render:calltemplate tname='<%=ics.GetVar("Link")%>' c='<%=ics.GetVar("DocumentAssetType")%>' cid='<%=ics.GetList("InfoSheetList").getValue("oid")%>'
									 context="" args="p,locale" />
			</div>
		</ics:then>
		</ics:if>
		<%-- Spec sheet --%>
		<asset:children type='<%=ics.GetVar("c")%>' assetid='<%=ics.GetVar("cid")%>' code="SpecSheet" list="SpecSheetList" />
		<ics:if condition='<%= ics.GetList("SpecSheetList") != null && ics.GetList("SpecSheetList").hasData() %>'>
		<ics:then>
			<div id="ProductSpecSheet">
				<render:calltemplate tname='<%=ics.GetVar("Link")%>' c='<%=ics.GetVar("DocumentAssetType")%>' cid='<%=ics.GetList("SpecSheetList").getValue("oid")%>'
									 context="" args="p,locale" />
			</div>
		</ics:then>
		</ics:if>
		<%-- Manual --%>
		<asset:children type='<%=ics.GetVar("c")%>' assetid='<%=ics.GetVar("cid")%>' code="Manual" list="ManualList" />
		<ics:if condition='<%= ics.GetList("ManualList") != null && ics.GetList("ManualList").hasData() %>'>
		<ics:then>
			<div id="ProductManual">
				<render:calltemplate tname='<%=ics.GetVar("Link")%>' c='<%=ics.GetVar("DocumentAssetType")%>' cid='<%=ics.GetList("ManualList").getValue("oid")%>'
									 context="" args="p,locale" />
			</div>
		</ics:then>
		</ics:if>
	</div>
</ics:then>
</ics:if>

<%-- spit out the price and any discounts or promotions... --%>
<ics:if condition='<%=ics.GetList("product:"+ics.GetVar("PriceAttrName")) != null && ics.GetList("product:"+ics.GetVar("PriceAttrName")).hasData()%>'>
<ics:then>
	<render:lookup key="AddToCartTName" varname="AddToCartTName" />
	<%-- This template must be uncached so that the price can be calculated based on the user's segment.
		 however we will call it as a pagelet not as an element, in order that its result not be
		 embedded in this pagelet (which is cached). --%>
	<render:calltemplate tname='<%=ics.GetVar("AddToCartTName")%>' args="c,cid,p,locale" context="" />
</ics:then>
</ics:if>
</div><%-- Product Detail --%>
</cs:ftcs>
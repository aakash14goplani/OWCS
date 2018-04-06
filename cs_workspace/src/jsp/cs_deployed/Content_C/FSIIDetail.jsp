<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%>
<%-- The cs:ftcs tag creates an ICS object which provides access to Content
     Server functionality.  The tag also buffers output for caching.  It is
     required in all Content Server JSPs. --%>
<cs:ftcs>
<div id="Content_CDetail">
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
<assetset:setasset name="ArticleSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

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
     --%>

<%-- First, look up the attribute type name --%>
<render:lookup key="ContentAttrType" varname="ContentAttrType" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>

<%-- Next, look up each of the attributes we're going to render --%>
<render:lookup key="HeadlineAttrName" match=":x" varname="HeadlineAttrName" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
<render:lookup key="SubHeadlineAttrName" match=":x" varname="SubHeadlineAttrName" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
<render:lookup key="BylineAttrName" match=":x" varname="BylineAttrName" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>

<%-- Now get the values from the repository --%>
<assetset:getmultiplevalues name="ArticleSet" prefix="art" immediateonly="true" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ContentAttrType")%>' attributename='<%=ics.GetVar("HeadlineAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ContentAttrType")%>' attributename='<%=ics.GetVar("SubHeadlineAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ContentAttrType")%>' attributename='<%=ics.GetVar("BylineAttrName")%>'/>
</assetset:getmultiplevalues>

<%-- Look up the attribute name for the body - it's a text field so we have to retrieve it individually --%>
<render:lookup key="BodyAttrName" match=":x" varname="BodyAttrName" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
<%-- Retrieve it --%>
<assetset:getattributevalues name="ArticleSet" attribute='<%=ics.GetVar("BodyAttrName")%>' listvarname="BodyList" typename='<%=ics.GetVar("ContentAttrType")%>' />

<h3><insite:edit 	field='<%=ics.GetVar("HeadlineAttrName")%>' 
					list='<%="art:"+ics.GetVar("HeadlineAttrName")%>' column="value" mode="text"/></h3>

<ics:if condition='<%=ics.GetList("art:"+ics.GetVar("SubHeadlineAttrName")) != null%>'>
<ics:then>
	<h4><string:stream list='<%="art:"+ics.GetVar("SubHeadlineAttrName")%>' column="value"/></h4>
</ics:then>
</ics:if>

<div class="byline">
	<p>By: <insite:edit field='<%=ics.GetVar("BylineAttrName")%>' 
						list='<%="art:"+ics.GetVar("BylineAttrName")%>' column="value" params="{width:'200px'}" mode="text"/></p>
</div>
<div id="body">
<insite:edit field='<%=ics.GetVar("BodyAttrName")%>' list='BodyList' column="value" editor='ckeditor'/>
</div>
</div>
</cs:ftcs>


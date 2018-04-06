<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%>
<%-- The cs:ftcs tag creates an ICS object which provides access to Content
     Server functionality.  The tag also buffers output for caching.  It is
     required in all Content Server JSPs. --%>
<cs:ftcs>
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
<assetset:setasset name="MediaSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

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
<render:lookup key="MediaAttrType" varname="MediaAttrType" />
<%-- Next, look up each of the attributes we're going to render --%>
<render:lookup key="ImageFileAttrName" match=":x" varname="ImageFileAttrName" />
<render:lookup key="ImageMimeTypeAttrName" match=":x" varname="ImageMimeTypeAttrName" />
<render:lookup key="ImageWidthAttrName" match=":x" varname="ImageWidthAttrName" />
<render:lookup key="ImageHeightAttrName" match=":x" varname="ImageHeightAttrName" />
<render:lookup key="AltTextAttrName" match=":x" varname="AltTextAttrName" />
<%-- Now get the values from the repository --%>
<assetset:getmultiplevalues name="MediaSet" prefix="media" immediateonly="false" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("MediaAttrType")%>' attributename='<%=ics.GetVar("ImageMimeTypeAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("MediaAttrType")%>' attributename='<%=ics.GetVar("ImageWidthAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("MediaAttrType")%>' attributename='<%=ics.GetVar("ImageHeightAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("MediaAttrType")%>' attributename='<%=ics.GetVar("AltTextAttrName")%>'/>
</assetset:getmultiplevalues>
<assetset:getattributevalues name="MediaSet" attribute='<%=ics.GetVar("ImageFileAttrName")%>' listvarname="File" typename='<%=ics.GetVar("MediaAttrType")%>' />

<%-- Now render the content.  
     
     Be sure to check to see if optional fields actually have data specified.
     Required fields must have data and the UI enforces it, so it is not 
     necessary to check --%>
<blobservice:gettablename varname="imgTable"/>
<blobservice:getidcolumn varname="imgCol"/>
<blobservice:geturlcolumn varname="imgUrlCol"/>
<%-- Note that we set cachecontrol to never, which means never expire.  We do not
     want SS to have the blobs time out; the cache will be actively managed by
	 CacheManager.  --%>
<ics:if condition='<%=ics.GetList("File") != null && ics.GetList("File").hasData()%>'>
<ics:then>
	<satellite:blob 
			   blobtable='<%=ics.GetVar("imgTable")%>'
			   blobkey='<%=ics.GetVar("imgCol")%>'
			   blobwhere='<%= ics.GetList("File").getValue("value")%>'
			   blobcol='<%=ics.GetVar("imgUrlCol")%>'
			   csblobid='<%=ics.GetSSVar("csblobid")%>'
			   cachecontrol="never"
			   outstring="imgurl">
		<satellite:argument name='border' value="0"/>
		<ics:if condition='<%=ics.GetList("media"+ics.GetVar("ImageMimeTypeAttrName")) != null%>'><ics:then>
			<satellite:argument name='blobheader' value='<%= ics.GetList("media"+ics.GetVar("ImageMimeTypeAttrName")).getValue("value")%>'/>
		</ics:then></ics:if>
	</satellite:blob>
	<%-- Stream the image tag.  String:stream is used instead of ics:getvar to handle proper escaping for xml-compliance. --%>
	<img src="<string:stream variable="imgurl"/>" class="ImageDetail"
		<%-- Some attributes may not be specified.... add them to the tag if they have been --%>
		<ics:if condition='<%=ics.GetList("media:"+ics.GetVar("ImageWidthAttrName")) != null%>'><ics:then>
			width="<string:stream list='<%="media:"+ics.GetVar("ImageWidthAttrName")%>' column="value"/>"
		</ics:then></ics:if>
		<ics:if condition='<%=ics.GetList("media:"+ics.GetVar("ImageHeightAttrName")) != null%>'><ics:then>
			height="<string:stream list='<%="media:"+ics.GetVar("ImageHeightAttrName")%>' column="value"/>"
		</ics:then></ics:if>
		<ics:if condition='<%=ics.GetList("media:"+ics.GetVar("AltTextAttrName")) != null%>'><ics:then>
			alt="<string:stream list='<%="media:"+ics.GetVar("AltTextAttrName")%>' column="value"/>"
		</ics:then><ics:else>
			<%-- alt is a required attribute - it should be specified --%>
			alt="Content Server Image"
		</ics:else></ics:if>
	/><%-- yes, we finally get to close the img tag! Phew! --%>
</ics:then>
</ics:if>
</cs:ftcs>
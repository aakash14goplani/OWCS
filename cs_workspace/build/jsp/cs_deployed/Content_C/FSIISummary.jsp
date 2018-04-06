<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%>
<%-- The cs:ftcs tag creates an ICS object which provides access to Content
     Server functionality.  The tag also buffers output for caching.  It is
     required in all Content Server JSPs. --%>
<cs:ftcs>
<div class="Content_CSummary">
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
     
     
     First, look up the attribute type name --%>
<render:lookup key="ContentAttrType" varname="ContentAttrType" />
<%-- Next, look up each of the attributes we're going to render --%>
<render:lookup key="HeadlineAttrName" match=":x" varname="HeadlineAttrName" />
<render:lookup key="AbstractAttrName" match=":x" varname="AbstractAttrName" />
<render:lookup key="PostDateAttrName" match=":x" varname="PostDateAttrName" />
<%-- Retrieve them. --%>
<assetset:getmultiplevalues name="ArticleSet" prefix="art" immediateonly="true" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ContentAttrType")%>' attributename='<%=ics.GetVar("HeadlineAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("ContentAttrType")%>' attributename='<%=ics.GetVar("PostDateAttrName")%>'/>
</assetset:getmultiplevalues>
<assetset:getattributevalues name="ArticleSet" attribute='<%=ics.GetVar("AbstractAttrName")%>' listvarname="AbstractList" typename='<%=ics.GetVar("ContentAttrType")%>' />

<listobject:create name="inputListName" columns="assetid,assettype" />
	<listobject:addrow name="inputListName">
		<listobject:argument name="assetid" value='<%=ics.GetVar("cid")%>' />
		<listobject:argument name="assettype" value='<%=ics.GetVar("c")%>' />
	</listobject:addrow>
<listobject:tolist name="inputListName" listvarname="assetInputList" />
<asset:filterassetsbydate inputList="assetInputList" outputList="assetOutputList" date='<%=ics.GetSSVar("__insiteDate")%>' />

<ics:if condition='<%=ics.GetList("assetOutputList")!=null && ics.GetList("assetOutputList").hasData()%>' >
<ics:then>
	<ics:listget listname="assetOutputList" fieldname="assetid" output="cid" />
	<ics:listget listname="assetOutputList" fieldname="assettype" output="c" />
		<%-- Now render the content.  
		     
		     Be sure to check to see if optional fields actually have data specified.
		     Required fields must have data and the UI enforces it, so it is not 
		     necessary to check.
		     
		     We also want to render a link to the item.  The headline will serve as the
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
		<render:gettemplateurl 	outstr="aUrl" args="c,cid,p,recid"
								tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>'  />
		<a href='<string:stream variable="aUrl"/>' class="summaryLink"> <string:stream list='<%="art:"+ics.GetVar("HeadlineAttrName")%>' column="value" /></a>

		<ics:if condition='<%=ics.GetList("art:"+ics.GetVar("PostDateAttrName"))!=null && ics.GetList("art:"+ics.GetVar("PostDateAttrName")).hasData()%>'>
		<ics:then>
		<ics:listget listname='<%="art:"+ics.GetVar("PostDateAttrName")%>' fieldname='value' output="PostDate"/>
		<dateformat:create name="PostDateFormat" datestyle="short" />
		<dateformat:getdate name="PostDateFormat" value='<%=ics.GetVar( "PostDate" ) %>' valuetype="jdbcdate" varname="FormattedPostDate" />
		<span class="postdate">(<string:stream variable="FormattedPostDate"/>)</span></ics:then>
		</ics:if>
		<p class="abstract summaryLink"><string:stream list='AbstractList' column="value" /></p>
		</div>
</ics:then>
</ics:if>		
</cs:ftcs>

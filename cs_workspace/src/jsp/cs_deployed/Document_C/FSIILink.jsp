<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<%-- The document link template is very simple.  All it does is provide
     the title of the document and a link to preview it and a link to 
	 download it. 
	 
	 Neither of these links are rendered through the core 
	 infrastructure so this template looks more like an image template
	 than a link template. 
 --%>
<assetset:setasset name="DocSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

<render:lookup key="DocAttrType" varname="DocAttrType" />
<render:lookup key="NameAttrName" match=":x" varname="NameAttrName" />
<render:lookup key="TitleAttrName" match=":x" varname="TitleAttrName" />
<render:lookup key="HtmlAttrName" match=":x" varname="HtmlAttrName" />
<render:lookup key="DocAttrName" match=":x" varname="DocAttrName" />
<render:lookup key="MimeTypeAttrName" match=":x" varname="MimeTypeAttrName" />
<assetset:getmultiplevalues name="DocSet" prefix="doc" immediateonly="true" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("DocAttrType")%>' attributename='<%=ics.GetVar("NameAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("DocAttrType")%>' attributename='<%=ics.GetVar("TitleAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("DocAttrType")%>' attributename='<%=ics.GetVar("HtmlAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("DocAttrType")%>' attributename='<%=ics.GetVar("DocAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("DocAttrType")%>' attributename='<%=ics.GetVar("MimeTypeAttrName")%>'/>
</assetset:getmultiplevalues>
		  
<%-- These tags are basically stateless and will set variables that help 
     locate binary data --%>
<blobservice:gettablename varname="docTable"/>
<blobservice:getidcolumn varname="docCol"/>

<%-- Look up the filename in this table.  For now, we have to query the 
     MungoBlobs (docTable) table directly.  This is not ideal and there 
	 is probably a cleaner way.  Expect this exact area to change in a 
	 future version.  --%>
<ics:setvar name='<%=ics.GetVar("docCol")%>' value='<%= ics.GetList("doc:"+ics.GetVar("DocAttrName")).getValue("value")%>'/>
<ics:selectto table='<%=ics.GetVar("docTable")%>' what='filevalue' where='<%=ics.GetVar("docCol")%>' limit='1' listname="fileinfo"/>
<ics:listget listname="fileinfo" fieldname="filevalue" output="filename"/>

<render:getbloburl 
	outstr='docurl' field='<%=ics.GetVar("DocAttrName") %>' c='<%=ics.GetVar("c") %>' cid='<%=ics.GetVar("cid") %>'
	blobheader='<%=(ics.GetList("doc:"+ics.GetVar("MimeTypeAttrName")) == null) ? null : ics.GetList("doc:"+ics.GetVar("MimeTypeAttrName")).getValue("value")%>'>
	<render:argument name="blobheadername1" value="Content-Disposition"/>
	<render:argument name="blobheadervalue1" value='<%="inline; filename="+ics.GetVar("filename")%>'/>
	<render:argument name="blobheadername2" value="MDT-Type"/>
	<render:argument name="blobheadervalue2" value="abinary; charset=UTF-8"/>
</render:getbloburl>

<ics:if condition='<%=ics.GetList("doc:"+ics.GetVar("HtmlAttrName"))!=null%>'>
<ics:then>
<render:getbloburl
	outstr='htmlurl' field='<%=ics.GetVar("HtmlAttrName") %>' 
	c='<%=ics.GetVar("c") %>' cid='<%=ics.GetVar("cid") %>'
	blobheader='text/html' />
</ics:then>
</ics:if>
<%-- Ideally we would display the document title, but if it's not available, use the name instead --%>
<ics:if condition='<%=ics.GetList("doc:"+ics.GetVar("TitleAttrName")) != null && ics.GetList("doc:"+ics.GetVar("TitleAttrName")).hasData()%>'>
<ics:then><ics:listget listname='<%="doc:"+ics.GetVar("TitleAttrName")%>' fieldname="value" output="linktext"/></ics:then>
<ics:else><ics:listget listname='<%="doc:"+ics.GetVar("NameAttrName")%>' fieldname="value" output="linktext"/></ics:else>
</ics:if>
<%-- Now finally render the link --%>
<div class="DocumentLink">
	<p class="doctitle"><string:stream variable="linktext"/></p>
	<p class="doclinks">
	<ics:if condition='<%=ics.GetList("doc:"+ics.GetVar("HtmlAttrName"))!=null%>'>
			<ics:then>
		<a href="<string:stream variable="htmlurl"/>">preview</a>
		 - </ics:then></ics:if>
		<span class="docdownloadlink"><a href="<string:stream variable="docurl"/>">download</a></span>
	</p>
</div>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>

<div id="StandardDetailView">
	<%-- load the page, display the title --%>
	<asset:load name="page" type="Page" objectid='<%=ics.GetVar("cid")%>'/>
	<asset:get name="page" field="description" output="description"/>
	<h2><string:stream variable="description"/></h2>
	<%-- now load the contents of the page and display the contents in detail form.
	     Note that we don't know if the contents are articles, images, 
	     recommendations or what.  It may even be nothing.... just render it. --%>
	<asset:children name="page" code="AssociatedItems" list="kids" order="nrank"/>
	<ics:listloop listname='kids'>
		<ics:listget listname='kids' fieldname='otype' output='c' />
		<ics:listget listname='kids' fieldname='oid' output='cid' />
		
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
			<render:lookup site='<%=ics.GetVar("site")%>' varname="DetailVar" key="Detail" tid='<%=ics.GetVar("tid")%>'/>
			<render:calltemplate tname='<%=ics.GetVar("DetailVar")%>' args="c,cid,p,locale" />
		</ics:then>
		</ics:if>
	</ics:listloop>
</div>
</cs:ftcs>
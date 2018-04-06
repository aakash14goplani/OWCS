<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<div id="ProductDetailView">

	<div id="ProductArea">
		<%-- load the page, display the title --%>
		<asset:load name="page" type="Page" objectid='<%=ics.GetVar("cid")%>'/>
		<asset:get name="page" field="description" output="description"/>
		<h2><string:stream variable="description"/></h2>
		<%-- now load the contents of the page and display the contents in detail form.
			 Note that we don't know if the contents are articles, images, 
			 recommendations or what.  It may even be nothing.... just render it. --%>
		<asset:children name="page" code="AssociatedItems" list="kids"/>
		<ics:listloop listname='kids'>
			<ics:listget listname='kids' fieldname='otype' output='c' />
			<ics:listget listname='kids' fieldname='oid' output='cid' />
			<render:lookup varname="DetailVar" key="Detail" />
			<render:calltemplate tname='<%=ics.GetVar("DetailVar")%>' args="c,cid,p,locale" />
		</ics:listloop>
	</div>
	
	<%-- We still need to display the Item of the Week and Advertisement - so just call their container --%>
	<div id="PromoArea">
		<render:lookup varname="StandardSideNavView" key="StandardSideNavView" />
		<render:calltemplate tname='<%=ics.GetVar("StandardSideNavView")%>' c='Page' cid='<%=ics.GetVar("p")%>'
							 args="p,locale" context="" />
	</div>
</div>
</cs:ftcs>
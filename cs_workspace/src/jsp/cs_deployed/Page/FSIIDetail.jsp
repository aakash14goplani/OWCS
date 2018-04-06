<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<%-- Pages with different "subtype" identifiers are viewed in different ways.  
     So this template just dispatches requests to the appropriate view.  We load
     the asset, figure out its subtype, and then dispatch to the corresponding
     view template. --%>
<asset:load name="page" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>
<asset:get name="page" field="subtype"/>
<%-- Call the template.  The Detail template is not cached, so we should cache the 
     view pagelet. --%>
<render:lookup varname="ViewTypeVar" key='<%=ics.GetVar("subtype")+"DetailView"%>' />
<%-- Relay the form to render through to the body page, in case it's required --%>
<render:calltemplate tname='<%=ics.GetVar("ViewTypeVar")%>' args="c,cid,p,locale,form-to-render" />
</cs:ftcs>
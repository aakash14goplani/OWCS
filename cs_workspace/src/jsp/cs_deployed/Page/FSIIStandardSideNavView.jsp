<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ page import="COM.FutureTense.Interfaces.IList"%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<div id="StandardSideNavView">
<%-- This template displays the section-specific nav bar.  It contains the
     "item of the week" recommendation and the "advertisement" recommendation".
     Note:  these recommendations are loaded by name. --%>
<render:lookup varname="FilterElement" key="FilterElement" match=":x" />
<render:lookup varname="DetailVar" key="Detail" />
<ics:setvar name="max" value="1" />
<div id="ItemOfTheWeek">
	<insite:calltemplate tname='<%=ics.GetVar("DetailVar")%>'
						 slotname="StandardNavItemOfTheWeek"
						 title="Standard Nav Item Of The Week"
						 context="Global" clegal="AdvCols" args="p,locale,max" />
</div>
<div id="Advertisement">
    <render:lookup varname="adVar" key="Advertisement" match=":x"/>
    <asset:list list="ad" type="AdvCols" field1="name" value1='<%=ics.GetVar("adVar")%>'/>
    <ics:listloop maxrows="1" listname="ad">
        <ics:listget listname="ad" fieldname="id" output="cid"/>
		<ics:setvar name="c" value="AdvCols"/>
        <render:callelement elementname='<%=ics.GetVar("FilterElement")%>' scoped="global"/>
        <ics:if condition="'<%=ics.GetVar('c')%>' != null && '<%=ics.GetVar('cid')%>' != null">
        	<ics:then>
        		<render:calltemplate cid='<%=ics.GetVar("cid")%>' tname='<%=ics.GetVar("DetailVar")%>' c='<%=ics.GetVar("c")%>' args="p,max" />
        	</ics:then>
        </ics:if>
    </ics:listloop>
</div>
</div>
</cs:ftcs>

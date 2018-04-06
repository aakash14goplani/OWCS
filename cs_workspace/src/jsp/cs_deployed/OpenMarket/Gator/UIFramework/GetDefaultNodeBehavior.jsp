<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs>
	<ics:getproperty name="cs.tree.defaultFunction.child"  file="futuretense_xcel.ini" output="cs_defaultFunctionChild" />
	<ics:getproperty name="cs.tree.defaultFunction.parent" file="futuretense_xcel.ini" output="cs_defaultFunctionParent" />
	
	<ics:ifempty variable="cs_defaultFunctionChild">
	<ics:then>
		<ics:setvar name="cs_defaultFunctionChild" value="inspect" />
	</ics:then>
	</ics:ifempty>
	
	<ics:ifempty variable="cs_defaultFunctionParent">
	<ics:then>
		<ics:setvar name="cs_defaultFunctionParent" value="browse" />
	</ics:then>
	</ics:ifempty>
</cs:ftcs>

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/CustomTextAttributeEditor
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<%

IList attributeValueList = ics.GetList("AttrValueList", false);
boolean hasValues = null != attributeValueList && attributeValueList.hasData();
String attributeValue = hasValues ? attributeValueList.getValue("value") : "";

%>

<ics:if condition='<%= "no".equals(ics.GetVar("MultiValueEntry")) %>'>
<ics:then>
	<div dojoType='<%= ics.GetVar("editorName") %>'
		name='<%= ics.GetVar("cs_SingleInputName") %>'
		value='<%= attributeValue %>'
	>
	</div>		
</ics:then>
<ics:else>
	<ics:callelement element="OpenMarket/Gator/AttributeTypes/RenderMultiValuedTextEditor">
		<ics:argument name="editorName" 	value='<%= ics.GetVar("editorName") %>' />
		<ics:argument name="editorParams" 	value='<%= ics.GetVar("editorParams") %>' />
		<ics:argument name="multiple" 		value="true" />
		<ics:argument name="maximumValues" 	value='<%= ics.GetVar("maximumValues") %>' />
	</ics:callelement> 
</ics:else>
</ics:if>	


<ics:removevar name='editorName' />
<ics:removevar name='editorParams' />
<ics:removevar name='maximumValues' />
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternHelper
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.Map.Entry"%>
<cs:ftcs>
<script>	
	var onFunctionDblClick = function(method){
		var patternTA = dijit.byId("vanityURL"),
			patternStartStub = "<%="${f:"%>",
			patternEndStub = "()}";
		var patternToPaste = patternStartStub + method + patternEndStub;
		var presentValue = patternTA.get("value");
		if (presentValue.lastIndexOf("/") === presentValue.length - 1)
			patternTA.set("value", presentValue + patternToPaste);
		else
			patternTA.set("value", presentValue + "/" + patternToPaste);
	};
</script>
<ics:callelement element="OpenMarket/Xcelerate/Util/GetUrlExpressions"></ics:callelement>
<%
	String queryContentStr = "{\"assetType\":\"" + ics.GetVar("assettype") + "\"}";
%>
<div data-dojo-type="dijit.layout.BorderContainer">
	<div data-dojo-type="dijit.layout.StackContainer" data-dojo-props="region:'center'" id="webRefTabContainer" class="webRefTabContainer">
		
		<div dojoType="dijit.layout.ContentPane">
			<ics:callelement element="OpenMarket/Xcelerate/WebRefPattern/AttributeTable">
				<ics:argument name="storeId" value="contentAttr"/>
				<ics:argument name="gridQuery" value='<%=queryContentStr%>'/>
			</ics:callelement>
		</div>
		
		<div dojoType="dijit.layout.ContentPane" class="webRefFunction">
	<%	
		Map functions = (Map)ics.GetObj("f");
		Method[] methods = functions.get("f").getClass().getDeclaredMethods();
		for (int im = 0; im < methods.length ; im++) 
		{
			if (!methods[im].isSynthetic())
			{
				out.println("<div ondblclick='onFunctionDblClick(\"" + methods[im].getName() + "\")'><strong>" + methods[im].getName() + "</strong></div>");			
				Class[] parameterTypes =  methods[im].getParameterTypes();
				%>
				<xlat:stream key="dvin/AT/Template/Parameters"/><br>
				<%
				for (int paramindex = 0; paramindex < parameterTypes.length ; paramindex++) 
				{
					out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +parameterTypes[paramindex].getName() + "<br>");	
				}
				out.println("<br>");
			}
		}
		ics.SetObj("f", null);
	%>
		</div>
	</div>
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'bottom'" class='tabButtonPane'>
		<div
			data-dojo-type="dijit.form.Button"
			data-dojo-props="
				id: 'tabButton0',
				selected: true,
				onClick: function() {
					makeButtonActive(this, 0);
				}
			"><xlat:stream key='dvin/UI/Admin/Attributes'/></div>
		<div
			data-dojo-type="dijit.form.Button"
			data-dojo-props="
				id: 'tabButton1',
				onClick: function() {
					makeButtonActive(this, 1);
				}
			"><xlat:stream key='UI/Forms/Functions'/></div>
	</div>
</div>


</cs:ftcs>
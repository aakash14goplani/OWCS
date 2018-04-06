<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/TextBox
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
	String 	tfWidth = ics.GetVar("width");
	String	inputMaxlength = ics.GetVar("inputMaxlength");
	String	inputValue = ics.GetVar("inputValue");
	String	inputType = ics.GetVar("inputType");
	if(inputType == null || inputType.trim().length() == 0){
		inputType = "TEXT";
	}
	String	inputName = ics.GetVar("inputName");
	inputName = Utilities.goodString(inputName) ? inputName : "commonFwInputDiv";
	boolean applyDefaultFormStyle = Boolean.parseBoolean(ics.GetVar("applyDefaultFormStyle"));
	if(Utilities.goodString(tfWidth))
		applyDefaultFormStyle = false;
	tfWidth = Utilities.goodString(tfWidth) ? tfWidth : "15em";
	inputMaxlength = Utilities.goodString(inputMaxlength) ? inputMaxlength : "2000";
	inputValue = Utilities.goodString(inputValue) ? inputValue : "";
	ics.RemoveVar("applyDefaultFormStyle");
%>
<div style="display:inline" name='<%= inputName %>_div'></div>
<script>
	dojo.addOnLoad(function(){
		var nodeToReplace = dojo.query("div[name=<%= inputName %>_div]")[0],
			tfWidth = '<%= tfWidth %>',
			inputMaxlength = '<%= inputMaxlength %>',
			inputValue = '<%=   org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(inputValue) %>',
			inputName = '<%= inputName %>',
			inputType = '<%= inputType %>';
			
		var commonFwInputBox = new fw.dijit.UIInput({
			clearButton: true,
			name: inputName,
			value: inputValue,
			type: inputType,
			showErrors: "false"
		});
		dojo.attr(commonFwInputBox.textbox, 'maxlength', inputMaxlength);
		dojo.style(commonFwInputBox.domNode, "width", tfWidth);
		if (<%=String.valueOf(applyDefaultFormStyle)%>) {
			dojo.addClass(commonFwInputBox.domNode, 'defaultFormStyle');
		}
		commonFwInputBox.placeAt(nodeToReplace, 'last');		
		commonFwInputBox.startup();	
	});
</script>
<ics:removevar name="width"/>
<ics:removevar name="inputMaxlength"/>
<ics:removevar name="inputValue"/>
<ics:removevar name="inputName"/>
</cs:ftcs>
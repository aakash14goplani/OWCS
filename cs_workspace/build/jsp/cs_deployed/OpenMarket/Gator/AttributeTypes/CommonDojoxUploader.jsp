<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/CommonDojoxUploader
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
<div style="display:table">
	<div style="display: table-cell" name='<%=ics.GetVar("inputTagName")%>Node_div'></div>
	<div style="display: table-cell; padding:1px 0 0 6px; vertical-align:top">
		<input class="browseButton" name="<%=ics.GetVar("inputTagName")%>" type="file" dojoType="fw.ui.dijit.form.Uploader" label="<xlat:stream  key='UI/Forms/Browse' locale='<%=ics.GetVar("locale")%>' />" id="<%=ics.GetVar("inputTagName")%>_ID" title="<xlat:stream  key='UI/Forms/Browse' locale='<%=ics.GetVar("locale")%>' />"/>
	</div>
</div>
<script>
	dojo.require("fw.ui.dijit.form.Uploader");
	
	dojo.addOnLoad(function(){
		var nodeToReplace = dojo.query("div[name=<%=ics.GetVar("inputTagName")%>Node_div]")[0];
			
		var commonFwInputBox = new fw.dijit.UIInput({
			clearButton: true,
			showErrors: "false",
			disabled: true
		});
		commonFwInputBox.placeAt(nodeToReplace, 'last');	
		if (<%="true".equals(ics.GetVar("defaultFormStyle"))%>) {
			dojo.addClass(commonFwInputBox.domNode, 'defaultFormStyle');
		}
		commonFwInputBox.startup();	
		dojo.connect(commonFwInputBox, "onClearInput", dijit.byId("<%=ics.GetVar("inputTagName")%>_ID"), function(){
			this.reset();
			commonFwInputBox.set('value', "");
		});
		dojo.connect(dijit.byId("<%=ics.GetVar("inputTagName")%>_ID"), "onChange", function(dataArray){
			dojo.forEach(dataArray, function(file){
				commonFwInputBox.set('value', file.name);			
			});
		});
	});
</script>
</cs:ftcs>
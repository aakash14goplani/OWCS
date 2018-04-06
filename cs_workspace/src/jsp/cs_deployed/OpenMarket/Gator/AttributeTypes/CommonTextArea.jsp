<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/CommonTextArea
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
	String 	areaName = ics.GetVar("areaName");
	String	areaRows = ics.GetVar("areaRows");
	String	areaCols = ics.GetVar("areaCols");
	String	areaWrap = ics.GetVar("areaWrap");
	String 	areaDepType = ics.GetVar("areaDepType");
	String	areaWidth = ics.GetVar("areaWidth");
	String	areaValue = ics.GetVar("areaValue");
	String	areaHeight = ics.GetVar("areaHeight");
	String	areaResize = ics.GetVar("areaResize");
	String maxLength = ics.GetVar("maxLength");
	boolean applyDefaultFormStyle = Boolean.parseBoolean(ics.GetVar("applyDefaultFormStyle"));
	areaName = Utilities.goodString(areaName) ? areaName : "commonFwTextAreaDiv";
	areaRows = Utilities.goodString(areaRows) ? areaRows : "2";
	areaCols = Utilities.goodString(areaCols) ? areaCols : "60";
	areaWrap = Utilities.goodString(areaWrap) ? areaWrap : "";
	areaDepType = Utilities.goodString(areaDepType) ? areaDepType : "";
	areaWidth = Utilities.goodString(areaWidth) ? areaWidth : "400px";
	areaWidth = areaWidth.toLowerCase().indexOf("px") == -1 ? areaWidth + "px" : areaWidth ;
	areaValue = Utilities.goodString(areaValue) ? areaValue : "";
	areaHeight = Utilities.goodString(areaHeight) ? areaHeight : "200px";
	areaHeight = areaHeight.toLowerCase().indexOf("px") == -1 ? areaHeight + "px" : areaHeight ;
	areaResize = Utilities.goodString(areaResize) ? areaResize : "none";
	maxLength = Utilities.goodString(maxLength) ? maxLength : "-1";
	ics.RemoveVar("applyDefaultFormStyle");
%>
<div name='<%= areaName %>_div'></div>
<script>
	dojo.addOnLoad(function(){
		var nodeToReplace = dojo.query("div[name=<%= areaName %>_div]")[0],
			areaValue = '<%=  org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(areaValue) %>',
			areaName = '<%= areaName %>',
			maxLength = '<%= maxLength %>';
			
		var commonFwTextArea = new fw.dijit.UITextarea({ 
			name: areaName,
			value: areaValue,
			maxWords: '',
			showErrors: "false"
		});	
		commonFwTextArea.placeAt(nodeToReplace, 'last');
		dojo.style(commonFwTextArea.textbox, {'height': '<%= areaHeight %>', 'width': '<%= areaWidth %>'});
		if (<%=String.valueOf(applyDefaultFormStyle)%>) {
			dojo.addClass(commonFwTextArea.domNode, 'defaultFormStyle');
		}
		dojo.attr(commonFwTextArea.textbox, 'wrap', '<%= areaWrap %>');
		dojo.attr(commonFwTextArea.textbox, 'deptype', '<%= areaDepType %>');			
		dojo.style(commonFwTextArea.textbox, {'resize': '<%=areaResize%>'});
		// This is only for Basic Asset TextArea attribute editor
		// This maxlength is coming from OpenMarket\AssetMaker\BuildEditTextArea		
		if(maxLength !== '-1') {
			dojo.connect(commonFwTextArea, "onChange", function(){
				if (typeof textAreaOC === "function")
					textAreaOC(this, areaName, maxLength, areaName)
			})
		}			
		commonFwTextArea.startup();
	});
</script>
<ics:removevar name="areaName"/>
<ics:removevar name="areaRows"/>
<ics:removevar name="areaCols"/>
<ics:removevar name="areaWrap"/>
<ics:removevar name="areaDepType"/>
<ics:removevar name="areaWidth"/>
<ics:removevar name="areaValue"/>
<ics:removevar name="areaHeight"/>
<ics:removevar name="maxLength"/>
</cs:ftcs>
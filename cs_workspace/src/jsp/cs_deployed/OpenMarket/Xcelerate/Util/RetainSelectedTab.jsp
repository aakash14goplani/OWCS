<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld"%>
<%//
// OpenMarket/Xcelerate/Util/RetainSelectedTab
//
// INPUT
//	- tabContent - This is the title of the default tab to be selected.
//	- elementType - This attribute is being passed to know the type of element calling this element.
//					We might have to write sricpt node differently for XML element.
//					As of now, it is present for future proof.
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
<string:encode varname="_SELECTED_TAB_" variable="_SELECTED_TAB_" />
<script type='dojo/connect' event='startup'>
	var selectedChildCP, tabContainerChildren, selectedCPTitle = '<%= ics.GetVar("_SELECTED_TAB_") %>';
	if ('null' == selectedCPTitle) selectedCPTitle = '<%=ics.GetVar("tabContent")%>'; 

	tabContainerChildren = this.getChildren();
	for (var i = 0; i < tabContainerChildren.length; i++) {
		if (tabContainerChildren[i].title == selectedCPTitle) {
			selectedChildCP = tabContainerChildren[i];
			break;
		} 			
	}
	if (selectedChildCP) this.selectChild(selectedChildCP);
	this.setTabState();
</script>
<script type='dojo/connect' event='selectChild'>
	var hiddenInputSelectedTab = dojo.byId("_SELECTED_TAB_");

	if (!hiddenInputSelectedTab) 
		hiddenInputSelectedTab = dojo.create('input', {
			id: '_SELECTED_TAB_',
			type: 'hidden',
			name: '_SELECTED_TAB_',	
			value: this.selectedChildWidget.title
		}, this.domNode);
	else 
		dojo.attr(hiddenInputSelectedTab, 'value', this.selectedChildWidget.title);
</script>
<script type="dojo/method" event="setTabState">
	var _self = this, isEditOrNewPage = <%= "EditFront".equals(ics.GetVar("ThisPage")) || "NewContentFront".equals(ics.GetVar("ThisPage")) || "CopyFront".equals(ics.GetVar("ThisPage"))  || "TranslateFront".equals(ics.GetVar("ThisPage")) %>,
		isUcForm = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
	if (!isEditOrNewPage) return;
	var connectChangeEvents = function(){
		var tabContainerChildren = _self.getChildren(),
			widgets;
					
		for (var i = 0; i < tabContainerChildren.length; i++) {	
			widgets = dijit.findWidgets(tabContainerChildren[i].domNode);
			dojo.forEach(widgets, function(eachWidget){
				var handleChange = dojo.connect(eachWidget, "onChange", function(){				
					setTabDirty();
					dojo.disconnect(handleChange);
				});
			})
		}			
	};
	if(isUcForm) {
		setTimeout(function(){connectChangeEvents();}, 0);	
	}
</script>	
</cs:ftcs>
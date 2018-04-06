<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/AttributeTable
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<cs:ftcs>
<script>
	var store_<%=ics.GetVar("storeId")%> = new fw.ui.dojox.data.CSQueryReadStore({
		url: 'ContentServer?pagename=OpenMarket/Xcelerate/WebRefPattern/PatternAssist',
		requestMethod: 'post',
		doClientSorting: true
	});
	
	var onGridDblClick = function(event){
		var patternTA = dijit.byId("vanityURL"),
			patternStartStub = "<%="${"%>",
			patternEndStub = "}";
		var patternToPaste = patternStartStub + event.target.innerHTML + patternEndStub;
		var presentValue = patternTA.get("value");
		if (presentValue.lastIndexOf("/") === presentValue.length - 1)
			patternTA.set("value", presentValue + patternToPaste);
		else
			patternTA.set("value", presentValue + "/" + patternToPaste);
	};
</script>
<table 
	id="searchGrid_<%=ics.GetVar("storeId")%>"
	data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
	data-dojo-props='
		store: store_<%=ics.GetVar("storeId")%>,
		noDataMessage: "<span class=gridMessageText><xlat:stream key='UI/UC1/Layout/SearchInfo1' escape='true'/></span>",
		query:<%=ics.GetVar("gridQuery")%>,
		selectionMode: "none",
		errorMessage: "<xlat:stream key='fatwire/SystemTools/logs/ErrorOccurred' escape='true'/>",
		autoHeight: true,
		selectable: true,
		rowsPerPage: 100
	'>
	<script type="dojo/connect" event="onCellDblClick" args="e">
		onGridDblClick(e);
	</script>
	<thead>
		<tr>
			<!--<th field='host' formatter='fw.ui.GridFormatter.nameFormatter' width='350px'>Host</th>-->
			<th field='attrName' formatter='' width='auto'><xlat:stream key="dvin/AT/Common/Name"/></th>
			<th field='attrType' formatter='' width='auto'><xlat:stream key="dvin/Common/Type"/></th>
		</tr>
	</thead>
</table>

</cs:ftcs>
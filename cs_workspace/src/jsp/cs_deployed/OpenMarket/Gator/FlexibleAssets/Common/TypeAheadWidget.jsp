<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ page import="java.util.*"%>
<cs:ftcs>
<string:encode variable="widgetNode" varname="widgetNode"/>
<satellite:link pagename="fatwire/ui/util/TypeAheadSearchResults" assembler="query" outstring="typeAheadUrl">
	<satellite:argument name="searchField" value='name'/>
	<satellite:argument name="searchOperation" value='STARTS_WITH'/>
	<satellite:argument name="assetType" value='<%=ics.GetVar("typesForSearch")%>'/>
	<satellite:argument name="assetSubType" value='<%=ics.GetVar("subTypesForSearch")%>'/>
	<satellite:argument name="sort" value='name'/>
	<satellite:argument name="rows" value='1000'/>	
</satellite:link>
<ics:if condition='<%="standard".equals(ics.GetVar("cs_environment"))%>'>
<ics:then>
	<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/EditFront" outstring="editBaseURL">
		<satellite:argument name="cs_environment" value='addref'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	</satellite:link>
</ics:then>
<ics:else>
	<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/EditFront" outstring="editBaseURL">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	</satellite:link>
</ics:else>
</ics:if>
<ics:callelement element='OpenMarket/Gator/AttributeTypes/RenderDisplayTooltip'/>			
<%
	if (null == ics.GetVar("subTypesForWidget") || "".equals(ics.GetVar("subTypesForWidget"))) 
		ics.SetVar("subTypesForWidget", "*");
		
	String maximumValues =  ics.GetVar("maxValsSetting");		
%>

<script type="text/javascript">
	dojo.addOnLoad(function() {
		var widVal = [];
		<%
			if (null == ics.GetVar("widgetValue")) 
				ics.SetVar("widgetValue", "");
			else{
				String[]  searchSubTypeArr = ics.GetVar("widgetValue").split(";");
				for(String str: searchSubTypeArr)
				{%>
					widVal.push('<%=str%>');
				<%}
			}
		%>
		var node = dojo.query("div[name=<%=ics.GetVar("widgetNode")%>]")[0],
			typeAheadWid, args, typeAheadStore_<%=ics.GetVar("widgetNode")%>;
		typeAheadStore_<%=ics.GetVar("widgetNode")%> = new dojox.data.QueryReadStore({
			doClientPaging:true,
			doClientSorting:true,
			url:'<%=ics.GetVar("typeAheadUrl")%>'
		});
			
		var typeAheadWid_<%=ics.GetVar("widgetNode")%> = new fw.ui.dijit.form.<%= "false".equalsIgnoreCase(ics.GetVar("displaySearchbox")) ? "AssetContainer" : "TypeAhead" %>({
			multiple:<%=ics.GetVar("multipleVal")%>,
			accept:<%=ics.GetVar("parentType")%>,
			<%if (null != ics.GetVar("widgetValue") && !"".equals(ics.GetVar("widgetValue"))) {%>
			value:widVal,
			<%}%>
			accept_definition:'<%=ics.GetVar("subTypesForWidget")%>',
			store:typeAheadStore_<%=ics.GetVar("widgetNode")%>,
			searchAttr:'name',
			hasDownArrow: true,
			clearButton: false,
			pageSize: <%= Utilities.goodString(ics.GetVar("PAGESIZE")) ? ics.GetVar("PAGESIZE") : 10 %>,			
			<% if("ucform".equals(ics.GetVar("cs_environment"))) {%>
			cs_environment: "ucform",
			<%}%>
			maxVals: <%= Utilities.goodString(maximumValues) && !"0".equals(maximumValues) ? maximumValues : -1 %>,
			placeHolder: '<xlat:stream key="dvin/UI/PlaceHolderTextTypeAhead" />',
			<%if (null != ics.GetVar("multiOrderedAttr") && !"".equals(ics.GetVar("multiOrderedAttr"))) {%>
			multiOrdered:<%=ics.GetVar("multiOrderedAttr")%>,
			<%}%>
			isDropZone: <%="false".equals(ics.GetVar("displaySearchbox")) ? "true" : "false"%>,
			assetId: '<%= ics.GetVar("id")%>',
			assetType: '<%= ics.GetVar("AssetType")%>',
			displayElementName: '<%= null != ics.GetVar("displayElement") ? ics.GetVar("displayElement") : ""%>',
			confidence: <%="true".equals(ics.GetVar("isConfRequired")) ? "true" : "false"%>,
			name:'<%=ics.GetVar("widgetNode")%>',
			<% if ( null != ics.GetVar("AttrName") ) { %>
				id:'MultiVal_<%= ics.GetVar("AttrName") %>_<%= ics.GetVar("id") %>',
			<% } %>	
			uniqueName:'<%=ics.GetVar("widgetNode")%>'
		}, node);
		dojo.connect(typeAheadWid_<%=ics.GetVar("widgetNode")%>, 'onChange', function(){
			<%=ics.GetVar("funcToRun")%>(this);
		});
		dojo.publish("typeAhead/Ready", [typeAheadWid_<%=ics.GetVar("widgetNode")%>]);
		typeAheadWid_<%=ics.GetVar("widgetNode")%>.startup();
		dojo.connect(typeAheadWid_<%=ics.GetVar("widgetNode")%>, 'onEdit', function(item){
		
			var urlBase = '<%=ics.GetVar("editBaseURL")%>';
			if (item.data.id) {
				var urlEdit = urlBase+"&AssetType="+item.data.type[0]+"&id="+item.data.id;
				<% if("ucform".equals(ics.GetVar("cs_environment"))) {%>
					var id = item.data.id, 
						type = dojo.isArray(item.data.type) ? item.data.type[0] : item.data.type;
					SitesApp.event(fwutil.buildDocId(dojo.isString(id) ? id : id.toString(), type), 'edit');
				<%} else { %>
					editwindow = window.open(urlEdit, "_blank");
				<% } %>
			}
			else
			{
				alert('<xlat:stream key="dvin/UI/AssetMgt/NoAssetSpecified" escape="true" encode="false"/>');
			}	
		});			
	});
</script>
<ics:removevar name="creatorTA"/>
<ics:removevar name="maxValsSetting"/>
<ics:removevar name="displayElement"/>
<ics:removevar name="displaySearchbox"/>
<ics:removevar name="isConfRequired"/>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/ParentTreeSelect
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.IList,
				 COM.FutureTense.Interfaces.FTValList,
				 java.util.StringTokenizer,
				 java.util.Iterator,
				 java.util.Hashtable,
				 java.util.ArrayList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<cs:ftcs>
<%
	Map<String, String> parentStyleMap = new HashMap<String, String>();
	Map<String, String> parentDefIDMap = new HashMap<String, String>();
	Map<String, String> parentDescNameMap = new HashMap<String, String>();
	IList templateList = null;
	String templateName = "";
	String templateDesc = "";
%>
<ics:if condition='<%=null != ics.GetList("TmplParents")%>'>
<ics:then>
	<ics:if condition='<%=ics.GetList("TmplParents").hasData()%>'>
	<ics:then>
		<ics:listloop listname='TmplParents'>
			<ics:listget listname="TmplParents" fieldname="assetid" output="parDefId" />
			<asset:list type='<%=ics.GetVar("GroupTemplateType")%>' list='templateList' field1='id' value1='<%=ics.GetVar("parDefId")%>'/>							
				<%templateList = ics.GetList("templateList"); %>
				<%	
					templateName = templateList.getValue("name");
					templateDesc = templateList.getValue("description");
					if("".equals(templateDesc)) templateDesc = templateName;
					
					parentDefIDMap.put(templateName, ics.GetVar("parDefId"));
					parentStyleMap.put(templateName, templateList.getValue("style"));
					parentDescNameMap.put(templateName, templateDesc);
				%>
		</ics:listloop>
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>
<script type="text/javascript">
	var TAParNodeArr = [];
</script>


	<%	
	StringBuilder parTypeSB = new StringBuilder();
	String isMultiple = "false";
	parTypeSB.append("[")
		.append("\""+ ics.GetVar("grouptype") + "\"")
		.append("]");
	int counter = 0;
	
	Hashtable treetmpls = (Hashtable) ics.GetObj("TreeTmpls");			
	for (Iterator it = treetmpls.keySet().iterator(); it.hasNext();) {
		String parentDefName = (String) it.next();
		ics.SetCounter("currentParentTmpl", ics.GetCounter("currentParentTmpl")+1);
		StringBuilder sbType = new StringBuilder();	
		isMultiple = "false";		
		sbType.append("{");
		%>
		<INPUT TYPE="hidden" NAME="<%="_ParentDef_"+ics.GetCounter("currentParentTmpl")+"_Info_"%>"
		  VALUE="<%=ics.GetVar("req"+parentDefName)+","+ics.GetVar("mult"+parentDefName)+","+parentDefName+","+ics.GetVar("_id_"+parentDefName)%>"/>						  
		<ics:setvar name='required' value='<%=ics.GetVar("req"+parentDefName)%>'/>
		<ics:setvar name='multiple' value='<%=ics.GetVar("mult"+parentDefName)%>'/>		
		<% 						
			sbType.append("\""+parentDefName);		
		%>
		<ics:if condition='<%=ics.GetVar("required").equals("true")%>'>
		<ics:then>
			<!--<span class="alert-color">*</span>-->
		</ics:then>
		</ics:if>
		<%--
		<span>
			<string:stream value='<%=" "+parentDefName+" "%>'/>
		</span>
		--%>
		<ics:if condition='<%=ics.GetVar("multiple").equals("true")%>'>
		<ics:then>
			<% 			
			sbType.append("\":true");
			isMultiple = "true";			
			%>
			<!--(M):-->
		</ics:then>
		<ics:else>
			<% 			
			sbType.append("\":false");				
			%>
			<!--(S):-->
		</ics:else>
		</ics:if>
		<%					
		Hashtable selected = (Hashtable) ics.GetObj("hSelected"+parentDefName);
		Hashtable absenteeParents = (Hashtable) ics.GetObj("AbsenteeParents");
		StringBuilder sbParent = new StringBuilder();
		int i = 0;	
		if(null!= ics.GetVar("_parentAssetName") && parentDefName.equals(ics.GetVar("_assetsubtype")))
		  sbParent.append(ics.GetVar("grouptype"))
			 .append(":")
			 .append(ics.GetVar("ID"))
			 .append(":")
			 .append(ics.GetVar("_parentAssetName"))
			 .append(":")
			 .append(parentDefName);		
		for (Iterator itParent = selected.keySet().iterator(); itParent.hasNext();) {
			String parentId = (String) itParent.next();
			if (!absenteeParents.containsKey(parentId)) { %>
				<hash:add name='ParentPost' value='<%=parentId%>'/>
				<xlat:lookup key='dvin/Util/FlexAssets/RemoveSelect' varname='RemoveSelect'/>
				<xlat:lookup key='dvin/Common/AT/Removethisselection' varname='Removethisselection'/>
				<asset:list type='<%=ics.GetVar("grouptype")%>' list='currentAsset' field1='id' value1='<%=parentId%>'/>						
			<%
				if (i > 0)
				{
					sbParent.append(";");
				}				
				sbParent.append(ics.GetVar("grouptype"))
					.append(":")
					.append(parentId)
					.append(":")
					.append(ics.GetList("currentAsset").getValue("name"))
					.append(":")
					.append(parentDefName);
				i++;	
			}
		}
		counter++;
		sbType.append("}");
		%>
			<script type="text/javascript">
				TAParNodeArr.push('<%="typeAheadParent_" + parentDefIDMap.get(parentDefName)%>');
			</script>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/ParentTreeSelectHTML'>			
				<ics:argument name="parentDefNameDesc" value='<%= parentDescNameMap.get(parentDefName)%>'/>
				<ics:argument name="parentDefName" value='<%=parentDefName%>'/>
				<ics:argument name="parentselectStyle" value='<%=parentStyleMap.get(parentDefName)%>'/>
				<ics:argument name="parentDefID" value='<%=parentDefIDMap.get(parentDefName)%>'/>
				<ics:argument name="parentReq" value='<%=ics.GetVar("required")%>'/>
				<ics:argument name="parentMult" value='<%=ics.GetVar("multiple")%>'/>				
			</ics:callelement>						
			<%
				if("A".equals(parentStyleMap.get(parentDefName)) ||  "false".equals(ics.GetVar("showSiteTree"))){
					ics.SetVar("displaySearchInputbox", "true");
				}
				else{
					ics.SetVar("displaySearchInputbox", "false");
				}
			%>	
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget'>			
				<ics:argument name="parentType" value='<%= parTypeSB.toString() %>'/>
				<ics:argument name="subTypesForWidget" value='<%=sbType.toString()%>'/>
				<ics:argument name="subTypesForSearch" value='<%=parentDefName%>'/>
				<ics:argument name="multipleVal" value='<%=isMultiple%>'/>
				<ics:argument name="widgetValue" value="<%=sbParent.toString()%>"/>	
				<ics:argument name="funcToRun" value='<%="selectDnDParent_ta_" + parentDefIDMap.get(parentDefName)%>'/>
				<ics:argument name="widgetNode" value='<%="typeAheadParent_" + parentDefIDMap.get(parentDefName)%>'/>
				<ics:argument name="typesForSearch" value='<%=ics.GetVar("grouptype")%>'/>	
				<ics:argument name="displaySearchbox" value='<%=ics.GetVar("displaySearchInputbox")%>'/>
				<ics:argument name="multiOrderedAttr" value='false'/>		
			</ics:callelement>
		<%
	}	
	%>	

<%-- [2007-11-05 KGF] slight changes here to prevent a IE javascript error. --%>
<xlat:lookup key='dvin/Util/FlexAssets/SelectParentFromTree' escape='true' varname='SelectParentFromTreeEsc'/>
<xlat:lookup key='dvin/Util/FlexAssets/SelectParentFromTree' varname='SelectParentFromTree'/>
<%
FTValList vN = new FTValList();
vN.setValString("FIELD1", "assettype");
vN.setValString("VALUE1", ics.GetVar("parenttype"));
vN.setValString("LIST", "ThisType");
ics.runTag("assettype.list", vN);
%>

<script type="text/javascript">
	//var parentDNDObject = {};
	var selectDnDParent = function(args){
		var nodes = [], typeWidgetIns, 
			obj = document.forms[0],						
			arr, DecodedString = '', i = 0;
		dojo.forEach(TAParNodeArr, function(val){
			nodes = dojo.query('div[name='+val+']');
			if(nodes.length === 0)
				nodes = dojo.query('input[name='+val+']');
			typeWidgetIns = dijit.getEnclosingWidget(nodes[0]);	
			if(typeWidgetIns && typeWidgetIns.isInstanceOf(fw.ui.dijit.form.AssetContainer)) {
				arr = typeWidgetIns._getValueAttr();	
				dojo.forEach(arr, function(v){
					var pieces;
					if (dojo.isString(v)) {
						pieces = v.split(':', 2);															
					}
					if(i > 0)
						DecodedString = DecodedString + ';';
					DecodedString = DecodedString + pieces[1];								
					i++;				
				});	
			}
		});
		obj.elements['_ParentDef_1_SelectedParents_'].value =  DecodedString;
	}
</script>			
</cs:ftcs>

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/IMAGEPICKERDnD
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
<div class='fwOuterDiv' >	
		<div name='imgPNode_<%=ics.GetVar("AttrID")%>' <%if("single".equals(ics.GetVar("EditingStyle"))){%>style='width:auto'<%}%>></div>
	<% if("ucform".equals(ics.GetVar("cs_environment"))){ %>
		<div name="UIActSearchButton_<%=ics.GetVar("AttrID")%>" style="clear:both;">
		
		</div>
	<%}%>
</div>
<%String imagePickerWidVal= "";%>
<%if("single".equals(ics.GetVar("EditingStyle"))){%>
	<% if(null != ics.GetVar("thevalue") && !"".equals(ics.GetVar("thevalue"))) { %>
		<asset:list list="anAsset" field1="id" value1='<%=ics.GetVar("thevalue")%>' type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>'/>
		<asset:getsubtype type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' objectid='<%=ics.GetVar("thevalue")%>' output="subType" />
		<ics:if condition='<%=null != ics.GetList("anAsset")%>'>
		<ics:then>
			<%

			imagePickerWidVal= "['" + ics.GetVar("ASSETTYPENAMEOUT") + ":"
				+ ics.GetVar("thevalue") + ":" + ics.GetList("anAsset").getValue("name") + ":" + ics.GetVar("subType") + "']";

			%>
		</ics:then>
		</ics:if>
	<% } %>

<%}else{
	String inputTagImgPi = ics.GetVar("my_attr_name");
	ics.SetVar("inputTagMulti", inputTagImgPi.substring(0, inputTagImgPi.lastIndexOf('_')));
	String str = ((StringBuilder)ics.GetObj("strAttrValues")).toString();
		String[] strArr= str.split(",");
		int i = 0;
		StringBuilder sbMultVal = new StringBuilder();
		sbMultVal.append("[");
		for(String strM : strArr){
			if(i > 0){
				sbMultVal.append(",");
			}
			if(null != strM && !"".equals(strM)) { 	
%>
				<asset:list list="anAsset" field1="id" value1='<%=strM%>' type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>'/>
				<asset:getsubtype type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' objectid='<%=strM%>' output="subType" />
				<ics:if condition='<%=null != ics.GetList("anAsset")%>'>
				<ics:then>
					<%

							sbMultVal.append("'")
									.append(ics.GetVar("ASSETTYPENAMEOUT"))
									.append(":")
									.append(strM)
									.append(":")
									.append(ics.GetList("anAsset").getValue("name"))
									.append(":")
									.append(ics.GetVar("subType"))	
									.append("'");		
							
					%>
				</ics:then>
				</ics:if>
			<% } %> 			
<%
			i++;
		}
		sbMultVal.append("]");
		imagePickerWidVal = sbMultVal.toString(); 

}
	FTValList args = new FTValList();			
	args.setValString("NAME", ics.GetVar("PresInst"));
	args.setValString("VARNAME", "MAXVALUES");
	ics.runTag("presentation.getmaxvalues", args);
	String maximumValues =  ics.GetVar("MAXVALUES");
%>
<script type="text/javascript">	
	
	dojo.addOnLoad(function() {
		
		var imageContainerNode = dojo.query("div[name=imgPNode_<%=ics.GetVar("AttrID")%>]")[0];			
		
		var 
			imagePickerWid = new fw.ui.dijit.form.ImagePicker({
			<% if("single".equals(ics.GetVar("EditingStyle"))){ %>
				multiple: false,
			<% }else{ %>
				multiple: true,
			<% } %>			
				accept:['<%=ics.GetVar("ASSETTYPENAMEOUT")%>'],
			<% if (null != imagePickerWidVal && !"".equals(imagePickerWidVal)) {%>
				value:<%=imagePickerWidVal%>,
			<% } %>			
				maxVals: <%= Utilities.goodString(maximumValues) && !"0".equals(maximumValues) ? maximumValues : -1 %>,
			<% if("ucform".equals(ics.GetVar("cs_environment"))) { %>
				cs_environment: "ucform",
			<% } %>
				accept_definition:'*',
				isDropZone: <%="ucform".equalsIgnoreCase(ics.GetVar("cs_environment")) ? "true" : "false"%>,
				assetType: '<%= Utilities.goodString(ics.GetVar("ASSETTYPENAMEOUT")) ? ics.GetVar("ASSETTYPENAMEOUT") : "" %>',
				attributeName: '<%= Utilities.goodString(ics.GetVar("ATTRIBUTENAMEOUT")) ? ics.GetVar("ATTRIBUTENAMEOUT") : "" %>'
			}, imageContainerNode);	
		
		dojo.connect(imagePickerWid, 'onChange', function(){
			var obj = document.forms[0],						
				arr = this._getValueAttr(),
				i = 1,
				self = this,
				strRequireInfo = '<%=ics.GetVar("AttrNumber") + "RequireInfo"%>',
				isRequired = <%=ics.GetVar("RequiredAttr")%>;
			obj.elements['<%=ics.GetVar("AttrName")+"VC"%>'].value = arr.length;
			var str ='', strVC = '<%=ics.GetVar("AttrName")+"VC"%>';
			if(arr.length == 0){
				if(this.multiple){
					obj.elements['<%=ics.GetVar("inputTagMulti")+"_1"%>'].value = '';
				<%if (ics.GetVar("RequiredAttr").equals("true")){%>
					obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_1"%>*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqTrue*<%=ics.GetVar("type")%>!';
				<%}	else{%>	
					obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_1"%>*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqFalse*<%=ics.GetVar("type")%>!';
				<%}%>		
				}	
				else 
					obj.elements['<%=ics.GetVar("my_attr_name")%>'].value = '';
			}
			else {
				if(this.multiple){
					for(j = 1; j <= arr.length; j++){
						if(j > 1){
							if (isRequired){
								obj.elements[strRequireInfo].value = obj.elements[strRequireInfo].value + '*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqTrue*<%=ics.GetVar("type")%>!';
							}else{
								obj.elements[strRequireInfo].value = obj.elements[strRequireInfo].value + '*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqFalse*<%=ics.GetVar("type")%>!';
							}				
						}
						else{
							if (isRequired){
								obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqTrue*<%=ics.GetVar("type")%>!';
							}else{
								obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqFalse*<%=ics.GetVar("type")%>!';
							}						
						}
					}
				}
			}
			this._source.getAllNodes().forEach(function(node){
				var data = fw.ui.dnd.util.getNormalizedData(self._source, node);
				if(self.multiple)
				{
					str = '<%=ics.GetVar("inputTagMulti") + "_"%>'+i.toString();
					dojo.query("input[name="+str+"]").forEach(function(delNode){
						dojo.destroy(delNode);
					});
					var inNode = dojo.place('<input type="hidden" value="" name="'+str+'"/>', dojo.query("input[name="+strVC+"]")[0], 'after');
					dojo.attr(inNode, 'value', data.id);
				}
				else {
					obj.elements['<%=ics.GetVar("my_attr_name")%>'].value = data.id;
				}
				i++;	
			});
			if(this.multiple && i > 1){
				str =  '<%=ics.GetVar("inputTagMulti") + "_"%>'+i.toString();
				dojo.query("input[name="+str+"]").forEach(function(delNode){
					dojo.destroy(delNode);
				});				
			}
				
		});
		imagePickerWid.startup();	
	
	<% if("ucform".equals(ics.GetVar("cs_environment"))){ %>
		var button = new fw.ui.dijit.Button({
			label: "<xlat:stream  key='UI/Forms/Browse' locale='<%=ics.GetVar("locale")%>' />",
			title: "<xlat:stream  key='UI/Forms/Browse' locale='<%=ics.GetVar("locale")%>' />",			
			onClick: function() {
				// TODO : UC1 might include attribute type also in search criteria (in this case 'Media_A')
				var assetType = '<%=ics.GetVar("ASSETTYPENAMEOUT")%>';
				parent.SitesApp.searchController.model.set('searchText', '');
				parent.SitesApp.searchController.model.set('assetType', assetType);
				parent.SitesApp.searchController.search();
			}			
		}).placeAt(dojo.query("div[name=UIActSearchButton_<%=ics.GetVar("AttrID")%>]")[0]);
	<% } %>			
	});
	var pickImageInToDnDSrc = function(imageAssetIdTemp, name, subtype, attrId, assetType, attributeName){
		var ImgPickerIns = dijit.byNode(dojo.query('div[name=imgPNode_' + attrId + ']')[0]),
		selValue = {
			'id':imageAssetIdTemp,
			'name':name,
			'subtype':subtype,
			'type':assetType
		};
		ImgPickerIns.setSelectedValue(selValue);
	};
</script>
</cs:ftcs>
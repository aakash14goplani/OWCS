<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/ParentFolderSelect
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.IList,
				 com.openmarket.gator.interfaces.ITemplateAssetInstance,
				 com.openmarket.gator.interfaces.ITemplateableAssetManager,
				 com.openmarket.basic.listobject.ListObject,
				 com.fatwire.flame.portlets.DocumentManagement,
				 com.fatwire.flame.dm.BreadCrumb,
                 com.fatwire.flame.dm.HierarchyNode,
				 java.util.Map,
				 java.util.Iterator,
				 java.util.Hashtable,
				 java.util.List" %>
<%!
	private static String getStringFromMap(Map m, String delim) {
		if (m.isEmpty()) return "";
		StringBuffer sb = new StringBuffer();
		for (Iterator it = m.keySet().iterator(); it.hasNext();) {
			Object o = it.next();
			sb.append(o);
			sb.append(delim);
		}
		sb.setLength(sb.length() - delim.length());
		return sb.toString();
	}
%>
<cs:ftcs>
	<%
	ITemplateAssetInstance ita = (ITemplateAssetInstance)ics.GetObj(ics.GetVar("TemplateInstance"));

	int countParentTmpl = ics.GetCounter("currentParentTmpl");
	Hashtable folders = (Hashtable) ics.GetObj("FolderTmpls");
	for (Iterator itFolderDef = folders.keySet().iterator(); itFolderDef.hasNext(); countParentTmpl++) {
		String id = (String) itFolderDef.next();
		%>
		<asset:list type='<%=ics.GetVar("GroupTemplateType")%>' list='tmplList' field1='id' value1='<%=id%>'/>
		<%
		IList tmpllist = ics.GetList("tmplList");
		String name = tmpllist.getValue("name");
		boolean required = ita.getParentGroupRequired(id);
		boolean multiple = ita.getParentGroupMultiple(id);
		%>
		<ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/RowSpacer'/>
		<tr>
			<td align="right" valign="top" nowrap>
				<%
				if (required) {
					%><span class="alert-color">*</span><%
				}
				%><string:stream value='<%=" "+name+" "%>'/><%
				if (multiple) {
					%>(M):<%
				} else {
					%>(S):<%
				}
				%>
			</td>
			<td></td>
			<%
			ListObject listObject = new ListObject();
			listObject.setColumns("assetid");
			listObject.startNewRow();
			listObject.setColumnValue("assetid", id);

			ITemplateableAssetManager itam = (ITemplateableAssetManager)ics.GetObj(ics.GetVar("GroupManager"));
			IList myParentGroups = itam.getSortedTypedAssets(ics.GetSSVar("pubid"), listObject.getList());

			/**
			 * ContentDetails:Group_[ParentDef Name], or
			 * ContentDetails:Group_[ParentDef Name]:[num]
			 * is loaded by <asset:gather> tag.
			 */
			Hashtable selected = new Hashtable();
			if (!multiple) {
				String idParent = ics.GetVar("ContentDetails:Group_"+name);
				if (idParent != null && !"deleted".equals(ics.GetVar("d"+idParent)))
					selected.put(idParent, idParent);
			} else {
				String total = ics.GetVar("ContentDetails:Group_"+name+":Total");
				int count = total == null ? 0 : Integer.parseInt(total);
				for (int i = 0; i < count; i++) {
					String idParent = ics.GetVar("ContentDetails:Group_"+name+":"+i);
					if (idParent != null && !"deleted".equals(ics.GetVar("d"+idParent)))
						selected.put(idParent, idParent);
				}
			} %>
            <input type="hidden" name="<%="_ParentDef_"+name+"_HasParents_"%>" value="<%=(selected.size()!=0)%>"> <%

			//ics.SetCounter("selectBoxes", ics.GetCounter("selectBoxes")+1);
			ics.SetCounter("currentParentTmpl", ics.GetCounter("currentParentTmpl")+1);
			%>
			<td valign="top" NOWRAP="">
                <INPUT TYPE="hidden" NAME="<%="_ParentDef_"+ics.GetCounter("currentParentTmpl")+"_Info_"%>" VALUE="<%=required+","+multiple+","+name+","+id%>"/>
				<%
				String sFolderType = ics.GetVar("grouptype");
				if (multiple) {
					//If it's multiple, we only list the selected parents of the type.
					ics.SetVar("CanAddParent", "true");
					for (Iterator it = selected.keySet().iterator(); it.hasNext();) {
						String idParent = (String) it.next();
						BreadCrumb builder = new BreadCrumb(sFolderType, idParent);
						List listCrumbs = builder.getNodes(ics, 3);
						%><span class="small-text"><%
						for (int i = listCrumbs.size()-1; i >= 0 ; i--)
						{
							HierarchyNode node = (HierarchyNode)listCrumbs.get(i);
							%><nobr><%=node.getName()%></nobr> &gt; <%
						}
						%><asset:list list='currentAsset' type='<%=sFolderType%>' field1='id' value1='<%=idParent%>'/><%
						IList folder = ics.GetList("currentAsset");
						String folderName = folder.getValue("name");
						ics.RegisterList("currentAsset", null);
						%><nobr><%=folderName%></nobr><%
						%><INPUT TYPE="hidden" NAME="<%="d"+idParent%>" VALUE=""/><%
						%>&nbsp;<a href="javascript:void(0)"
							onclick="return SelectFolder('<%=id%>','<%=ics.GetVar("ThisPage")%>','<%=ics.GetVar("TemplateChosen")%>','<%=idParent%>')"
							onmouseover="window.status=''; return true;"
							onmouseout="window.status=''; return true;"
							><img src='<%=ics.GetVar("cs_imagedir")+"/OMTree/TreeImages/Module.png"%>'
								border="0"/></a></span><br/>
						<%
					}
					%>
					<a href="javascript:void(0)"
						onclick="return SelectFolder('<%=id%>','<%=ics.GetVar("ThisPage")%>','<%=ics.GetVar("TemplateChosen")%>')"
						onmouseover="window.status='<%=ics.GetVar("SelectParentFromTreeEsc")%>'; return true;"
						onmouseout="window.status='';return true;"
						><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems"/></ics:callelement></a>
					<%
				} else {
					//If it's a single parent
					String idParent = selected.isEmpty() ? null : (String)selected.keySet().iterator().next();
					BreadCrumb builder = new BreadCrumb(sFolderType, idParent);
					List listCrumbs = builder.getNodes(ics, 3);
					%><span class="small-text"><%
					for (int i = listCrumbs.size()-1; i >= 0 ; i--)
					{
						HierarchyNode node = (HierarchyNode)listCrumbs.get(i);
						%><nobr><%=node.getName()%></nobr> &gt; <%
					}
					if(idParent != null)
					{
						%><input type="hidden" name="<%="d"+idParent%>" value=""/><%
					}
					%>&nbsp;<a href="javascript:void(0)"
						onclick="return SelectFolder('<%=id%>','<%=ics.GetVar("ThisPage")%>','<%=ics.GetVar("TemplateChosen")%>',<%=idParent%>);"
						onmouseover="window.status=''; return true;"
						onmouseout="window.status=''; return true;"
						><img src='<%=ics.GetVar("cs_imagedir")+"/OMTree/TreeImages/Module.png"%>'
							border="0"/></a>
					</span><%
				}
				for (Iterator it = selected.keySet().iterator(); it.hasNext();) {
				 String idParent = (String) it.next();
				 %>
				<hash:add name='ParentPost' value='<%=idParent%>'/>
				<% } %>
			</td>
		</tr>
		<%
	}
	ics.SetCounter("currentParentTmpl", countParentTmpl);
	//The selectBoxes count is used int he following javascript
	//maybe there is a better way to remove a selected folder
	int countSelectBoxes = ics.GetCounter("selectBoxes");
	%>
	<SCRIPT>
	function SelectFolder(ValidDef, ThisPage, Template, ToDelete) {
		selAllAll(); 
		<satellite:link assembler="query" pagename="OpenMarket/Flame/DocumentManagement/SelectFolderPopup" outstring="mylink">
			<satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>'/>
			<satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>'/>
			<satellite:argument name='<%=DocumentManagement.PARAM_DOC_TYPE%>' value='<%=ics.GetVar("AssetType")%>'/>
			<satellite:argument name='<%=DocumentManagement.PARAM_FOLDER_TYPE%>' value='<%=ics.GetVar("grouptype")%>'/>
		</satellite:link>
		var url = '<%=ics.GetVar("mylink")%>';
		if (ValidDef) url +="&ValidDef="+ValidDef;
		if (ThisPage) url +="&ThisPage="+ThisPage;
		if (Template) url +="&Template="+Template;
		if (ToDelete) url +="&ToDelete="+ToDelete+"&<%=DocumentManagement.PARAM_FOLDERID%>="+ToDelete;
		window.open(url, "_blank", "directories=no,scrollbars=yes,resizable=yes,location=no,menubar=no,toolbar=no,width=400,height=350");
	}
	function UpdateSelection(ThisPage, Template, ToDelete, ParentDescriptor) {
		if (!ToDelete) ToDelete = '';
		var ToSelect = ParentDescriptor ?
			ParentDescriptor.split(',')[0].substring(3) : //remove "id="
			'';
		if (ToSelect == ToDelete) return false;

		var form = document.forms[0];
		if (form.elements['doSubmit'].value=="yes") {
			form.elements['TemplateChosen'].value = Template;
			form.elements['TreeSelect'].value ="yes";
			if (ParentDescriptor) {
				form.elements['ParentSelect'].value = ParentDescriptor;
			}

			if (ToDelete) {
				ToDelete = ''+ToDelete; //cast to string.
				form.elements['d'+ToDelete].value ="deleted";
				var parents = ';'+form.elements['_ParentDef_<%=countSelectBoxes%>_SelectedParents_'].value+';';
				var index = parents.indexOf(';'+ToDelete+';');
				if (index >= 0) {
					var remains = parents.substring(0, index) + parents.substring(index+ToDelete.length+1);
					if (remains.length > 2) {
						form.elements['_ParentDef_<%=countSelectBoxes%>_SelectedParents_'].value = remains.substring(1, remains.length-1);
					} else {
						form.elements['_ParentDef_<%=countSelectBoxes%>_SelectedParents_'].value = "";
                        var defInfo = form.elements['_ParentDef_<%=countSelectBoxes%>_Info_'].value
                        var infoArray = defInfo.split(',');
                        form.elements['_ParentDef_'+infoArray[2]+'_HasParents_'].value = "false";
					}
				}
			}

			repostFlexContentForm();
		}
		return false;
	}
	</SCRIPT>
</cs:ftcs>

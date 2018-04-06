<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/RenderMultiValuedTextEditor
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
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<cs:ftcs>
<string:encode variable="AttrName" varname="AttrName"/>
<string:encode variable="editorName" varname="editorName"/>
<string:encode variable="ContentDetails:name" varname="ContentDetails:name"/>
<script>
dojo.require('fw.util');
dojo.require('fw.dijit.UITextarea');
dojo.require('fw.dijit.UIInput');
dojo.require('dojo.dnd.Source');
dojo.require('fw.ui.dijit.form.MultiValuedTextEditor');
dojo.require("dojo.NodeList-traverse");

</script>

<%
	if ("true".equals(ics.GetVar("RequiredAttr"))) 
		ics.SetVar("isReq", "True");
	else
		ics.SetVar("isReq", "False");

	String maxlength = ics.GetVar("maxlength");
	if (maxlength == null || "" == maxlength) maxlength = "-1";
%>		

<ics:if condition='<%="true".equals(ics.GetVar("AllowEmbeddedLinks"))%>'>
	<ics:callelement element="OpenMarket/Xcelerate/Scripts/AddEmbeddedLink">
		<ics:argument name="AllowEmbeddedLinks" value='<%=ics.GetVar("AllowEmbeddedLinks")%>'/>
	</ics:callelement>
</ics:if>

<div id='<%=ics.GetVar("AttrID")%>'/>
<div>
	<div dojoType="fw.ui.dijit.form.MultiValuedTextEditor" 
		multiple='<%= ics.GetVar("multiple") %>'
		editorName='<%= ics.GetVar("editorName") %>'
		editorParams="<%= ics.GetVar("editorParams") %>"
		value='<%=ics.GetObj("strAttrValues")%>'
		maxlength ='<%= maxlength %>'
		maxVals='<%= ics.GetVar("maximumValues") %>'
		
		isShowEmbeddedLinkButtons='<%= Boolean.parseBoolean(ics.GetVar("AllowEmbeddedLinks")) && Boolean.parseBoolean(ics.GetVar("isShowEmbeddedLinkButtons")) %>'
		cs_SingleInputName='<%= ics.GetVar("cs_SingleInputName") %>'
		attrName='<%= ics.GetVar("AttrName") %>'
		attrDescription='<%= ics.GetVar("textareadesc") %>'		
		attrType='<%= ics.GetVar("AttrType") %>'
		attrNumber='<%= ics.GetVar("AttrNumber") %>'
		isReq='<%= ics.GetVar("isReq") %>'
		assetName='<%=ics.GetVar("ContentDetails:name")%>'
		assetType='<%= ics.GetVar("AssetType") %>'
		editingStyle='<%= ics.GetVar("EditingStyle") %>'
		cs_environment='<%= ics.GetVar("cs_environment") %>'
		
		id='MultiVal_<%= ics.GetVar("AttrName") %>_<%= ics.GetVar("id") %>'
	></div>
</div>	

<%
	ics.RemoveVar("isReq");
	ics.RemoveVar("editorName");
	ics.RemoveVar("AllowEmbeddedLinks");
	ics.RemoveVar("isShowEmbeddedLinkButtons");
%>
</cs:ftcs>

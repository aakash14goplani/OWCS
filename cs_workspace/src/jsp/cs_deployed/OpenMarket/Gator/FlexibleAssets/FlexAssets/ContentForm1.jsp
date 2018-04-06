<%@ page contentType="text/html; charset=UTF-8"
		import="com.openmarket.gator.interfaces.*,
				com.openmarket.assetframework.interfaces.*,
				com.openmarket.xcelerate.interfaces.*,
                COM.FutureTense.Interfaces.*,
                com.openmarket.xcelerate.util.ConverterUtils,
                java.util.Hashtable"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentForm1
//
// INPUT
//
// OUTPUT
%>
<cs:ftcs>
<%
try
{
%>
<!-- user code here -->
<!-- this load is only done to get the descriptive name of the asset
     for the following JavaScript. -->

<assettype:load name='type' type='<%=ics.GetVar("AssetType")%>'/>
<assettype:scatter name='type' prefix='AssetTypeObj'/>

<ics:setvar name='RateName' value='<%=ics.GetVar("empty")%>'/>
<ics:setvar name='ConfidenceName' value='<%=ics.GetVar("empty")%>'/>

<INPUT TYPE="hidden" NAME="TreeSelect" VALUE=""/>

<INPUT TYPE="hidden" NAME="upcommand" VALUE="submit"/>
<string:encode variable="TemplateChosen" varname="TemplateChosen"/>
<% if (ics.GetVar("TemplateChosen") != null && !ics.GetVar("TemplateChosen").equals("")) { %>
<INPUT TYPE="hidden" NAME="TemplateChosen" VALUE='<%=ics.GetVar("TemplateChosen")%>'/>
<% } else { %>
<INPUT TYPE="hidden" NAME="TemplateChosen" VALUE=""/>
<% } %>

<INPUT TYPE="hidden" NAME="doSubmit" VALUE="yes"/>

<!--ics:setdate date='<%=ics.GetVar("empty")%>'/-->
<input TYPE="hidden" NAME="FieldsOnForm" VALUE="name,description,fwtags,Webreference,flextemplateid,externalid,ruleset,Dimension,Dimension-parent"/>


<%
	IFlexAssetTypeManager fatm = FlexTypeManagerFactory.getFlexAssetTypeManager(ics);
	ics.SetVar("templatetype", fatm.getTemplateType(ics.GetVar("AssetType")));
	ics.SetVar("grouptype", fatm.getGroupType(ics.GetVar("AssetType")));
	ics.SetVar("attributetype", fatm.getAttributeType(ics.GetVar("AssetType")));
%>

<INPUT TYPE="hidden" NAME="isReposted" VALUE="true"/>


<!--  Manage the FORM VARIABLES  between add multivalues buttons -->
<%-- Moved this down...
<ics:if condition='<%=ics.GetVar("MultiAttrVals")!=null && ics.GetVar("MultiAttrVals").equals("addanother")%>'>
<ics:then>
    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/AssetGather">
        <ics:argument name="GetOrSet" value="set"/>
        <ics:argument name="flextype" value="asset"/>
    </ics:callelement>
    <asset:scatter name="theCurrentAsset" prefix="ContentDetails"/>
</ics:then>
</ics:if>
--%>

<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/SaveRulesetTuples">
    <ics:argument name="Prefix" value="flexassets"/>
</ics:callelement>

<INPUT TYPE="hidden" NAME="Prefix" VALUE="flexassets"/>

<ics:callelement element="OpenMarket/Gator/Util/HasMarketStudio"/>
<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/ParseTreeSelect"/>
<!-- We must always gather and rescatter, if this is a repost -->
<%
	if (ics.GetVar("isReposted") != null && ics.GetVar("isReposted").equals("true"))
	{
%>
<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/AssetGather">
        <ics:argument name="GetOrSet" value="set"/>
        <ics:argument name="flextype" value="asset"/>
</ics:callelement>
<asset:scatter name="theCurrentAsset" prefix="ContentDetails"/>
<%
	}
%>
<ics:if condition='<%=ics.GetVar("TreeSelect")!=null%>'>
<ics:then>
    <%-- Moved this up...
    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/AssetGather">
        <ics:argument name="GetOrSet" value="set"/>
        <ics:argument name="flextype" value="asset"/>
    </ics:callelement>
    <asset:scatter name="theCurrentAsset" prefix="ContentDetails"/>
    --%>
    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/ShowTreePickError"/>
</ics:then>
</ics:if>

<ics:if condition='<%=!(ics.GetVar("ContentDetails:flextemplateid")==null || ics.GetVar("ContentDetails:flextemplateid").equals(ics.GetVar("empty")))%>'>
<ics:then>
    <ics:setvar name='TemplateChosen' value='<%=ics.GetVar("ContentDetails:flextemplateid")%>'/>
</ics:then>
<ics:else>
    <asset:set name='theCurrentAsset' field='flextemplateid' value='<%=ics.GetVar("TemplateChosen")%>'/>
    <ics:if condition='<%=ics.GetVar("flexassets:name")!=null%>'>
    <ics:then>
        <ics:setvar name='ContentDetails:name' value='<%=ics.GetVar("flexassets:name")%>'/>
    </ics:then>
    </ics:if>
</ics:else>
</ics:if>

<%-- Fix for PR#21131 Moved from above--%>
<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/ContentForm1JavaScript'>
  <ics:argument name='flextype' value='asset'/>
</ics:callelement>

<assettype:load name='TemplateTypeMgr' type='<%=ics.GetVar("templatetype")%>'/>
<assettype:scatter name="TemplateTypeMgr" prefix="DefTypeObj"/>

<asset:load type='<%=ics.GetVar("templatetype")%>' name='ProdTmplinst' objectid='<%=ics.GetVar("TemplateChosen")%>'/>

<asset:get name='ProdTmplinst' field='name' output='TypeName'/>
<asset:get name="ProdTmplinst" field="description" output="TypeDesc" />
<ics:ifempty variable="TypeDesc">
<ics:then>
	<ics:setvar name="TypeDesc" value='<%=ics.GetVar("TypeName") %>' />
</ics:then>
</ics:ifempty>
<ics:ifempty variable="cs_title">
<ics:then>
	<ics:setvar name="cs_title" value='<%=ics.GetVar("TypeDesc") %>' />
</ics:then>
</ics:ifempty>
<%
	ics.CallElement("OpenMarket/Gator/FlexibleAssets/FormMode/DMSupported", null);
	if (Boolean.valueOf(ics.GetVar("DMSupported")).booleanValue() &&
		"DM".equals(ics.GetVar("cs_formmode")))
	{
		ics.CallElement("OpenMarket/Gator/FlexibleAssets/FormMode/DMEnabled", null);
		//If CSDocLink is disabled for asset type, cs_formmode may be changed.
		if (ics.GetObj("enabledFields") != null)
		{
			//flextemplateid is not editable, but is required for asset creation.
%>
<hash:add name="enabledFields" value="flextemplateid" />
<hash:tostring varname="enabledFields" name="enabledFields" delim="," />
<hash:tostring varname="enabledParents" name="enabledParents" delim="," />
<hash:tostring varname="enabledAttributes" name="enabledAttributes" delim="," />
<INPUT TYPE="hidden" NAME="enabledFields" VALUE=',<%=ics.GetVar("enabledFields")%>,'/>
<INPUT TYPE="hidden" NAME="enabledParents" VALUE=',<%=ics.GetVar("enabledParents")%>,'/>
<INPUT TYPE="hidden" NAME="enabledAttributes" VALUE=',<%=ics.GetVar("enabledAttributes")%>,'/>
<ics:removevar name="enabledFields" />
<ics:removevar name="enabledParents" />
<%
			ics.SetObj("enabledParents", null);
%>
<ics:removevar name="enabledAttributes" />
<%
		}
	}
%>
<% if(!"ucform".equals(ics.GetVar("cs_environment"))){%>
<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/SaveAndCancel"/>
<%}%>
<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
<xlat:lookup key="UI/Forms/Marketing" varname="tabMarketing"/>
<xlat:lookup key="UI/Forms/Metadata" varname="tabMetadata"/>
<xlat:lookup key="UI/Forms/VanityUrl" varname="tabVanityUrl"/>
<div dojoType="dijit.layout.ContentPane" region="center">
<div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer">
<ics:callelement element="OpenMarket/Xcelerate/Util/RetainSelectedTab">
	<ics:argument name="tabContent" value='<%= ics.GetVar("tabContent") %>'/>
	<ics:argument name="elementType" value='JSP'/>
</ics:callelement> 
<div dojoType="dijit.layout.ContentPane" title='<%=ics.GetVar("tabContent")%>' style="height: 100%;" selected="true">
		<table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">

      <!-- page title w/ asset name, if any -->
  <!--assettype:list list="ThisAsset" arg1="<%=ics.GetVar("AssetType")%>"/-->
  <tr>
      <ics:if condition='<%=!(ics.GetVar("updatetype")!=null && ics.GetVar("updatetype").equals("setformdefaults"))%>'>
      <ics:then>
          <td><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
      </ics:then>
      <ics:else>
          <ics:ifempty variable="ContentDetails:name">
          <ics:then>
              <td><span class="title-text"><string:stream variable="cs_title"/>:</span></td>
          </ics:then>
          <ics:else>
              <td><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
          </ics:else>
          </ics:ifempty>
      </ics:else>
      </ics:if>
  </tr>

  <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
      <ics:argument name="SpaceBelow" value="No"/>
  </ics:callelement><tr><td><table>
  <%
	Hashtable enabledFields = (Hashtable) ics.GetObj("enabledFields");
	if (enabledFields == null || enabledFields.containsKey("name"))
	{
	%>
	    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
		<tr>
		<td class="form-label-text"><span class="alert-color">*</span><xlat:stream key="dvin/AT/Common/Name"/>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
		<property:get param="xcelerate.asset.sizeofnamefield" inifile="futuretense_xcel.ini" varname="sizeofnamefield"/>
		<td class="form-inset">
			<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
				<ics:argument name="inputName" value="flexassets:name"/>
				<ics:argument name="inputValue" value='<%=ics.GetVar("ContentDetails:name")%>'/>
				<ics:argument name="inputSize" value='32'/>
				<ics:argument name="inputMaxlength" value='<%=ics.GetVar("sizeofnamefield")%>'/>
				<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
			</ics:callelement>
		</td>
	    </tr>
<%	
	}
	if (enabledFields == null || enabledFields.containsKey("fwtags"))
	{
%>
		<ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
		<tr>
		<td class="form-label-text"><xlat:stream key="UI/UC1/Layout/Tags"/>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
		<property:get param="xcelerate.asset.sizeofnamefield" inifile="futuretense_xcel.ini" varname="sizeofnamefield"/>
		<td class="form-inset">
			<ics:callelement element="OpenMarket/Gator/AttributeTypes/TagBox">
				<ics:argument name="inputName" value='fwtags'/>
				<ics:argument name="tagValue" value='<%=ics.GetVar("fwtags")%>'/>
				<ics:argument name="inputSize" value='32'/>
				<ics:argument name="readOnly" value='false'/>
				<ics:argument name="showCloseButton" value='true'/>
				<ics:argument name="inputMaxlength" value='<%=ics.GetVar("sizeofnamefield")%>'/>
				<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
			</ics:callelement>
		</td>	
	    </tr>
<%
	}
	
	if (enabledFields == null || enabledFields.containsKey("template"))
	{
%>
	    <xlat:lookup key="dvin/UI/Template" varname="label"/>
	    <ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowTemplatesIfAny">
		<ics:argument name="Prefix" value="flexassets"/>
		<ics:argument name="showDummy" value="true"/>
		<ics:argument name="label" value='<%=ics.GetVar("label")+":"%>'/>
		<ics:argument name="subtype" value='<%=ics.GetVar("TypeName") %>' />
	    </ics:callelement>
<%
	}
%>
	<%
	IFlexTemplateTypeManager fttm = FlexTypeManagerFactory.getFlexTemplateTypeManager(ics);
	ics.SetVar("grouptemplatetype", fttm.getTemplateType(ics.GetVar("templatetype")));
	IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
	ics.SetObj("pgmgr", atm.locateAssetManager(ics.GetVar("grouptype")));
	%>
	<!--   ASSOCIATING GROUPS -->
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/AssocParents">
		<ics:argument name="tag" value="flextemplates"/>
		<ics:argument name="TemplateInstance" value="ProdTmplinst"/>
		<ics:argument name="GroupManager" value="pgmgr"/>
		<ics:argument name='GroupTemplateType' value='<%=ics.GetVar("grouptemplatetype")%>'/>
	</ics:callelement>
	<ics:clearerrno/>
	<!-- Associating FlexAssets associated with Tmpls -->
	<ics:setvar name='flextemplateid' value='<%=ics.GetVar("TemplateChosen")%>'/>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/AssocAttr">
		<ics:argument name="tagtype"  value="flextemplates"/>
	</ics:callelement>
		<%
	// Handle asset associations
	IAssocNamedManager we = AssocNamedManagerFactory.make(ics);
	ics.RegisterList("associations", we.getList(ics.GetVar("AssetType"),null,null,null,null,null,null));
%>
	    <!--ASSOCNAMEDMANAGER.LIST  LISTVARNAME="associations" TYPE="Variables.AssetType"/-->
	    <ics:if condition='<%=ics.GetList("associations").hasData()%>'>
	    <ics:then>
			<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/AssetChildrenFormTypeAhead"/>
	    </ics:then>
	    </ics:if>
	    </table> </td></tr></table> 
        </div>
		<div dojoType="dijit.layout.ContentPane" title='<%=ics.GetVar("tabMarketing")%>' style="height: 100%;">
        <table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
  <tr>
      <ics:if condition='<%=!(ics.GetVar("updatetype")!=null && ics.GetVar("updatetype").equals("setformdefaults"))%>'>
      <ics:then>
          <td class="form-inset"><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
      </ics:then>
      <ics:else>
          <ics:ifempty variable="ContentDetails:name">
          <ics:then>
              <td class="form-inset"><span class="title-text"><string:stream variable="cs_title"/>:</span></td>
          </ics:then>
          <ics:else>
              <td class="form-inset"><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
          </ics:else>
          </ics:ifempty>
      </ics:else>
      </ics:if>
  </tr>

  <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
      <ics:argument name="SpaceBelow" value="No"/>
  </ics:callelement>
			<tr><td>
				<table border="0" cellpadding="0" cellspacing="0">   
	
	    <ics:if condition='<%=ics.GetVar("hasMarketStudio").equals("true")%>'>
	    <ics:then>
<%
	if (enabledFields == null || enabledFields.containsKey("ruleset"))
	{
%>
		
		<!--RULESET  IMPLEMENTATION -->
<%
		FTValList rulesetmapargs = new FTValList();
		rulesetmapargs.setValString("NAME", "theCurrentAsset");
		rulesetmapargs.setValString("OBJVARNAME", "theAppMap");
		ics.runTag("FLEXASSET.GETRATINGRULESETMAP", rulesetmapargs);
		rulesetmapargs.removeAll();
%>
		<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/CDLoadRuleset"/>
		<ics:setvar name="RuleCreation" value="UI"/>
		<ics:if condition='<%=ics.GetVar("RuleCreation").equals("Advanced")%>'>
		<ics:then>
			<ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
			<tr>
				<td valign="top" class="form-label-text"><xlat:stream key="dvin/FlexibleAssets/FlexAssets/TargetSegments"/>:</td>
				<td><string:stream variable="thisText"/></td>
				<td class="form-inset">
					<ics:callelement element="OpenMarket/Gator/AttributeTypes/CommonTextArea">
						<ics:argument name="areaName" value='flexassets:ruleset'/>
						<ics:argument name="areaValue" value='Variables.thisText'/>
						<ics:argument name="areaRows" value='24'/>
						<ics:argument name="areaCols" value='60'/>
						<ics:argument name="areaWrap" value='virtual'/>
					</ics:callelement>
				</td>
			</tr>
		</ics:then>
		<ics:else>
			<ics:if condition='<%=ics.GetVar("RuleCreation").equals("UI")%>'>
			<ics:then>
				<ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
				<INPUT type="hidden" name="RuleCreation" value="<%=ics.GetVar("RuleCreation")%>"/>
				<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/EditRules"/>
			</ics:then>
			</ics:if>
		</ics:else>
		</ics:if>
		<!--end of ruleset-->
<%
	}

	IRatedAssetInstance rai = (IRatedAssetInstance) ics.GetObj("theCurrentAsset");
	//IRatedAssetInstance ira = (IRatedAssetInstance)obj;
	rai.getRatingRuleset(ics,"xmltext");
%>
		<!--flexasset.getratingrules  NAME="theCurrentAsset" VARNAME="xmltext"/-->

		<ics:if condition='<%=ics.GetVar("xmltext")!=null%>'>
		<ics:then>
			<string:encode variable="xmltext" varname="thisText"/>
			<!--substitute STR="Variables.xmltext" WHAT="&#60;" WITH="&#38;lt;" OUTSTR="thisText"/-->
		</ics:then>
		<ics:else>
			<ics:setvar name='thisText' value='<%=ics.GetVar("empty")%>'/>
		</ics:else>
		</ics:if>

		

<%
	if (enabledFields == null || enabledFields.containsKey("Relationships"))
	{
%>
		<ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
		<tr>
			<td class="form-label-text"><xlat:stream key="dvin/FlexibleAssets/FlexAssets/RelatedItems"/>:</td>
			<td></td>
			<td class="form-inset">
				<!-- load and display recommendations -->
				<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/CoFRecommendations"/>
				<!-- make new list, including name of assets -->
				<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/Recommendations"/>
			</td>
		</tr>
		
<%
	}
%>
	    </ics:then>
	    </ics:if>
		</table>
          <!--end of body-->
      </td>
  </tr>
	<INPUT TYPE="hidden" NAME="ConfidenceName" VALUE="<%=ics.GetVar("ConfidenceName")%>"/>
  <INPUT TYPE="hidden" NAME="RateName" VALUE="<%=ics.GetVar("RateName")%>"/>
</table></td></tr></table>
</div>
<div dojoType="dijit.layout.ContentPane" title='<%=ics.GetVar("tabMetadata")%>' style="height: 100%;">
<table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
  <tr>
      <ics:if condition='<%=!(ics.GetVar("updatetype")!=null && ics.GetVar("updatetype").equals("setformdefaults"))%>'>
      <ics:then>
          <td><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
      </ics:then>
      <ics:else>
          <ics:ifempty variable="ContentDetails:name">
          <ics:then>
              <td><span class="title-text"><string:stream variable="cs_title"/>:</span></td>
          </ics:then>
          <ics:else>
              <td><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
          </ics:else>
          </ics:ifempty>
      </ics:else>
      </ics:if>
  </tr>

 <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
      <ics:argument name="SpaceBelow" value="No"/>
  </ics:callelement>

  <tr>
      <td>
          <table class="inner" border="0" cellpadding="0" cellspacing="0">
              <!-- attribute inspection form -->
              <ics:setvar name='storeID'  value='<%=ics.GetVar("id")%>'/>
              <ics:if condition='<%=!(ics.GetVar("updatetype")!=null && ics.GetVar("updatetype").equals("setformdefaults"))%>'>
              <ics:then>
		<ics:setvar name="NewSection" value="true"/>
              </ics:then>
              </ics:if>

<%
	if (enabledFields == null || enabledFields.containsKey("description"))
	{
%>
	    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
	    <tr>
		<td valign="top" class="form-label-text"><span class="alert-color"></span><xlat:stream key="dvin/AT/Common/Description"/>:</td>
		<td></td>
		<td class="form-inset">
			<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
				<ics:argument name="inputName" value="flexassets:description"/>
				<ics:argument name="inputValue" value='<%=ics.GetVar("ContentDetails:description")%>'/>
				<ics:argument name="inputSize" value='32'/>
				<ics:argument name="inputMaxlength" value='128'/>
				<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
			</ics:callelement>
		</td>
	    </tr>
<%
	}
		if (enabledFields == null || enabledFields.containsKey("id"))
	{
%>
	    <ics:if condition='<%=!(ics.GetVar("updatetype").equals("setformdefaults"))%>'>
	    <ics:then>
		<ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
		<tr>
			<td class="form-label-text"><xlat:stream key="dvin/AT/Common/ID"/>:</td>
			<td></td>
			<td class="form-inset"><span class="disabledEditText"><string:stream variable="id"/></span></td>
		</tr>
	    </ics:then>
	    </ics:if>
<%
	}
		
	if (enabledFields == null || enabledFields.containsKey("filename"))
	{
%>
	    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
	    <tr>
		<td class="form-label-text"><xlat:stream key="dvin/Common/Filename"/>:</td>
		<td></td>
		<td class="form-inset">
			<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
				<ics:argument name="inputName" value="flexassets:filename"/>
				<ics:argument name="inputValue" value='<%=ics.GetVar("ContentDetails:filename")%>'/>
				<ics:argument name="inputSize" value='32'/>
				<ics:argument name="inputMaxlength" value='64'/>
				<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
			</ics:callelement>
		</td>
	    </tr>
<%
	}

	if (enabledFields == null || enabledFields.containsKey("path"))
	{
%>
	    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
	    <tr>
		<td class="form-label-text"><xlat:stream key="dvin/Common/Path"/>:</td>
		<td></td>
		<td class="form-inset">
			<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
				<ics:argument name="inputName" value="flexassets:path"/>
				<ics:argument name="inputValue" value='<%=ics.GetVar("ContentDetails:path")%>'/>
				<ics:argument name="inputSize" value='32'/>
				<ics:argument name="inputMaxlength" value='255'/>
				<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
			</ics:callelement>
		</td>
	    </tr>
<%
	}
%>
		<!--Call start date and end date for site preview-->
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/AssetTypeStartEndDate">
			<ics:argument name="startDateFieldName" value="flexassets:startdate"/>
			<ics:argument name="endDateFieldName"  value="flexassets:enddate"/>
		</ics:callelement>
		<!--End site preview dates -->
<%
	ics.SetVar("dimFormPrefix", "flexassets");
	ics.SetVar("dimVarPrefix", "ContentDetails");
	ics.CallElement("OpenMarket/Xcelerate/AssetType/Dimension/ShowDimensionForm", null);

	ics.SetVar("NewSection", "true");
%>
	    <property:get param="mwb.externalattributes" inifile="gator.ini" varname="canDefineExternalAttributes"/>
<%
	if (ics.GetVar("canDefineExternalAttributes").equals("true") && ( enabledFields == null || enabledFields.containsKey("externalid")))
	{
%>
	    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
	    <tr>
		<td class="form-label-text"><xlat:stream key="dvin/FlexibleAssets/FlexAssets/ExternalItemId"/>:</td>
		<td></td>
		<td class="form-inset">
			<string:encode variable="ContentDetails:externalid" varname="OutputQString"/>
			<input TYPE="TEXT" NAME="flexassets:externalid" SIZE="32" MAXLENGTH="20" VALUE="<%=ics.GetVar("OutputQString")%>"/>
		</td>
	    </tr>
<%
	}
	ics.SetVar("NewSection", "true");

	if (enabledFields == null || enabledFields.containsKey("templatetype"))
	{
%>
	    <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormRowSpacer"/>
	    <tr>
		<td class="form-label-text"><string:stream variable="DefTypeObj:description"/>:</td>
		<td></td>
		<td class="form-inset"><xlat:lookup key="dvin/Common/InspectThisItem" varname="InspectThisItem" escape="true"/>
			<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
				<ics:argument name="assettype" value='<%=ics.GetVar("templatetype")%>'/>
				<ics:argument name="assetid" value='<%=ics.GetVar("TemplateChosen")%>'/>
				<ics:argument name="varname" value="urlInspectItem"/>
				<ics:argument name="function" value="inspect"/>
			</ics:callelement>
			<a href="<%=ics.GetVar("urlInspectItem")%>" onmouseover="window.status='<%=ics.GetVar("InspectThisItem")%>';return true;" onmouseout="window.status='';return true" ><span class="disabledEditText"><string:stream variable="TypeName"/></span></a>
		</td>
	    </tr>
<%
	}

%>
		<!--  Associating   Groups -->

	    <ics:if condition='<%=ics.GetVar("ContentDetails:flextemplateid").equals("")%>'>
	    <ics:then>
		<INPUT type="hidden" name="flexassets:flextemplateid" value="<%=ics.GetVar("TemplateChosen")%>"/>
	    </ics:then>
	    <ics:else>
		<string:encode variable="ContentDetails:flextemplateid" varname="ContentDetails:flextemplateid"/>
		<INPUT type="hidden" name="flexassets:flextemplateid" value="<%=ics.GetVar("ContentDetails:flextemplateid")%>"/>
	    </ics:else>
	    </ics:if>
		<ics:if condition='<%=!(ics.GetVar("updatetype").equals("setformdefaults"))%>'>
		<ics:then>
		  <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		  <tr>
			  <td class="form-label-text"><xlat:stream key="dvin/AT/Common/Created"/>:</td>
			  <td></td>
				<dateformat:getdatetime name='_FormatDate_' value='<%=ics.GetVar("ContentDetails:createddate")%>' valuetype='jdbcdate'  varname='ContentDetails:createddate'/>
			   <td class="form-inset"><span class="disabledEditText"><xlat:stream key="dvin/FlexibleAssets/FlexAssets/Bycreatedby"/></span></td>
		  </tr>

		  <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		  <tr>
			  <td class="form-label-text"><xlat:stream key="dvin/AT/Common/Modified"/>:</td>
			  <td></td>
			  <dateformat:getdatetime name='_FormatDate_' value='<%=ics.GetVar("ContentDetails:updateddate")%>' valuetype='jdbcdate'  varname='ContentDetails:updateddate'/>
			  <td class="form-inset"><span class="disabledEditText"><xlat:stream key="dvin/FlexibleAssets/FlexAssets/byUpdatedby"/></span></td>
		  </tr>
		</ics:then>
		</ics:if>
		<ics:callelement element="OpenMarket/Xcelerate/Actions/Workflow/ShowAssignees"/>
		</table>
	</td></tr></table>
	</div>
		
<div dojoType="dijit.layout.ContentPane" title='<%=ics.GetVar("tabVanityUrl")%>'>
		 <table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
	  <tr>
	      <ics:if condition='<%=!(ics.GetVar("updatetype")!=null && ics.GetVar("updatetype").equals("setformdefaults"))%>'>
	      <ics:then>
	          <td class="form-inset"><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
	      </ics:then>
	      <ics:else>
	          <ics:ifempty variable="ContentDetails:name">
	          <ics:then>
	              <td class="form-inset"><span class="title-text"><string:stream variable="cs_title"/>:</span></td>
	          </ics:then>
	          <ics:else>
	              <td class="form-inset"><span class="title-text"><string:stream variable="cs_title"/>:</span>&nbsp;<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
	          </ics:else>
	          </ics:ifempty>
	      </ics:else>
	      </ics:if>
	  </tr>
	   <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
    	  	<ics:argument name="SpaceBelow" value="No"/>
  		</ics:callelement>
		<tr> 
			<td>
	 			<ics:callelement element="OpenMarket/Gator/AttributeTypes/WebReferences">
	 			<ics:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
	 			<ics:argument name="id" value='<%=ics.GetVar("id")%>'/>
	 			<ics:argument name="Prefix" value="flexassets"/>
	 			</ics:callelement>
	 		</td>     
	 </tr>                                                        
	</table>    
	</div>
	</div>

</div>
<%
}
catch (Exception e)
{
    e.printStackTrace();
}
%>
</cs:ftcs>

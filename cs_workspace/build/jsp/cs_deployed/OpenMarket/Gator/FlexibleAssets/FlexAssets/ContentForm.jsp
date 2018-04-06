<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentFormJSP
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
<%@ page import="com.openmarket.gator.interfaces.*"%>
<cs:ftcs>
<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">
<!-- user code here -->
<INPUT TYPE="HIDDEN" NAME="FlexTmplsNextStep" VALUE=""/>
<INPUT TYPE="HIDDEN" NAME="MultiAttrVals" VALUE=""/>


<ics:if condition='<%=!(ics.GetVar("ContentDetails:createddate").equals(ics.GetVar("empty")))%>'>
<ics:then>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentForm1"/>
</ics:then>
<ics:else>
  <%
    //FlexAssetTypeManager fatm = new FlexAssetTypeManager(ics);
    IFlexAssetTypeManager fatm = FlexTypeManagerFactory.getFlexAssetTypeManager(ics);
    ics.SetVar("templatetype", fatm.getTemplateType(ics.GetVar("AssetType")));
    
  %>
  <asset:getsubtype name='theCurrentAsset' output='subtypeName'/>
  
  <ics:if condition='<%=ics.GetVar("subtypeName")!=null%>'>
  <ics:then>
    <ics:setvar name="errno" value="0"/>
    <asset:list type='<%=ics.GetVar("templatetype")%>'
                field1='name'
                value1='<%=ics.GetVar("subtypeName")%>'
                list='lCurrentSubtype'/>
    <ics:setvar name='TemplateChosen' value='<%=ics.GetList("lCurrentSubtype").getValue("id")%>'/>
  </ics:then>
  </ics:if>
  
  <ics:if condition='<%=ics.GetVar("TemplateChosen")==null%>'>
  <ics:then>
    <asset:list type='<%=ics.GetVar("templatetype")%>' excludevoided='true' pubid='<%=ics.GetSSVar("pubid")%>' list='lAllDefs'/>
    <ics:if condition='<%=ics.GetList("lAllDefs")!=null && ics.GetList("lAllDefs").numRows()==1%>'>
    <ics:then>
      <ics:setvar name='TemplateChosen' value='<%=ics.GetList("lAllDefs").getValue("id")%>'/>
      <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentForm1"/>
    </ics:then>
    <ics:else>
      <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/AssocTmpls"/>
    </ics:else>
    </ics:if>
  </ics:then>
  <ics:else>
      <ics:callelement element="OpenMarket/Gator/FlexibleAssets/FlexAssets/ContentForm1"/>
  </ics:else>
  </ics:if>
</ics:else>
</ics:if>
</div>
</cs:ftcs>
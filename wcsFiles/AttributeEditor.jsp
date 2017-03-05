<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>

	<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ"> 
		<ics:argument name="assetId" value='<%=ics.GetVar("cid") %>'/>
		<ics:argument name="assetType" value='<%=ics.GetVar("c") %>'/>
	</ics:callelement>
	
	<asset:load name="anyName" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' flushonvoid="true" />
	<asset:scatter name="anyName" prefix="asset" />
	Error asset:load : <ics:geterrno /><br/><br/>
	
	<assetset:setasset name="flexAsset" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />			
	<assetset:getattributevalues name="flexAsset" typename="HIG_ComponentWidget_A" attribute="checkbox" listvarname="checkboxList"/>		
	<assetset:getattributevalues name="flexAsset" typename="HIG_ComponentWidget_A" attribute="ckeditor" listvarname="ckeditorList"/>		
	<assetset:getattributevalues name="flexAsset" typename="HIG_ComponentWidget_A" attribute="drop_asset" listvarname="pickAssetList"/>		
	<assetset:getattributevalues name="flexAsset" typename="HIG_ComponentWidget_A" attribute="dropdown" listvarname="pullDownList"/>		
			
	NAME : <ics:getvar name="asset:name" /><br/>
	Hobby : 	
	<ics:listloop listname="checkboxList">
		<ics:listget listname="checkboxList" fieldname="value" /> , 
	</ics:listloop><br/>
	<ics:listloop listname="ckeditorList">
	Image : <ics:listget listname="ckeditorList" fieldname="value" /><br/>
	</ics:listloop>
	Assets : 	
	<ics:listloop listname="pickAssetList">
		<ics:listget listname="pickAssetList" fieldname="value" /> , 
	</ics:listloop><br/>
	<ics:listloop listname="pullDownList">
	Color : <ics:listget listname="pullDownList" fieldname="value" /><br/>
	</ics:listloop>
	Error assetset:load : <ics:geterrno />
	
	
	
	
</cs:ftcs>
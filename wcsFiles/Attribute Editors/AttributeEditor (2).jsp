<%@page import="com.sun.corba.se.spi.ior.ObjectId"%>
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

	<asset:load name="anyName" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid") %>' flushonvoid="true" />
	<asset:scatter name="anyName"/>
	Name : <ics:getvar name="name" /> <br/>
	Error Basic Asset : <ics:geterrno/> <br/><br/>
	
	<assetset:setasset name="flexAsset" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>'/>
	
	<assetset:getattributevalues name="flexAsset" listvarname="ckeditorList" attribute="ckeditor" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="pickAssetList" attribute="pickAsset" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="radioButtonList" attribute="radioButton" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="textAreaList" attribute="textArea" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="textfieldList" attribute="textfield" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="dropdownList" attribute="dropdown" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="checkboxList" attribute="checkbox" typename="HIG_ComponentWidget_A" />
	<assetset:getattributevalues name="flexAsset" listvarname="helloList" attribute="hello" typename="HIG_ComponentWidget_A" />
	
	<ics:listloop listname="textfieldList">
		Text Field Content : <ics:listget fieldname="value" listname="textfieldList"/><br/>
	</ics:listloop>
	
	Without loop : <ics:listget fieldname="value" listname="textfieldList"/><br/>
	
	<ics:listloop listname="radioButtonList">
		Radio Content : <ics:listget fieldname="value" listname="radioButtonList"/><br/>
	</ics:listloop>
	Checkbox Content : <ics:listloop listname="checkboxList"> 
		<ics:listget fieldname="value" listname="checkboxList"/>, 
	 </ics:listloop>><br/>
	<ics:listloop listname="dropdownList">
		Dropdown Content : <ics:listget fieldname="value" listname="dropdownList"/><br/>
	</ics:listloop>
	<ics:listloop listname="ckeditorList">
		Editor Content : <ics:listget fieldname="value" listname="ckeditorList"/><br/>
	</ics:listloop>
	<ics:listloop listname="textAreaList">
		Text Area Content : <ics:listget fieldname="value" listname="textAreaList"/><br/>
	</ics:listloop>
	<ics:listloop listname="pickAssetList">
		PickAsset Content : <ics:listget fieldname="value" listname="pickAssetList"/><br/>
	</ics:listloop>
	<ics:listloop listname="helloList">
		Hello Content : <ics:listget fieldname="value" listname="helloList"/><br/>
	</ics:listloop>
	Error Flex Asset : <ics:geterrno/> <br/><br/>
	
	<assetset:getmultiplevalues name="flexAsset" prefix="asset" byasset="true">
		<assetset:sortlistentry attributetypename="HIG_ComponentWidget_A" attributename="radioButton"/>
		<assetset:sortlistentry attributetypename="HIG_ComponentWidget_A" attributename="dropdown"/>
		<assetset:sortlistentry attributetypename="HIG_ComponentWidget_A" attributename="checkbox"/>
	</assetset:getmultiplevalues>
	<assetset:getassetlist name="flexAsset" listvarname="multiple_list"/>
	<ics:listloop listname="multiple_list">
		<ics:listget fieldname="assetid" listname="multiple_list" output="id"/>
		dropdown : <ics:listget listname='<%="asset:" + ics.GetVar("id") + ":dropdown" %>' fieldname="value"/> <br/>
		checkbox : <ics:listget listname='<%="asset:" + ics.GetVar("id") + ":checkbox" %>' fieldname="value"/> <br/>
		radio : <ics:listget listname='<%="asset:" + ics.GetVar("id") + ":radioButton" %>' fieldname="value"/> <br/>
	</ics:listloop>	
</cs:ftcs>
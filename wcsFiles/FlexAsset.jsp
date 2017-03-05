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
	
	Loading Flex Asset of type <b><%=ics.GetVar("c")%></b> and id <b><%=ics.GetVar("cid")%></b><br/><br/>
	<assetset:setasset name="flexAsset" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />
			
	<assetset:getattributevalues name="flexAsset" typename="HIG_ComponentWidget_A" attribute="title" listvarname="titleList"/>
	<assetset:getattributevalues name="flexAsset" typename="HIG_ComponentWidget_A" attribute="body_text" listvarname="bodyTextList"/>

	title : <br/> 
	<ics:listloop listname="titleList">
	     <ics:listget listname="titleList" fieldname="value" /><br/>
	</ics:listloop> 
	body_text :<br/> 
	<ics:listloop listname="bodyTextList">
	     <ics:listget listname="bodyTextList" fieldname="value" /><br/>
	</ics:listloop>
	Error Single Value : <ics:geterrno /><br/><br/>
	
	<assetset:getmultiplevalues name="flexAsset" prefix="assetset"> 
		<assetset:sortlistentry attributetypename="HIG_ComponentWidget_A" attributename="title" />
		<assetset:sortlistentry attributetypename="HIG_ComponentWidget_A" attributename="body_text" />
	</assetset:getmultiplevalues>
	
	title : <br/> 
	<ics:listloop listname="assetset:title">
	     <ics:listget listname="assetset:title" fieldname="value" /><br/>
	</ics:listloop> 
	body_text :<br/> 
	<ics:listloop listname="assetset:body_text">
	     <ics:listget listname="assetset:body_text" fieldname="value" /><br/>
	</ics:listloop>
	
	Error Multiple Value : <ics:geterrno /><br/><br/>
	
</cs:ftcs>
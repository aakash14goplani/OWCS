<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib	prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib	prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib	prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib	prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib	prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib	prefix="searchstate" uri="futuretense_cs/searchstate.tld"%>
<%@ page	import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"%>
<cs:ftcs>
	
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	
	<!-- var myName = "Pushkar"; myName; + myName-->
	<ics:setvar name="myName" value="Pushkar"/>
	My Name is <ics:getvar name="myName"/><br/><br/>
	
	
	
	<%
		//String name;
		ics.SetVar("name2", "Pushkar");
		out.println("Java name : " + ics.GetVar("name2"));
	 %>

	Asset Load of type : <%=ics.GetVar("c")%> and id : <%=ics.GetVar("cid")%> E.g. <br />
	<asset:load name="xyx" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' flushonvoid="true" />
	<asset:scatter name="xyx" />
	Name : <ics:getvar name="name" />
	<br />
	Template : <ics:getvar name="template" />
	<br/>
	Image URL : <ics:getvar name="urlImage" />
	<br />
	Address : <ics:getvar name="address" />
	<br />
	LOAD Error : <ics:geterrno />
	<br />
	<br />

	<ics:setvar name="typeName" value="ABC_A" />
	
	Assetset Attributes of type : <%=ics.GetVar("c")%> and id : <%=ics.GetVar("cid")%> E.g. <br />
	<assetset:setasset name="abc" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />
	SET Error 1 : <ics:geterrno />
	<br />
	<assetset:getattributevalues name="abc" attribute="TITLE" typename='<%=ics.GetVar("typeName")%>' listvarname="listABC" />
	SET Error 2 : <ics:geterrno />
	<br />
	<ics:listloop listname="listABC">
		<ics:listget listname="listABC" fieldname="id" output="id" />
    	TITLE : <ics:getvar name="id" />
		<br />
		<ics:listget listname="listABC" fieldname="value" />
		<br />
		<br />
	</ics:listloop>

	<assetset:getattributevalues name="abc" attribute="AGE" typename='<%=ics.GetVar("typeName")%>' listvarname="listABC2" />
	SET Error 22 : <ics:geterrno />
	<br />
	<ics:listloop listname="listABC2">
    	AGE : <ics:listget listname="listABC2" fieldname="value" />
		<br />
		<br />
	</ics:listloop>
	
	<!-- for(i:a.length) a[i] -->
	
	SET Error 3 : <ics:geterrno />
	<br />
	
	Assetset MultipleValues of type : <%=ics.GetVar("c")%> and id : <%=ics.GetVar("cid")%> E.g. <br />
	<assetset:setasset name="aaa" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />
	SET multiple Error 1 : <ics:geterrno />
	<br />
	<assetset:getmultiplevalues name="aaa" prefix="hi">
		<assetset:sortlistentry attributetypename='<%=ics.GetVar("typeName")%>' attributename="TITLE" />
		<assetset:sortlistentry	attributetypename='<%=ics.GetVar("typeName")%>'	attributename="AGE" />
	</assetset:getmultiplevalues>
	SET multiple Error 2 : <ics:geterrno />
	<br />
	<ics:listloop listname="hi:TITLE">
		title : <ics:listget listname="hi:TITLE" fieldname="value" />
		<br />
	</ics:listloop>
	<br />
	<ics:listloop listname="hi:AGE">
		age : <ics:listget listname="hi:AGE" fieldname="value" />
		<br />
		<ics:listget listname="hi:AGE" fieldname="id" output="id" />
    	age : <ics:getvar name="id" />
		<br />
	</ics:listloop>
	<br />SET multiple Error 3 : <ics:geterrno />

	<ics:callelement element="LoadAssetDetails"> 
		<ics:argument name="assetId" value='<%=ics.GetVar("cid") %>'/>
		<ics:argument name="assetType" value='<%=ics.GetVar("c") %>'/>
	</ics:callelement>

</cs:ftcs>
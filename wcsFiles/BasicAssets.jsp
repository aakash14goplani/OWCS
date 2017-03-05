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
	
	Loading Basic Asset of type <b><%=ics.GetVar("c")%></b> and id <b><%=ics.GetVar("cid")%></b><br/><br/>
	<asset:load name="anyName" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' flushonvoid="true" />
	<asset:scatter name="anyName" prefix="asset" />
	<asset:get name="anyName" field="taxo_type" />
	GET TITLE : <ics:getvar name="taxo_type" /><br/><br/>
			
	<%
		if("HIG_Taxonomy".equals(ics.GetVar("c"))){
	 %>	
			Type : <ics:getvar name="asset:taxo_type" /><br/>
			Name : <ics:getvar name="asset:taxo_name" /><br/>
			Value <ics:getvar name="asset:taxo_value" /> <br/>
			SIC Code : <ics:getvar name="asset:sic_code" /><br/>
			Error Code : <ics:geterrno /><br/><br/>
	<%
		}else if("Form".equals(ics.GetVar("c"))){
	 %>
		 		Name : <ics:getvar name="asset:UserName" /><br/>
				Image : <ics:getvar name="asset:urlpicture" /><br/>
				Address <ics:getvar name="asset:Address" /> <br/>
				Country : <ics:getvar name="asset:Country" /><br/>
				Hobby : <ics:getvar name="asset:Hobbies" /><br/>
				Gender : <ics:getvar name="asset:Gender" /><br/>
				Error Code : <ics:geterrno /><br/><br/>
		<%
			}
		 %>
	
</cs:ftcs>
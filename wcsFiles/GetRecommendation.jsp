<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="vdm" uri="futuretense_cs/vdm.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>

	<%
		String age = ics.GetVar("age");
		String gender = ics.GetVar("gender");
		String recommendationId = ics.GetVar("rid");
		out.println("Values : " + age + " : " + gender + " : " + recommendationId + "<br/><br/>");
		if(age != null && "".equals(age)){
	 %>
	 	<vdm:setscalar attribute="sachin_age" value='<%=age %>'/>
	 <%
	 	}
	 	if(gender != null && "".equals(gender)){
	  %>
	 	<vdm:setscalar attribute="sachin_gender" value='<%=gender %>'/>
	 <%
	 	}
	  %>
	  <commercecontext:calculatesegments/>
	  <commercecontext:getrecommendations listvarname="recommendationList" collectionid='<%=recommendationId %>'/>
	  <ics:listloop listname="recommendationList">
	  	<ics:listget fieldname="assetid" listname="recommendationList" output="assetId"/>
	  	<ics:listget fieldname="assettype" listname="recommendationList" output="assetType"/>
	  	<ics:getvar name="assetId"/> : <ics:getvar name="assetType"/> <br/>
	  	<assetset:setasset name="recoAsset" type='<%=ics.GetVar("assetType") %>' id='<%=ics.GetVar("assetId") %>'/>
	  	<assetset:getattributevalues name="recoAsset" listvarname="bodyList" attribute="Enter_Body_Text" typename="Aeroplane_A"/>
	  	<ics:listloop listname="bodyList">
	  		<ics:listget fieldname="value" listname="bodyList"/><br/>
	  	</ics:listloop>
	  </ics:listloop>
	  	  
	  <vdm:getscalar attribute="sachin_gender" varname="gender_a"/>
	  <ics:getvar name="gender_a"/> : <br/>
	  <vdm:getscalar attribute="sachin_age" varname="age_a"/>
	  <ics:getvar name="age_a"/>	 
</cs:ftcs>
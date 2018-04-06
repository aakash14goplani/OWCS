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
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
		<ics:else>
			<ics:logmsg msg="Hello Sachin"/>
			<%
				ics.LogMsg("TID Value : " + ics.GetVar("tid"));
			 %>
		</ics:else>
	</ics:if>

	<ics:clearerrno/>
	<assetset:setasset name="flexAsset" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>'/>
	
	<assetset:getattributevalues name="flexAsset" listvarname="pilotList" attribute="pilot" typename="Aeroplane_A"/>
	<ics:listloop listname="pilotList">
		Pilot : <ics:listget fieldname="value" listname="pilotList"/> <br/>
	</ics:listloop>
	
	<assetset:getattributevalues name="flexAsset" listvarname="bodyList" attribute="Enter_Body_Text" typename="Aeroplane_A"/>
	<ics:listloop listname="bodyList">
		CkEditor : <ics:listget fieldname="value" listname="bodyList"/> <br/>
	</ics:listloop>
	
	<assetset:getmultiplevalues name="flexAsset" prefix="asset">
		<assetset:sortlistentry attributetypename="Aeroplane_A" attributename="Trip"/>
		<assetset:sortlistentry attributetypename="Aeroplane_A" attributename="seats"/>
	</assetset:getmultiplevalues>
	<ics:listloop listname="asset:Trip">
		Trip : <ics:listget fieldname="value" listname="asset:Trip"/><br/>
	</ics:listloop>
	<ics:listloop listname="asset:seats">
		Seats : <ics:listget fieldname="value" listname="asset:seats"/><br/>
	</ics:listloop>
	
	Error : <ics:geterrno/>
	
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
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
	<%-- Load Asset --%>
	<assetset:setasset name="blobService" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>' />
	<assetset:getattributevalues name="blobService" typename="HIG_MultiMedia_A" listvarname="image_list" attribute="image_blob"/>
	<assetset:getattributevalues name="blobService" typename="HIG_MultiMedia_A" listvarname="file_list" attribute="file_upload"/>
	<ics:if condition='<%=ics.GetList("image_list") != null &&  ics.GetList("image_list").hasData()%>'>
		<ics:then>
			<ics:setvar name="i" value="1"/>
			<ics:listloop listname="file_list">
				<ics:listget fieldname="value" listname="file_list" output="image_file_value"/>
				<blobservice:gettablename varname="tablename"/> 
				<blobservice:getidcolumn varname="columnID"/>
				<blobservice:geturlcolumn varname="columnURL"/>
				<render:getbloburl outstr="image_url" blobtable='<%=ics.GetVar("tablename") %>' blobwhere='<%=ics.GetVar("image_file_value") %>' blobkey='<%=ics.GetVar("columnID") %>' blobcol='<%=ics.GetVar("columnURL") %>' />
				url : <a href="<ics:getvar name='image_url'/>"> <ics:getvar name="i" /> </a> <br/>
				<ics:setvar name="i" value='<%=ics.GetVar("i")+1 %>'/>
			</ics:listloop>			
		</ics:then>
		<ics:else>
			<ics:logmsg msg="Image List Empty"/>
		</ics:else>
	</ics:if>
</cs:ftcs>
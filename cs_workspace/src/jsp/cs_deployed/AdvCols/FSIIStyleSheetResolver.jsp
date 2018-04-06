<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="property" uri="futuretense_cs/property.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
%>
<cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<%-- Load the recommendation, display the title and return "max" entries. --%>
<asset:load name='currentAsset' type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' deptype='exists'/>
<asset:get name='currentAsset' field='name' output='reconame'/>
<commercecontext:getrecommendations collection='<%=ics.GetVar("reconame")%>' maxcount='<%=ics.GetVar("max")%>' listvarname="assetlist"/>
<ics:if condition='<%=ics.GetList("assetlist",false)!=null && ics.GetList("assetlist",false).hasData()%>'>
<ics:then>
	<ics:if condition='<%="1".equals(ics.GetVar("max")) || ics.GetList("assetlist").numRows() == 1%>'>
	<ics:then> 
		<ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
		<ics:listget listname="assetlist" fieldname="assettype" output="assettype"/>

		<listobject:create name="inputListName" columns="assetid,assettype" />
			<listobject:addrow name="inputListName">
			<listobject:argument name="assetid" value='<%=ics.GetVar("assetid")%>' />
			<listobject:argument name="assettype" value='<%=ics.GetVar("assettype")%>' />
		</listobject:addrow>
		<listobject:tolist name="inputListName" listvarname="assetInputList" />
		<asset:filterassetsbydate inputList="assetInputList" outputList="assetOutputList" date='<%=ics.GetSSVar("__insiteDate")%>' />

			<ics:if condition='<%=ics.GetList("assetOutputList")!=null && ics.GetList("assetOutputList").hasData()%>' >
			<ics:then>
				<ics:listget listname="assetOutputList" fieldname="assetid" output="assetid" />
				<ics:listget listname="assetOutputList" fieldname="assettype" output="assettype" />					
				
				<render:lookup key="StyleSheetAttrName" varname="StyleSheetAttrName" />
				<render:lookup key="StyleSheetAssetType" varname="StyleSheetAssetType" />

				<blobservice:gettablename varname="styleTable"/>
				<blobservice:getidcolumn varname="styleCol"/>
			
				<ics:if condition='<%=ics.GetVar("File") != null%>'>
				<ics:then>
					<render:getbloburl
						outstr="styleurl"
						blobtable='<%=ics.GetVar("assettype")%>'
						blobkey='<%=ics.GetVar("styleCol")%>'
						blobwhere='<%=ics.GetVar("assetid")%>'
						blobcol='<%=ics.GetVar("StyleSheetAttrName")%>'
						blobheader="text/css"
						blobnocache="false" />						
					<link rel="stylesheet" media="all" href="<ics:getvar name="styleurl"/>" type="text/css" />
				</ics:then>
				</ics:if>
			</ics:then>
			</ics:if>
	</ics:then>
	<ics:else>

		<listobject:create name="inputListName" columns="assetid,assettype" />
		<ics:listloop listname="assetlist" maxrows='<%=ics.GetVar("max")%>'>
			<ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
			<ics:listget listname="assetlist" fieldname="assettype" output="assettype"/>					
			<listobject:addrow name="inputListName">
				<listobject:argument name="assetid" value='<%=ics.GetVar("assetid")%>' />
				<listobject:argument name="assettype" value='<%=ics.GetVar("assettype")%>' />
			</listobject:addrow>
		</ics:listloop>					
		<listobject:tolist name="inputListName" listvarname="assetInputList" />				
		<asset:filterassetsbydate inputList="assetInputList" outputList="assetOutputList" date='<%=ics.GetSSVar("__insiteDate")%>' />		
		<render:lookup key="StyleSheetAttrName" varname="StyleSheetAttrName" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
		<render:lookup key="StyleSheetAttrType" varname="StyleSheetAssetType" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
		<blobservice:getidcolumn varname="styleCol"/>			
		<ics:if condition='<%=ics.GetList("assetOutputList")!=null && ics.GetList("assetOutputList").hasData()%>' >
		<ics:then>
			<ics:listget listname="assetOutputList" fieldname="#numRows" output="numrows" />
			<ics:listloop listname="assetOutputList">					
				<ics:listget listname="assetOutputList" fieldname="assetid" output="assetid" />
				<ics:listget listname="assetOutputList" fieldname="assettype" output="assettype" />
				<asset:load name="currentStyleSheet" type='<%=ics.GetVar("assettype")%>' field="id" value='<%=ics.GetVar("assetid")%>' />
				<asset:get name="currentStyleSheet" field='<%=ics.GetVar("StyleSheetAttrName")%>' output="File" />
				<asset:get name="currentStyleSheet" field="name" output="stname" />
				<ics:if condition='<%=ics.GetVar("File") != null%>'>
				<ics:then>
					<render:getbloburl
						outstr="styleurl"
						field='<%=ics.GetVar("StyleSheetAttrName")%>'
						c='<%=ics.GetVar("assettype")%>' cid='<%=ics.GetVar("assetid")%>'
						blobheader="text/css"
						blobnocache="false" />
					<link rel="stylesheet" media="all" href="<ics:getvar name="styleurl"/>" type="text/css" />
				</ics:then>
				</ics:if>
			</ics:listloop>
		</ics:then>
		</ics:if>
	</ics:else>
	</ics:if>
</ics:then>
</ics:if>
</cs:ftcs>

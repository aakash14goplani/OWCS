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
	
	<asset:load name="Collection" type='<%=ics.GetVar("c") %>' objectid='<%=ics.GetVar("cid") %>' site='<%=ics.GetVar("site") %>'/>
	<asset:children name="Collection" list="queryList"/>
	<asset:scatter name="Collection" prefix="asset"/>
	
	<table>
	<%
	    String subtype = ics.GetVar("asset:subtype");
	    out.println("Subtype : " + subtype + "<br/>");
	    IList list = ics.GetList("queryList");
	    int rows = list.numRows();
	    int cols = list.numColumns();
	    String columnName = "", columnValue = "";
	    out.println("Rows : " + rows + ", " + "Columns : " + cols + " for list " + list.getName() + " : " + list.hasData() + "<br/>");
	    for(int i=1; i<=rows; i++){
	        for(int j=0; j<cols; j++){
	            //out.println("Is " + list.currentRow() + " last row : " + list.atEnd() + "<br/>");
	            columnName = list.getColumnName(j);
	            columnValue = list.getValue(columnName);
	%>
				<tr>
					<th><%=columnName %></th>
					<td><%=columnValue %></td>
				</tr>
	<%
	            //out.println(columnName + " : " + columnValue + "<br/>");
	            list.moveTo(i+1);
	        }
	    }
	%>
	</table>
	
	<ics:listget fieldname="oid" listname="queryList" output="asset_id"/>
	<ics:listget fieldname="otype" listname="queryList" output="asset_type"/>
	<ics:listget fieldname="ncode" listname="queryList" output="association"/>
	
	asset_id : <ics:getvar name="asset_id"/><br/>
	asset_type : <ics:getvar name="asset_type"/><br/>
	association : <ics:getvar name="association"/><br/>
	
	<asset:load name="QueryAsset" type='<%=ics.GetVar("asset_type")%>' objectid='<%=ics.GetVar("asset_id")%>'/>
	<asset:scatter name="QueryAsset" prefix="query"/>
	Database SQL : <ics:getvar name="query:sqlquery"/> <br/>
	Element Name : <ics:getvar name="query:element" output="targetElement"/> <br/><br/>
	<ics:callelement element='<%=ics.GetVar("targetElement") %>'/>
	
	<%-- <ics:callelement element="OpenMarket/Xcelerate/AssetType/Query/ExecuteQuery">
		<ics:argument name="list" value="ExecuteQueryList"/>
		<ics:argument name="assetname" value="QueryAsset"/>
		<ics:argument name="ResultLimit" value="-1"/>
	</ics:callelement>
	<ics:if condition='<%=null != ics.GetList("ExecuteQueryList") && ics.GetList("ExecuteQueryList").hasData() %>'>
		<ics:then>
			<ics:listloop listname="ExecuteQueryList">
				List Result : <ics:listget fieldname="name" listname="ExecuteQueryList"/>
			</ics:listloop>
		</ics:then>
	</ics:if> --%>	
	<%-- <ics:if condition='<%=ics.IsElement(ics.GetVar("query:element")) %>'>
		<ics:then>
			<ics:callelement element='<%=ics.GetVar("query:element") %>'>
				<ics:argument name="table" value='<%=subtype %>'/>
			</ics:callelement>
		</ics:then>
		<ics:else>
			<ics:sql table='<%=subtype%>' listname="voidList" sql='<%=ics.GetVar("query:sqlquery") %>'></ics:sql>
			<table>
			<%
			    IList list2 = ics.GetList("voidList");
			    int rows2 = list2.numRows();
			    int cols2 = list2.numColumns();
			    String columnName2 = "", columnValue2 = "";
			    out.println("Rows : " + rows2 + ", " + "Columns : " + cols2 + " for list " + list2.getName() + " : " + list2.hasData() + "<br/>");
			    for(int i=1; i<=rows2; i++){
			        for(int j=0; j<cols2; j++){
			            //out.println("Is " + list.currentRow() + " last row : " + list.atEnd() + "<br/>");
			            columnName2 = list2.getColumnName(j);
			            columnValue2 = list2.getValue(columnName2);
			%>
						<tr>
							<th><%=columnName2 %></th>
							<td><%=columnValue2 %></td>
						</tr>
			<%
			            //out.println(columnName + " : " + columnValue + "<br/>");
			            list2.moveTo(i+1);
			        }
			    }
			%>
			</table>  
		</ics:else>
	</ics:if> --%>
</cs:ftcs>
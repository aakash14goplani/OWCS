<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
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
		String table = ics.GetVar("table");
		String sql = "Select COUNT(*) as VoidAssets from " + table + " where status = 'VO'";
		out.println("PUBID : " + ics.GetSSVar("pubid"));
	%>
	<ics:sql table='<%=table%>' listname="voidList" sql='<%=sql %>'></ics:sql>
	<table>
	<%
	    IList list2 = ics.GetList("voidList");
	    int rows2 = list2.numRows();
	    int cols2 = list2.numColumns();
	    String columnName2 = "", columnValue2 = "";
	    out.println("Rows : " + rows2 + ", " + "Columns : " + cols2 + " for list " + list2.getName() + " : " + list2.hasData() + "<br/>");
	    for(int i=1; i<=rows2; i++){
	        for(int j=0; j<cols2; j++){
	            columnName2 = list2.getColumnName(j);
	            columnValue2 = list2.getValue(columnName2);
	%>
				<tr>
					<th><%=columnName2 %></th>
					<td><%=columnValue2 %></td>
				</tr>
	<%
	            list2.moveTo(i+1);
	        }
	    }
	%>
	</table>
</cs:ftcs>
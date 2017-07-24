<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><% 
/******************************************************************************************************************************
   *    Element Name        :  List 
   *    Author              :  Aakash Goplani 
   *    Creation Date       :  (10/06/2017) 
   *    Description         :  Element to loop the list using API.
   *    Input Parameters    :  Variables required by this Element 
   *                            1. output_as_variable : output list details in tabular format or display them in key : value
   *													format (optional : defaults to key : value pair)
   *							2. list : name of list (required)
   *    Output              :  list details
 *****************************************************************************************************************************/
%><cs:ftcs>
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
	</ics:if><%
	String getList = ics.GetVar("list");
	boolean flag = (Utilities.goodString(ics.GetVar("output_as_variable")) && "true".equalsIgnoreCase(ics.GetVar("output_as_variable"))) ? true : false;
	if(Utilities.goodString(getList)){
		IList list = ics.GetList(getList);
		if(list != null  &&  list.hasData()){
			int rows = list.numRows();
			int cols = list.numColumns();
			String columnName = "", columnValue = "";
			out.println("Rows : " + rows + ", " + "Columns : " + cols + " for list " + list.getName() + "<br/>");
			if(!flag){%>
				<table border="1"><%
			}
			for(int i=1; i<=rows; i++){
				if(!flag){%>
					<tr><%
				}
			    for(int j=0; j<cols; j++){
			        columnName = list.getColumnName(j);
			        columnValue = list.getValue(columnName);
			        if(!flag){%>
						<th><%=columnName %></th>
				        <td><%=columnValue %></td><%
					}
					else{
						out.println("Is " + list.currentRow() + " last row : " + list.atEnd() + "<br/>");
						out.println(columnName + " : " + columnValue + "<br/>");
						ics.SetVar(columnName, columnValue);
					}
			        list.moveTo(i+1);
			    }
			    if(!flag){%>
					</tr><%
				}
			}
		} else{
			out.println("List hasData : " + list.hasData() + "<br/>");
		}
	}else{
		out.println("Null List passed : " + getList + "<br/>");
	}
	if(!flag){%>
		</table><%
	}%>
</cs:ftcs>
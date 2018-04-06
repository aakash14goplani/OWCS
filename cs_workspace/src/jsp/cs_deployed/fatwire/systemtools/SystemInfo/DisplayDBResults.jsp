<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="time" uri="futuretense_cs/time.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/systemtools/SystemInfo/DisplayDBResults
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.cs.systemtools.systeminfo.DBInfo"%>
<cs:ftcs>
<div class="width-outer-70">
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
	String ini_path = application.getInitParameter("inipath");
%>
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/content.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/publish.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css,publish.css"/>
</ics:callelement>
<script language="JavaScript">
function toggleVisibility(id) {
   var theImage =  document.getElementById(id);
   var theRowName = id.replace('1_', '2_'); 
    var theRow = document.getElementById(theRowName);
    if (theRow.style.display=="none") {
        theRow.style.display = "";
        theImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Collapse.gif';
	} else {
        theRow.style.display = "none";
        theImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif';
    }
}
</script>
</HEAD>
<body>

<%

Enumeration<String> eParameters = ics.GetVars();
ArrayList<String> arList = Collections.list(eParameters);
for(String key : arList) {
   if(key.startsWith("sFromDBtables")) {
    String table_type = key.replace("sFromDBtables_","");
   %>
   <h3><xlat:stream key='<%="fatwire/SystemTools/SystemInfo/DBInfo/"+ table_type %>' /></h3>
   <table BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr> 
			    <td></td>
			    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
			<tr>
				<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
			<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
				<tr><td colspan="17" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				<tr>
					<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' />&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
						<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/table_name" />  
						</DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
						<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/Primary_key" />  
						</DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
					<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/number_of_rows" /></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
					<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/csz" />  
					</DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
					<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/timeout" />  
					</DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
					<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/abs" />  
					</DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
					<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/TimeTORunSQL" />  
					</DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
					<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/tablekey" />  
					</DIV>
					</td>
					<td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;
					</td>
					</tr>
				<tr>
					<td colspan="17" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				<%
					String value = ics.GetVar(key);
					String[] tables = value.split(";");
					int i=0;
					ArrayList<DBInfo.DBTableInfo> dbTablesInfo = DBInfo.getTablesInfo(ics,Arrays.asList(tables));
					for(DBInfo.DBTableInfo tableInfo : dbTablesInfo ) {
					i++;
					boolean isTableAccessible = tableInfo.getRowCount() != -1;
					String tableName = tableInfo.getTableName();
				%>
					<% if(i%2 == 0) { %>
						<tr class="tile-row-normal">
						<%} else { %>
						<tr class="tile-row-highlight">
					<% } %>
					<td ><% if(isTableAccessible) { %><img id='<%="1_" + tableName %>' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif'
							onClick="javascript:toggleVisibility('<%="1_" + tableName %>');" style="vertical-align:middle;" /><%} %></td>
					<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
						<DIV class="small-text-inset">
							<string:stream value='<%=tableName%>'/>
						</DIV>
					</td>
					<td><br/></td>
					<%if(!isTableAccessible){ %>
					<td VALIGN="TOP" ALIGN="LEFT" ><DIV class="small-text-inset">
					<xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/ErrorDatabaseProblem"/>
					</DIV>
					</td>
					<%}else{ %>
					<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
						<DIV class="small-text-inset"><%=tableInfo.getPrimaryKey()%></DIV>
					</td>
					<%} %>
					<td><br/></td>
						<td VALIGN="TOP" ALIGN="LEFT" >
						<DIV class="small-text-inset">
							<%=isTableAccessible ?  tableInfo.getRowCount(): " " %>
						</DIV>
					</td>
			<td>
				<br/>
			</td>
			<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
				<DIV class="small-text-inset"><%= isTableAccessible ?  DBInfo.getProperty(ics,"cc."+tableName+"CSz") : "" %></DIV>
			</td>
			<td>
				<br/>
			</td>
			<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
				<DIV class="small-text-inset"><%= isTableAccessible ? DBInfo.getProperty(ics,"cc."+ tableName+"Timeout"):"" %></DIV>
			</td>
			<td>
				<br/>
			</td>
			<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
				<DIV class="small-text-inset"><%= isTableAccessible ? DBInfo.getProperty(ics,"cc."+ tableName+"Abs") : "" %></DIV>
			</td>
			<td><br/></td>
			<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
				<DIV class="small-text-inset"><%= isTableAccessible ?  "" + tableInfo.getTimeInMillisForCounting() + " ms" :"" %></DIV>
			</td>
			<td><BR/></td>
			<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT" >
				<DIV class="small-text-inset"><%= isTableAccessible ?  DBInfo.getProperty(ics,"cc."+tableName+"Key"):"" %></DIV>
			</td>
			<td><BR/></td>
			</tr>
			<%--<tr><td class="light-line-color" colSpan="17"><img width="1" height="1" src='<%=ics.GetVar("cs_imagedir")%>/Xcelerate/graphics/common/screen/dotclear.gif' complete="complete"/></td>
			</tr>--%>
			<%if( isTableAccessible) { %>
			<tr id='<%="2_" + tableName %>' style="display:none">
			<td NOWRAP="NOWRAP"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/columnInfo" />:&nbsp;</td>
			<td colspan="4">
			<div class="ODPanel" style="margin-top:10px;width:100%">
							<table width="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
											<tr> 
											    <td></td>
											    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
												<td></td>
											</tr>
											<tr>
												<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
											<td>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
														<tr>
															<td colspan="7" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
														</tr>
														<tr>
															<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
															</td>
															
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
																<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/COLNAME"/></DIV>
															</td>
															<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
															<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/COLTYPE" /></DIV>
															</td>
															<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
															<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/COLSIZE" /></DIV>
															</td>
															<td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
														</tr>
														<tr>
															<td colspan="7" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
														</tr>
															<%
																ArrayList<DBInfo.DBTableColumnInfo> columns = tableInfo.getDbColumns();
																int k = 0;
																for(DBInfo.DBTableColumnInfo col :  columns) {
																k++;
																if(k%2 ==0) {
																%>
																<tr class="tile-row-highlight">
																<%} else { %> 
																<tr class="tile-row-normal">	
																<%}%>
																		<td>
																			<br/>
																		</td>
																		<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																				<%=col.getColName()%>
																			</DIV>
																		</td>
																		<td><br/></td>
																		<td VALIGN="TOP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																			<%=col.getColType()%>
																			</DIV>
																		</td>
																		<td><br/></td>
																		<td VALIGN="TOP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																			<%=col.getColSize()%>
																			</DIV>
																		</td>
																		<td><br/></td>
																</tr>
															<%
															}
															%>
														</table>
													</td>
													<td class="tile-dark" VALIGN="top" WIDTH="1">
													<br/>
													</td>
												</tr>
												<tr>
												<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
												</tr>
												<tr>
												<td>
												</td>
												<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
												<td>
												</td>
												</tr>
									</table>
									
						</div>
						</td>
						
			<%-- Here is another inner table for indices--%>
			<%
			ArrayList<DBInfo.IndexInfo> indices = tableInfo.getIndices();
			if(indices.size() !=0 ) 
			{%>
			<td><br/></td>
			<td NOWRAP="NOWRAP"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/indexInfo" />:&nbsp;</td>
			<td colspan="8">
			<div class="ODPanel" style="margin-top:10px;width:100%">
			
							<table width="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
											<tr> 
											    <td></td>
											    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
												<td></td>
											</tr>
											
											<tr>
												<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
											<td>
													<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
														<tr>
															<td colspan="11" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
														</tr>
														<tr>
															<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;
															</td>
															
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
																<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/IndexName"/></DIV>
															</td>
															<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
															<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/IndexType" /></DIV>
															</td>
															<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
															<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/ColumnName" /></DIV>
															</td>
															<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
															<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/OrdinalPosition" /></DIV>
															</td>
															<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
															<td class="tile-b" NOWRAP="NOWRAP" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
															<DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/SystemInfo/DBInfo/Non_Unique" /></DIV>
															</td>
															
															<td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
														</tr>
														<tr>
															<td colspan="11" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
														</tr>
												
															<%
																
																k = 0;
																if(indices.size()!=0)
																for(DBInfo.IndexInfo index :  indices) {
																k++;
															%>
																<%
																if(k%2 ==0) {
																%>
																<tr class="tile-row-highlight">
																<%} else { %> 
																<tr class="tile-row-normal">	
																<%}%>
																		<td>
																			<br/>
																		</td>
																		<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																				<%=index.getIndex()%>
																			</DIV>
																		</td>
																		<td><br/></td>
																		<td VALIGN="TOP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																			<xlat:stream key='<%= "fatwire/SystemTools/SystemInfo/DBInfo/index_type_"+index.getType() %>' />
																			</DIV>
																		</td>
																		<td><br/></td>
																		<td VALIGN="TOP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																			<%=index.getColumnName()%>
																			</DIV>
																		</td>
																		<td><br/></td>
																		<td VALIGN="TOP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																			<%=index.getOrdinalPosition()%>
																			</DIV>
																		</td>
																		<td><br/></td>
																		<td VALIGN="TOP" ALIGN="LEFT">
																			<DIV class="small-text-inset">
																			<%=index.getNonUnique()%>
																			</DIV>
																		</td>
																		
																		<td><br/></td>
																</tr>
															<%
															}
															%>
														</table>
													</td>
													<td class="tile-dark" VALIGN="top" WIDTH="1">
													<br/>
													</td>
												</tr>
												<tr>
												<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
												</tr>
												<tr>
												<td>
												</td>
												<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
												<td>
												</td>
												</tr>
									</table>
									
						</div>
						</td>
						<%}else{
						%><td colspan='10'><br/></td><%} %>
						<td><br/></td><td><br/></td>
			</tr>
			<%
			
			}
				}
			%>
			
			</table>
			</td>

			<td class="tile-dark" VALIGN="top" WIDTH="1">
			<br/>
			</td>
		</tr>
		<tr>
		<td colspan="9" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<tr>
		<td>
		</td>
		<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		<td>
		</td>
		</tr>
</table>
<br/>
<%
}
}
%>
</body></html>
<%
}else{ %>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%
}
%>
</div>
</cs:ftcs>
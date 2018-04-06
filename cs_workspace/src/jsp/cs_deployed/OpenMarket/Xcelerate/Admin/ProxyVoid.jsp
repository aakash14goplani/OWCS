<%@ taglib prefix="proxy" uri="futuretense_cs/proxy.tld"
%><%@ page import="com.openmarket.xcelerate.asset.ProxyAssetType"
%><%@ page import="com.fatwire.cs.core.db.PreparedStmt"
%><%@ page import="com.fatwire.cs.core.db.StatementParam"
%><%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@page import="com.openmarket.ICS.listloop"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"%>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>

<cs:ftcs>
<ics:getproperty name="xcelerate.batchuser" file="futuretense_xcel.ini" output="batchusername"/>
<ics:getproperty name="xcelerate.batchpass" file="futuretense_xcel.ini" output="batchpassword"/>

<usermanager:loginuser username='<%=ics.GetVar("batchusername")%>' password='<%=Utilities.decryptString(ics.GetVar("batchpassword"))%>' varname="loggedIn" />
<ics:if condition='<%="true".equalsIgnoreCase(ics.GetVar("loggedIn"))%>'>
	<ics:then>

		<assettype:list list="assetTypes">
			<ics:argument name="logic" value="com.openmarket.xcelerate.asset.ProxyAssetType" />
		</assettype:list>

		<ics:listloop listname="assetTypes">
			<ics:listget listname="assetTypes" fieldname="assettype" output="assettype" />
			<%
				//this code assumes that the event is run once everyday at midnight and it must be changed accrordingly if otherwise.
				//the default behaviour(if no argument is provided) is shallow - which means, only the records updated after the last 
				//event runs, are considered. When the argument "deep" is true(&deep=true), all the records are considered for void.   
				String assetType = ics.GetVar("assettype");
				String deep = ics.GetVar("deep");
				String sql_ = null;
				String sql_bookmarks = null;
				if("true".equals(deep)){
					sql_ = "SELECT id FROM "+assetType +" where status!='VO'";
				}
				else
				{
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				    Calendar cal = Calendar.getInstance();
					
					//Change this, if the "times" column in the SystemEvents table changes.
					cal.add(Calendar.DAY_OF_MONTH, -1);
					
					sql_ = "SELECT id FROM "+assetType +" where status!='VO' and updateddate >= '"+dateFormat.format(cal.getTime())+" 00:00:00'";
				}	
			%>

			<ics:sql sql="<%=sql_ %>" listname="assetlist" table="<%=assetType %>" />
			<ics:ifnotempty list="assetlist">
				<ics:then>
					<ics:listloop listname="assetlist">
						<ics:listget listname="assetlist" fieldname="id" output="assetId" />
						<asset:load name="loadedasset" type='<%=ics.GetVar("assettype") %>' objectid='<%=ics.GetVar("assetId")%>'/>
						<asset:referencedby  name="loadedasset" list="referers" embeddedreflist="refersintext"/>
						<ics:ifempty list="referers">
							<ics:then>
								<ics:ifempty list="refersintext">
									<ics:then>
										<%
											sql_bookmarks = "SELECT id FROM ActiveList where assetid="+ics.GetVar("assetId");
										%>
										<ics:sql sql="<%=sql_bookmarks %>" listname="bookmarkslist" table="ActiveList" />
										<ics:ifempty list="bookmarkslist">
											<ics:then>
												<asset:void name="loadedasset"/>
											</ics:then>
										</ics:ifempty>
									</ics:then>
								</ics:ifempty>
							</ics:then>
						</ics:ifempty>
					</ics:listloop>
				</ics:then>
			</ics:ifnotempty>
		</ics:listloop>

		<usermanager:logout />
	</ics:then>
</ics:if>
</cs:ftcs>

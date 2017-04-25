<%@page import="java.util.Arrays"%>
<%@page import="com.fatwire.services.AssetService"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
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
<%!public void shareAsset(IList list, ICS ics, String assetType){
		try{
			Session sessionObject = SessionFactory.getSession();
			ServicesManager serviceHandle = (ServicesManager)sessionObject.getManager(ServicesManager.class.getName());
			AssetService service = serviceHandle.getAssetService();
			int rows = list.numRows();
			int cols = list.numColumns();
			String id = "", name = "", result_list = "";
			boolean isShared = false;
			ics.LogMsg("rows : " + rows + "cols : " + cols);
			
			for(int i=1; i<=rows; i++){
				for(int j=0; j<cols; j++){
					id = list.getValue("id");
					name = list.getValue("name");
					ics.LogMsg(id + " : " + name);
					result_list += id + " : " + name;
		            AssetId assetIdInstance = new AssetIdImpl(assetType,Long.valueOf(id));	
		            List<Long> idList = new ArrayList<Long>();
			        idList.add(Long.valueOf("1374098698899"));
			        idList.add(Long.valueOf("1492586991364"));
			        isShared = service.share(assetIdInstance, idList);
			        ics.LogMsg(isShared + " : " + result_list);
					list.moveTo(i+1);
				}
			}
		}
		catch(Exception e){
			ics.LogMsg("Exception Occured : " + e.getMessage());
		}
	}
%>
<%
	String assetType = "HIG_MultiMedia_C";
	String assetIdList = "";
	String query = "";
	
	try{	
		if(assetType != null && !"".equals(assetType)){
			if(assetIdList != null && !"".equals(assetIdList)){
				for(String assetId : assetIdList.split(",")){
					query = "select asset.id, asset.name from " + assetType + " as asset where asset.id = "+ assetId +" and asset.status != 'VO'";
					out.println(query + "<br/>");
%>
					<ics:sql sql='<%= query %>' table='<%= assetType %>' listname="result_list"/>
<%		
					shareAsset(ics.GetList("result_list"), ics, assetType);
				}
			}				
			else{
				query = "select asset.id, asset.name from " + assetType + " as asset where asset.status != 'VO'";
				out.println(query + "<br/>");			
 %>
		 		<ics:sql sql='<%= query %>' table='<%= assetType %>' listname="result_list"/> 
<%
				shareAsset(ics.GetList("result_list"), ics, assetType);
			}
		}
		else{
			out.println("AssetType not specified!");
		}	
	}
	catch(Exception e){
		out.println("Exception Occured : " + e.getMessage());
	}
 %>
</cs:ftcs>
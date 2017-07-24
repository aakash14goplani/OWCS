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
                   COM.FutureTense.Util.ftErrors,
                   java.io.IOException"
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
<%!
	public void iterateList(IList list, String assetType, ICS ics, JspWriter out) throws IOException{
		String assetId = null;
		try{
			for(int i = 1; i<= list.numRows(); i++){
				list.moveTo(i);
				assetId = list.getValue("id");
				
				FTValList inList = new FTValList();
				inList.put("assetId",assetId);
				inList.put("assetType",assetType);
				if(assetId != null && assetType != null){
					out.println("Calling Asset with ID : "+assetId+" and TYPE : "+assetType+"<br/><br/>");
					ics.CallElement("Risk_Engineering/Logic/GetAssetInfoEJ", inList);	
					out.println("<br/><br/><hr>");
				}
				else
					out.println("Null Asset Id / Type passed in Get Asset from GenerateJSON");	
			}
		}
		catch(Exception e){
			out.println("Exception Occured in method : "+e);
		}
	}
%>
<%
	try{
		for(int index = 1; index <= 2; index++){
			if(index == 1){
%>
				<ics:sql sql="select * from HIG_MultiMedia_C" listname="multimediaAssetsList" table="HIG_MultiMedia_C" />
<%
				IList multimediaAssetList = ics.GetList("multimediaAssetsList");
				iterateList(multimediaAssetList, "HIG_MultiMedia_C", ics, out);				
			}
			if(index == 2){
%>
				<ics:sql sql="select * from HIG_ComponentWidget_C" listname="componentAssetsList" table="HIG_ComponentWidget_C" />
<%
				IList componentAssetsList = ics.GetList("componentAssetsList");
				iterateList(componentAssetsList, "HIG_ComponentWidget_C", ics, out);
			}
		}
	}
	catch(Exception e){
		out.println("Exception Occured in main : "+e);
	}
 %>
</cs:ftcs>
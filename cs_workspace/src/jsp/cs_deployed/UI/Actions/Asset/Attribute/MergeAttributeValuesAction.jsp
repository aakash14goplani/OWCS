<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Actions/MergeAttributeValuesAction
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
<%@ page import="com.fatwire.assetapi.data.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.services.util.JsonUtil"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="org.codehaus.jackson.type.TypeReference"%>
<%@ page import="com.fatwire.assetapi.data.AssetId"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@ page import="com.fatwire.services.ui.beans.UIAssetBean"%>
<%@ page import="com.fatwire.cs.ui.framework.UIException"%>
<%@ page import="com.fatwire.services.ServicesManager"%>
<%@ page import="com.fatwire.system.SessionFactory"%>
<%@ page import="com.fatwire.system.Session"%>
<%@ page import="com.fatwire.assetapi.data.AssetId"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@ page import="com.fatwire.services.AssetService"%>
<%@ page import="com.fatwire.assetapi.data.AttributeData"%>
<cs:ftcs>
<%
	String attributeName = ics.GetVar("attributeName");
	String assetId = ics.GetVar("assetId");
	String isBinary = ics.GetVar("isBinary");
	String assetType = ics.GetVar("assetType");
	
	//get the json data from client and convert to java object
	List<UIAssetBean> modifiedValues = null;
	try
	{
		String jsonData = request.getParameter("toMerge");	   
		TypeReference<List<UIAssetBean>> typeRef =  new TypeReference<List<UIAssetBean>>(){};
		ObjectMapper mapper = new ObjectMapper();
		modifiedValues = mapper.readValue(jsonData, typeRef);
	}
	catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%>

	<ics:callelement element="UI/Actions/Asset/Attribute/GetAttributeValuesAction">
		<ics:argument name="attributeName" value="<%=attributeName%>"/>
		<ics:argument name="assetId" value="<%=assetId %>"/>
		<ics:argument name="assetType" value="<%=assetType %>"/>
		<ics:argument name="isBinary" value="isBinary"/>
	</ics:callelement>

<%
	List values = (List)request.getAttribute("values");

	// iterate values and create UIAssetBean out of it
	List<UIAssetBean> savedValues = new ArrayList<UIAssetBean>();
	for(int i=0; i<values.size(); i++)
	{
		if(values.get(i) instanceof UIAssetBean){
			savedValues.add((UIAssetBean)values.get(i));
		}
	}
	
	try{
		// do the merge of modified list with the saved list
		List<UIAssetBean> mergedValues= new ArrayList<UIAssetBean>();
		
		// get the aset service, as we need to get the name of the asset for the modified values.
	    Session ses = SessionFactory.getSession();        
	    ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());    
	    AssetService assetService = servicesManager.getAssetService();
	    
	    // if the modified values is not null, then take all the non null values of the modified values.	  
		if(modifiedValues != null)
		{
			for(int i=0; i<modifiedValues.size(); i++)
			{
				UIAssetBean bean = modifiedValues.get(i);
			
				if( bean != null)
				{ 
					// as we just have id and type, we need name as well so get it from asset service	
					if(bean.getId() != null && bean.getType() != null){
						AssetId assetIdImpl = new AssetIdImpl(bean.getType(), Long.parseLong(bean.getId()));
						AssetData assetData = assetService.read(assetIdImpl);
						AttributeData attData = assetData.getAttributeData("name");	    		
						String assetName = (String)attData.getData();
						bean.setName(assetName);
						mergedValues.add(bean);
					}
				}
			}
			// if the saved values are more than the modifed values then take the rest of saved values
			// (i.e) the items from saved values starting from index (savedValues.size() - modifiedValues.size()) to savedValues.size()					
			if(savedValues.size() > modifiedValues.size())
			{
				for(int i= modifiedValues.size(); i<savedValues.size(); i++)				
				{
					if(!mergedValues.contains(savedValues.get(i))) {
						mergedValues.add(savedValues.get(i));
					}
				}
			}
		}
	    // if there is no modified values then just take the saved values only.
		else
		{
			for(int i=0; i<savedValues.size(); i++)
			{
				mergedValues.add(savedValues.get(i));
			}		
		}    
		request.setAttribute( "values", mergedValues);
	}catch(UIException e) {
		request.setAttribute(UIException._UI_EXCEPTION_, e);
		throw e;
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}	
%>

</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/AssetMaker/FCKIMAGEPICKER
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
<%@ page import="com.openmarket.gator.interfaces.IAttributeTypeManager"%>
<%@ page import="com.openmarket.gator.interfaces.IPresentationObject"%>
<%@ page import="com.openmarket.assetframework.interfaces.IAssetTypeManager"%>
<%@ page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory"%>

<cs:ftcs>

<!-- user code here -->
			<%
				IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
				ics.SetObj("atmgr", atm.locateAssetManager("AttrTypes"));
				IAttributeTypeManager iam = (IAttributeTypeManager) ics.GetObj("atmgr");
				try
				{
					IPresentationObject presInst = iam.getPresentationObject(ics.GetVar("imagepickerid"));
					String ASSETTYPENAME = presInst.getPrimaryAttributeValue("ASSETTYPENAME");
					String ATTRIBUTETYPENAME = presInst.getPrimaryAttributeValue("ATTRIBUTETYPENAME");
					String ATTRIBUTENAME = presInst.getPrimaryAttributeValue("ATTRIBUTENAME");

					ics.SetVar("ip_assettypename" , ASSETTYPENAME);
					ics.SetVar("ip_attributetypename" , ATTRIBUTETYPENAME);
					ics.SetVar("ip_attributename", ATTRIBUTENAME);
						
				} 
				catch(Exception e)
				{
					%>
					<ics:logmsg severity="warn"
					msg='<%="Cannot locate the imagepicker.Please check the id " + ics.GetVar("imagepickerid")%>'/>
					<%		
				}
			%>
</cs:ftcs>
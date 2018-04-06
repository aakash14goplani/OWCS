<%@ page import="com.openmarket.xcelerate.interfaces.ExternalClientsManagerFactory,
                 com.openmarket.xcelerate.interfaces.IExternalClientsManager,
                 com.openmarket.xcelerate.interfaces.IExternalClientsItem"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%//
// OpenMarket/Gator/FlexibleAssets/FormMode/DMSupported
//
// INPUT
//
// OUTPUT
//%><cs:ftcs><%
	/*
	Load the externalclients entry corresponding to clientid.
	Get the list of assettype columns & attributes values from
	externalclients config table
	*/
    String pubId = ics.GetSSVar("pubid");
    String assetType = ics.GetVar("AssetType");

    IExternalClientsManager iExternalClientsManager = ExternalClientsManagerFactory.make(ics);
    IExternalClientsItem iExternalClientsItem = iExternalClientsManager.loadFromFields(pubId, "CSDocLink", assetType);
    ics.SetVar("DMSupported", String.valueOf(iExternalClientsItem != null));
%></cs:ftcs>
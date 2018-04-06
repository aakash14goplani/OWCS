
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%--
// OpenMarket/Xcelerate/UIFramework/SetDefaultPreviewURL
//
// INPUT

//
// OUTPUT
--%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="com.openmarket.xcelerate.asset.TemplateManager"
%><%@ page import="com.fatwire.cs.mayura.ui.util.AssetUtil"
%><cs:ftcs><%--

	1) Use Site plan tags to load the site plan tree
	2) Find the first placed page
	3) Determine the url to that page
	4) Set the url value in ICS scope so that the calling element can access it

	Modified: Feb 25, 2009  Stream Crafted URL  for
	insite default preview asset

--%><usermanager:getloginusername varname="thisusername"/><%--

Look up translation from LocaleStrings

--%><xlat:lookup key="fatwire/Alloy/UI/InsiteNoAssetPreview"  varname='_TRANSLATE_' escape="true" encode="true"/><%

    // Get the  the Session Publication id
    // String pubid  = ics.GetSSVar("pubid");

    String pubid  = ics.GetSSVar("pubid");

    ics.SetVar("pubid", ics.GetVar("pubid"))  ;
    String assetType = "";
    String assetID   = "" ;
    // This is the Request Variable  url value in ICS scope , that will ultimatly hold the Default Preview Asset URL
    // Used AND passed into Insite Preview Asset
    ics.SetVar("insiteURL",ics.GetVar("_TRANSLATE_")) ;

    boolean isDefaultURL = false ;   // Assunme that Publication field is null or does not exist

%><ics:if condition='<%=ics.GetSSVar("pubid")!=null%>'><ics:then><ics:callelement element='OpenMarket/Xcelerate/UIFramework/SetPubPreviewURL'
    ><ics:argument name="pubid" value="<%=pubid %>"
/></ics:callelement><%

        // This is the Request Variable, that will ultimatly hold the Default Insite Preview Asset
        // Used AND passed into Insite New Window with Default Asset URL 
        String PubPreviewAsset = ics.GetVar("PubPreviewAsset");
        String assetName = "" ;
        boolean isPubPreviewSet = false ;   // Assunme that Publication field is null or does not exist
		
        if(PubPreviewAsset.length() != 0)
        {
             // The Publication default asset Preview field has been set and assigned
             String[] assetParts = PubPreviewAsset.split(":") ;
            
             // Field Parts Value must be in the format  AssetType:AssetID
             if ( assetParts.length == 2 )
             {
                 assetType = assetParts[0] ;
                 assetID = assetParts[1] ;
                 isPubPreviewSet = true ;
             }
        }

%><ics:if condition='<%=isPubPreviewSet%>'
   ><ics:then><%

            // We have default Preview Asset from Publication  Asset Type and ID Lets Craft the URL
            // Set the Url Flag, to craft the URL
            isDefaultURL = true ;

   %></ics:then><ics:else><%

           //    Lets query and consult the Site Plan for default Preview Asset
     %><siteplan:root list="outlist" objectid='<%=ics.GetSSVar("pubid")%>'
       /><ics:if condition='<%=ics.GetErrno()==0%>'
       ><ics:then
            ><ics:listget listname="outlist" fieldname="nid" output="nodeid"
            /><siteplan:load name='siteplannode' nodeid='<%=ics.GetVar("nodeid")%>'
            /><ics:if condition='<%=ics.GetErrno()==0%>'
              ><ics:then
                   ><siteplan:children name='siteplannode' list='placedPages'
                                       code="Placed" order="nrank desc"
                    /><ics:if condition='<%=ics.GetErrno()==0%>'
                      ><ics:then
                          ><ics:listloop listname="placedPages"
                           ><ics:listget listname="placedPages" fieldname="oid" output="assetid"
                           /><ics:listget listname="placedPages" fieldname="otype" output="assettype"
                          /></ics:listloop><%

                              assetType = ics.GetVar("assettype") ;
                              assetID = ics.GetVar("assetid") ;
                              // We have default Preview Asset from Site Plan  Asset Type and ID Lets Craft the URL
                              // Set the Url Flag, to craft the URL
                              isDefaultURL = true ;

%></ics:then></ics:if></ics:then></ics:if></ics:then></ics:if></ics:else></ics:if><%

    //  Has the Default Insite Preview been Set from  Publication or SitePlan
    //  and possibly not set the Send Alert message

%></ics:then><ics:else><%
		ics.SetVar("insiteURL", "Invalid_Session"); // Do not change this error message. This is used to detect the invalid session in csWindowButton.js
%></ics:else></ics:if><ics:if condition='<%=isDefaultURL%>'
    ><ics:then><%

            // Must Use the Request Object Advanced knows nothing about Faces
            // The URL is  crafted using the scheme and ServerName + port + INSITEurl

            StringBuffer buf = new StringBuffer() ;

            buf.append( request.getScheme() );
            buf.append( "://" );
            buf.append( request.getServerName() );
            buf.append( ":" ).append( request.getServerPort() );
      
            String url = AssetUtil.getPreviewURL(  new Long(assetID),assetType,new Long(pubid),
			                                       request.getContextPath() , ics);
            buf.append(url) ;

            ics.SetVar("insiteURL",buf.toString()) ;
    %></ics:then></ics:if><%
    ics.StreamText(ics.GetVar("insiteURL"));
%></cs:ftcs>

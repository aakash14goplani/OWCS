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
                   COM.FutureTense.Util.ftErrors,
                   com.openmarket.gator.interfaces.ITempBlobs,
                   com.openmarket.gator.interfaces.TempBlobsFactory"
%><cs:ftcs><%-- OpenMarket/Gator/FlexibleAssets/Common/saveTempBlobs

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
 <%
try
{
    IList attrValueList = ics.GetList(ics.GetVar("listname"));
    attrValueList.moveToRow(IList.gotorow,Integer.parseInt(ics.GetVar("currrow")));
    byte [] data = attrValueList.getFileData(ics.GetVar("columnname"));
    String filename = ics.GetVar("filename");
    FTVAL valData = FTValMap.newFTVAL(data);

    ITempBlobs tb = TempBlobsFactory.make(ics);
    String blobId = tb.saveTemporaryObject("", filename, valData );
    blobId = tb.getBlobId(blobId);
    ics.SetVar("blobId", blobId);

}
catch(Exception e)
{
    ics.SetVar("blobId","");
}
%>

</cs:ftcs>
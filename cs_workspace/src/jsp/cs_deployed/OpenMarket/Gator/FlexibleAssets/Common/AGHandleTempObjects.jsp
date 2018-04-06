<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="flexasset" uri="futuretense_cs/flexasset.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/AGHandleTempObjects
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
<cs:ftcs>

<!-- Copying an asset...-->
<!-- Since URL/BLOB attributes cannot be posted again, we store their values in the TempObjects
    table and post the ids into that table -->
<%
if (ics.GetVar("myURLAttrs")!=null)
{
    // It looks like myURLAttrs will be posted every time.  So, on a create, this section won't execute.
    // The value of myURLAttrs is apparently a list of attribute identifiers for the URL attributes the
    // asset has.

    ics.SetVar("__POSTED__", "true");

    java.util.StringTokenizer urlattrids = new java.util.StringTokenizer(ics.GetVar("myURLAttrs"), ",");
    String currentURLAttrID = null;
    FTValList vN = new FTValList();

    if (ics.GetVar("__URLInit__")==null)
    {
	// Executed only when not previously posted...

        if (ics.GetVar("id")==null)
	{
            ics.SetVar("id", "");
        }

        if (ics.GetVar("Copyid")!=null)
	{
	    // I suppose this means it's a copy (?)

            if (ics.GetVar("ccsourceid")!=null)
	    {
		// Copying from a given source...
%>
		<asset:load name='sourceinst' type='<%=ics.GetVar("AssetType")%>' field='id' value='<%=ics.GetVar("ccsourceid")%>'/>
<%
                while (urlattrids.hasMoreTokens())
		{
                    currentURLAttrID = urlattrids.nextToken();
		    String vectorName = "v"+currentURLAttrID;
%>
                    <flexasset:getattribute name='sourceinst' id='<%=currentURLAttrID%>' listvarname='<%=currentURLAttrID%>'/>
<%
		    // Write the attribute values into the temp objects table
                    vN = new FTValList();
                    vN.setValString("LIST", currentURLAttrID);
                    vN.setValString("COLUMN", "urlvalue");
                    vN.setValString("LISTVARNAME", "tempids");
                    ics.runTag("tempobjects.setlist", vN);

		    // Create a vector of the temp object id's we just wrote.
                    vN = new FTValList();
                    vN.setValString("NAME", vectorName);
                    vN.setValString("LIST", "tempids");
                    vN.setValString("COLUMN", "id");
                    ics.runTag("vector.create", vN);
                }
            }
	    else
	    {
		// No source to copy from, so initialize vector to being empty.
                while (urlattrids.hasMoreTokens())
		{
                    currentURLAttrID = urlattrids.nextToken();
		    String vectorName = "v"+currentURLAttrID;
                    vN = new FTValList();
                    vN.setValString("NAME", vectorName);
                    ics.runTag("vector.create", vN);
                }
            }
        }
	else
	{
	    // Not a copy (?)
            while (urlattrids.hasMoreTokens())
	    {
			currentURLAttrID = urlattrids.nextToken();
			String vectorName = "v"+currentURLAttrID;
%>
			<flexasset:getattribute name='theCurrentAsset' id='<%=currentURLAttrID%>' listvarname='<%=currentURLAttrID%>'/>
<%
			// Save the current asset's url values in the temporary objects table
			// Dont create tempobjects while this element is called from preupdate
			if (!"true".equalsIgnoreCase(ics.GetVar("isPreUpdate"))) {
                vN = new FTValList();
                vN.setValString("LIST", currentURLAttrID);
                vN.setValString("COLUMN", "urlvalue");
                vN.setValString("LISTVARNAME", "tempids");
                ics.runTag("tempobjects.setlist", vN);

				// Create a vector out of the temporary object id's we just saved.
                vN = new FTValList();
                vN.setValString("NAME", vectorName);
                vN.setValString("LIST", "tempids");
                vN.setValString("COLUMN", "id");
                ics.runTag("vector.create", vN);
			} else {
				vN = new FTValList();
				vN.setValString("NAME", vectorName);
				ics.runTag("vector.create", vN);
			}	
								
        }
		ics.RemoveVar("isPreUpdate");		
	}		
    %>
     <INPUT TYPE="HIDDEN" NAME="__URLInit__" VALUE="done"/>
    <%
    }
%>
   <!-- We only initialize from the asset instance once.  If this is a repost, we want
        to initialize from the posted tempobject ids. -->
<%
    if (ics.GetVar("__URLInit__") != null)
    {
	// This section seems to be executed on all reposts.
	// It looks like there is a variable posted for each url attribute, whose name is the url attribute's id.  This variable
	// is a comma-separated list of temporary object id's.  For the case where a repost is occurring, the temporary object
	// identifiers have to be loaded into the vectors.
  
        while (urlattrids.hasMoreTokens())
		{
            currentURLAttrID = urlattrids.nextToken();
			String vectorName = "v"+currentURLAttrID;

            vN = new FTValList();
            vN.setValString("NAME", vectorName);
            ics.runTag("vector.create", vN);
            /*if (null != ics.GetVar(currentURLAttrID) && !(ics.GetVar(currentURLAttrID).equals("noData")))
            {
                java.util.StringTokenizer tempidTokens = new java.util.StringTokenizer(ics.GetVar(currentURLAttrID), ",");
                while (tempidTokens.hasMoreTokens())
				{
                    vN = new FTValList();
                    vN.setValString("NAME", vectorName);
                    vN.setValString("VALUE", tempidTokens.nextToken());
                    ics.runTag("vector.add", vN);
                }
            }*/
        }
    }
}


%>

</cs:ftcs>
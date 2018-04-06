<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// This element is called by OpenMarket/Xcelerate/ControlPanel/SearchResults
//This is used to construct the search string which is used in the insite editor search
// OpenMarket/Xcelerate/ControlPanel/SearchString
//
// INPUT takes two variable  asset type and string to be searched
//
// OUTPUT this sets the queryend parameter required for the search
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.StringTokenizer" %>
<cs:ftcs>
<%
// get the asset type and the string to be search
String asset_type = ics.GetVar("searchAssetType");
String search_text = ics.GetVar("searchText");
if (search_text == null) search_text = "";
// declare a filed array to be searched here
// If any time more field are required to be search then it has to the part of this array.
String[] fieldnames={ "name","description" } ;

// Create a buffer to parse the string
StringBuffer searchbuffer = new StringBuffer("AND ( ");
StringTokenizer st = new StringTokenizer(search_text, ",");
     if (st.hasMoreTokens()) {
  
       do {
             
             String token = st.nextToken().trim();
                //skip the empty tokens
                while (token.length() == 0 && st.hasMoreTokens())
                    token = st.nextToken().trim();
                  if (token.length() > 0)
            {
                // go over the number of fields
				String searchTerm  = "%" + token.toLowerCase() + "%";
                for ( int numberOfField=0; numberOfField < fieldnames.length ; numberOfField++)
                      {
                    searchbuffer.append("lower(");
                    searchbuffer.append(asset_type);
                    searchbuffer.append(".");
                    searchbuffer.append(fieldnames[numberOfField]);
                    searchbuffer.append(") LIKE ");
                    searchbuffer.append( ics.literal( asset_type, fieldnames[numberOfField], searchTerm ) );
                    if (numberOfField!=fieldnames.length-1)
		{
		 searchbuffer.append(" OR ");
                        }
                   }
                }
          
			} while( st.hasMoreTokens() ? searchbuffer.append(" OR ") != null : false);
		 searchbuffer.append(") AND (");
		}
		
		if (ics.GetVar("flextemplateid") != null)
		{    
			String sub_type = ics.GetVar("flextemplateid");
			if (sub_type.length() != 0 )
			{
				searchbuffer.append(asset_type);
				searchbuffer.append(".");
				searchbuffer.append("flextemplateid");
				searchbuffer.append("=");
				searchbuffer.append(sub_type);
				searchbuffer.append(") AND (");
			}
		}
		searchbuffer.append(asset_type);
		searchbuffer.append(".externaldoctype is NULL)");
		searchbuffer.append(" ORDER BY ");
		searchbuffer.append(asset_type);
		searchbuffer.append(".");
       // Make sure you are search on the name field of the asset type
        searchbuffer.append(fieldnames[0]);
       ics.SetVar("queryend",searchbuffer.toString());

%>

<!-- user code here -->

</cs:ftcs>
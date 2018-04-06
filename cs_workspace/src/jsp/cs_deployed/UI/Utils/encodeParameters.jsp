<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%
//
// UI/Utils/encodeParameters
//
// Reason 
//    filters and cleans request input parameters 
//
//
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<cs:ftcs>
<% 
final ICS _ics = ics;
List<String>list=null ;  

// Get the list of parameters that are not
// required to be filtered and/or cleaned 
String excludeLst = ics.GetVar("excludeParametersLst");
if ( excludeLst != null ) {
 list = Arrays.asList(excludeLst.split(","))  ;
}

// Get the Request's Input properties/parameters Map
Map inputParams = request.getParameterMap(); 
if (inputParams != null) {	
	Iterator iter = inputParams.keySet().iterator();    
	while (iter.hasNext()) 
	{
			// get the parameter name by key 
		    String key = (String) iter.next();    
		    // get the array of String values by key/name 
			String[] values = (String[]) inputParams.get(key);  
		    // save for mv..
			String mv = null ; 			
		    // clean / encode each String value(s) 				
		    for (int i = 0; i < values.length; i++)   {  
  			  if ( list != null && list.contains(key) ) 
  				break ;    // Exclude from filtering and move to next parameter key ; 
   			  values[i] = GenericUtil.cleanString(values[i]);  
   			  mv = ( i == 0 ) ? values[0] : mv+";"+values[i] ; 
		    }  	
		    
			// then assign to ics variable / parameter 
			if ( mv != null ) {
			    // Assign also into ics variable..
			 	ics.SetVar(key, mv); 
			}
     } 
 }	
	
%>
</cs:ftcs>
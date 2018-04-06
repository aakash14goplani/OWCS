<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/Util/FixBLOBList
//
// INPUT
//   cs_ListToReplace
//   cs_Ordinal
//   EditingStyle
//   UploadDir
// OUTPUT
//   list named Variables.cs_ListToReplace
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.FTVAL" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage" %>
<%@ page import="com.openmarket.basic.interfaces.IListBasic" %>
<%@ page import="java.util.*" %>
<cs:ftcs>
<%
/*
 If the listOrder is passed, then we need to prepare a java map
 and then later use it, to find the correct index of an item.
*/
IListBasic attrvals = (IListBasic) ics.GetList(ics.GetVar("cs_ListToReplace"));
String listOrder = ics.GetVar("listOrder");
Map<String,Integer> idsOrderMap = null;
boolean isListOrderGoodString = Utilities.goodString(listOrder);
if(isListOrderGoodString)
{
	String[] idsWithOrder = listOrder.split(",");
	idsOrderMap = new HashMap<String,Integer>();
	for(String idOrder : idsWithOrder)
	{
		String[] idOrderAr = idOrder.split(":");
		idsOrderMap.put(idOrderAr[0],Integer.parseInt(idOrderAr[1]));
	}
}

com.openmarket.gator.common.BLOBList fixedBLOBList = new com.openmarket.gator.common.BLOBList(attrvals.numRows());
String sCurrentOrdinal = null;

//SDS START

//Make easy lookup ID to urlvalue
HashMap map = new HashMap();
HashMap contentsMap = new HashMap();
do {
  map.put(attrvals.getValue("id"),attrvals.getValue("urlvalue"));
  contentsMap.put(attrvals.getValue("id"),attrvals.getFileContents("urlvalue"));
} while (attrvals.moveToRow(IList.next,0));

IList ids = ics.GetList(ics.GetVar("cs_ListToReplace"));
ids.moveTo(0);
do {
  String id = ids.getValue("id");
  String urlvalue = (String)map.get(id);
	
  if ("O".equals(ics.GetVar("EditingStyle")) || "multiple-ordered".equals(ics.GetVar("EditingStyle")) ){
	  
	  if(isListOrderGoodString)
	  {
		  //find the correct index to check based on idsOrderMap.
		  sCurrentOrdinal = ics.GetVar("cs_"+ics.GetVar("n")+"_ordinal_"+String.valueOf(idsOrderMap.get(id)));
	  }
	  else
	  {
	      sCurrentOrdinal = ics.GetVar("cs_"+ics.GetVar("n")+"_ordinal_"+String.valueOf(ids.currentRow()));
	      if (sCurrentOrdinal == null)
	      {  
	          sCurrentOrdinal = String.valueOf(ids.currentRow());
	      }
	  }
  } else {
     sCurrentOrdinal = "";
  }
  
%>
  <ics:callelement element='OpenMarket/Xcelerate/Util/GetBLOBFolder'>
    <ics:argument name='cs_GBF_filename' value='<%=urlvalue%>'/>
    <ics:argument name='varname' value='cs_GBF_folder'/>
  </ics:callelement>
<%
  String folderToUse = ics.GetVar("cs_GBF_folder");
  String uploadDir = ics.GetVar("UploadDir");
  if (uploadDir != null && uploadDir.length() > 0)
  {
	folderToUse = uploadDir;
  }
  fixedBLOBList.setRow(ids.currentRow()-1,
                       urlvalue,
                       folderToUse,
                       sCurrentOrdinal,
                       (FTVAL)contentsMap.get(id));
} while (ids.moveToRow(IList.next,0));
//SDS END
ics.RegisterList(ics.GetVar("cs_ListToReplace"), fixedBLOBList);
%>
</cs:ftcs>

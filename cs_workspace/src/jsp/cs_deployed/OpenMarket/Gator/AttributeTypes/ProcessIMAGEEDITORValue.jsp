<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%>
<%//
// OpenMarket/Gator/AttributeTypes/ProcessIMAGEEDITORValue
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
<%@ page import="com.openmarket.gator.interfaces.IPresentationObject" %>
<%@ page import="com.openmarket.gator.interfaces.IPresentationElement"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Vector"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.interfaces.ITempObjects"%>
<%@ page import="com.openmarket.xcelerate.interfaces.TempObjectsFactory"%>
<%@ page import="com.openmarket.gator.blobservice.BlobService"%>
<%@ page import="COM.FutureTense.Interfaces.FTVAL"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="com.fatwire.util.BlobUtil"%>
<%@ page import="com.openmarket.xcelerate.common.TempObjects"%>
<%!

private final Map<String, String> getQryMap(String url) 
{
	// /cs/BlobServer?blobcol=urldata&blobtable=MungoBlobs&csblobid=1316668710205&blobkey=id&blobwhere=1316668710129
	Map<String, String> qryMap = new HashMap<String, String>();
	if (null == url) return qryMap;
	String[] params = url.substring(url.indexOf('?') + 1).split("&");

	for (String param : params) 
	{
		int indexOfEqual = param.indexOf('=');
		if (indexOfEqual == -1) continue;
		qryMap.put(param.substring(0, indexOfEqual), param.substring(indexOfEqual + 1));
	}
	return qryMap;
}

%>
<cs:ftcs>

<%
String urlValue = ics.GetVar("currentUrlValue");
String fileName = "", 
	   folder = "",
	   pagename = ics.GetVar("pagename"),
	   encodeImageUrl = "",
	   imageUrl = "";
byte[] fileData = null;
boolean isPosted = "true".equals(ics.GetVar("__POSTED__"));
boolean isSingleValued = "single".equalsIgnoreCase(ics.GetVar("EditingStyle"));

String attributeId = null;
IList tmplattrlist = ics.GetList("tmplattrlist");

if (tmplattrlist != null) 
{
    int moveToRow = Integer.parseInt(ics.GetVar("tmplattrlistIndex"));
	tmplattrlist.moveTo(moveToRow);
	attributeId = tmplattrlist.getValue("assetid");
}

String emptyImageUrl=ics.GetVar("cs_imagedir")+"/graphics/common/logo/spacer.gif";
String uriPrefix = "/"+ics.GetVar("cgipath").replace("/","")+"/";

String codebase = ics.GetVar("basepath");
if (!Utilities.goodString(codebase))
	codebase = uriPrefix + "ImageEditor/clarkii/";
else if (codebase.indexOf(uriPrefix.replace("/", "")) == -1) {
	codebase = uriPrefix + codebase;
}

StringBuilder str = new StringBuilder();
for (int i = 0; i < codebase.length() - 1; i++) 
{
	if (codebase.charAt(i) == '/')
		str.append("../");
}

String currentInput = ics.GetVar("cs_CurrentInputName");

if (!isSingleValued)
	currentInput = currentInput + "_" + ics.GetCounter("MultiValCounter");


if (urlValue != null)
{
   	int last = urlValue.lastIndexOf(java.io.File.separator);
	fileName = urlValue.substring(last + 1);
    fileData = ics.GetBin("currentUrlFileValue");                
	folder = ics.GetVar("currentFolder");
	
	if (isPosted && !pagename.endsWith("Post"))
	{
		Vector temporaryIds = (Vector)ics.GetObj("v" + attributeId);                    
        if (temporaryIds != null)
    	{
           	for (int i = 0; i < temporaryIds.size(); i++)
			{
               	String currentId = (String)temporaryIds.get(i);
%>
				
			<ics:sql sql='<%="select urldata from TempObjects where id=" + currentId%>' listname="tmpUrlValueList" table="TempObjects" />
				
<%
				IList tmpUrlValueList = ics.GetList("tmpUrlValueList");
				String tmpUrlValue = null;
				
				if (tmpUrlValueList != null)
                  		tmpUrlValue = tmpUrlValueList.getValue("urldata");
				
				if (tmpUrlValue != null && tmpUrlValue.equals(urlValue))
	    		{
					ics.SetVar("blobwhere", currentId);
                      ics.SetVar("blobtable", "TempObjects");
					ics.SetVar("blobcol", "urldata");
					ics.SetVar("blobkey", "id");
					break;
				}
			}
		}
	}
	else
	{
%>
		<blobservice:getidcolumn varname="blobkey" />
		<blobservice:geturlcolumn varname="blobcol" />
		<blobservice:gettablename varname="blobtable" />
<%
		if ("OpenMarket/Xcelerate/Actions/CopyFront".equals(pagename) || "OpenMarket/Xcelerate/Actions/TranslateFront".equals(pagename))
		{
%>
			<assetset:setasset name="as" type='<%=ics.GetVar("AssetType")%>' id='<%=ics.GetVar("Copyid")%>'/>
<%
		}
		else
		{
%>
			<assetset:setasset name="as" type='<%=ics.GetVar("AssetType")%>' id='<%=ics.GetVar("id")%>'/>
<%
		}
%>
		<assetset:getattributevalues name="as" typename='<%=ics.GetVar("attributetype")%>' attribute='<%=ics.GetVar("AttrName")%>' listvarname="blobidlist" />
		<ics:listloop listname="blobidlist">
			<ics:listget listname="blobidlist" fieldname="value" output="blobid" />
			<blobservice:readdata id='<%=ics.GetVar("blobid")%>' listvarname="bloburldatalist" />
			<ics:listget listname="bloburldatalist" fieldname="urldata" output="bloburldata"/>
<%
			if (urlValue != null && urlValue.equals(ics.GetVar("bloburldata")))
			{
				ics.SetVar("blobwhere",ics.GetVar("blobid"));
			}
%>
		</ics:listloop>                    
<%
	}
%> 
	<satellite:blob assembler="query"
		blobtable='<%=ics.GetVar("blobtable")%>'
		blobkey='<%=ics.GetVar("blobkey")%>'
		blobwhere='<%=ics.GetVar("blobwhere")%>'
		blobcol='<%=ics.GetVar("blobcol")%>'
		csblobid='<%=ics.GetSSVar("csblobid")%>'
		blobnocache='true'
		outstring="imageurl"/>                             
<%                
	imageUrl = ics.GetVar("imageurl");
}

/*    
		if (!isSingleValued)
		{
		    int currentRowNb = (attributeValueList == null ? 0 : attributeValueList.currentRow()); // [1..nb of values currently stored]
			int valueCounter = ics.GetCounter("TCounter"); // [1..nb of values currently on form]
					
		    if (valueCounter > currentRowNb)
		    {
				fileName = "";
				imageUrl = null;
			}
			
		}
*/

if (null != imageUrl) 
{
	encodeImageUrl = imageUrl + "&oieloadpicture=" + fileName;
	encodeImageUrl = encodeImageUrl.replace("&", "%26");
	//encodeImageUrl=baseUri+encodeImageUrl;
} 
else 
{
	encodeImageUrl = emptyImageUrl;
}

//TODO: prepend relative path (calculated from codebase above) to encodeImageUrl
encodeImageUrl=str.substring(0,str.length()-1).toString()+encodeImageUrl;

StringBuilder tmpVal = new StringBuilder("");
		// Create tempval
		
if (null != ics.GetVar("imageurl")) 
{
	Map<String, String> qryMap = getQryMap((String) ics.GetVar("imageurl"));
	ITempObjects we = TempObjectsFactory.make(ics);
	String tempObjId = "01";
	String fileType = BlobUtil.getContentTypeFromName(ics, fileName);
	tempObjId = qryMap.get("blobwhere");
	
	// /cs/BlobServer?blobcol=urldata&blobtable=MungoBlobs&csblobid=1315374993747&blobkey=id&blobwhere=1315374993657
	tmpVal.append("{'filename': '" + fileName + "',");
	tmpVal.append("'tempObjectId': '" + qryMap.get("blobwhere") + "',");
	tmpVal.append("'blobURL': '" + (String) ics.GetVar("imageurl") + "',");

	if (Utilities.goodString(fileType) && fileType.contains("image")) 
	{
%>
		<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/DetermineImageDimensions'>
			<ics:argument name='listname' value='AttrValueList'/>
			<ics:argument name='columnname' value='urlvalue'/>
			<ics:argument name='currrow' value='<%= String.valueOf(ics.GetCounter("MultiValCounter")) %>'/>
		</ics:callelement>
<%
		tmpVal.append("'dimension': '" + ics.GetVar("ImageDimensions") + " pixels',");
	}
	
	tmpVal.append("'filetype': '" + fileType + "'}");

	if (Utilities.goodString(fileName)) 
	{
		String binaryFieldName = "_imageData_";
		String fName = fileName;

		FTValList list = new FTValList();

		BlobService service = new BlobService(ics);
		tempObjId = qryMap.get("blobwhere");
		
		if (!"true".equalsIgnoreCase(ics.GetVar("isReposted")) && !we.isValid(tempObjId)) 
		{
			byte[] imageBytes = service.readBinaryDataInBytes(qryMap.get("blobwhere"));	
			list.setValBLOB(binaryFieldName, imageBytes);
			ics.SetVar(binaryFieldName, list.getVal(binaryFieldName));
			tempObjId = we.setTempObject(null, binaryFieldName, fName);
		}

		if (tempObjId == null)
		{
			tempObjId = "01";
		}

		ics.RemoveVar(binaryFieldName);
%>
		<input type="hidden" id="<%=currentInput%>" name="<%=currentInput%>" blobNode=true oraNodeType="blobnode" oraNodeName="<%=currentInput%>" value="<%= tempObjId %>" isnewlyadded="false"/>
<%
	}
	
	ics.SetVar("tempval", tmpVal.toString());
}

ics.SetVar("processedValue", tmpVal.toString());
%>
</cs:ftcs>
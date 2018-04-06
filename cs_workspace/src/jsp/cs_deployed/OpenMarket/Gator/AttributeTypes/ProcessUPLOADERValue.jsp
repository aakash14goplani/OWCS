<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="url" uri="futuretense_cs/url.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/ProcessUPLOADERValue
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
<%@ page import="com.openmarket.xcelerate.interfaces.ITempObjects"%>
<%@ page import="com.openmarket.xcelerate.common.TempObjects"%>

<%@ page import="com.fatwire.util.BlobUtil"%>
<cs:ftcs>
<%
	boolean isSingleValued = "single".equals(ics.GetVar("EditingStyle"));
	byte[] fileData = null;
	StringBuilder tmpVal = new StringBuilder("");
	
	String 	urlValue = ics.GetVar("currentUrlValue"),
	 		mungoBlobId = ics.GetVar("mungoBlobId"),
	 		fileName = "", 
			folder, 
			fileType = "", 
			sqlQry, 
			tableName, 
			tempObjId;
	
	if (null != urlValue) {
		int last = urlValue.lastIndexOf(java.io.File.separator);
	    fileName = urlValue.substring(last + 1);
	    fileData = ics.GetBin("currentUrlFileValue");
	    folder   = ics.GetVar("currentFolder");
	    
	    fileType = BlobUtil.getContentTypeFromName(ics, fileName);
	}
	
	if (Utilities.goodString(ics.GetVar("isReposted"))) {
		mungoBlobId = null;
	} else {
		tableName = ics.GetVar("AssetType") + "_Mungo";
		if (isSingleValued)
			sqlQry = "SELECT id, blobvalue FROM " + tableName + " WHERE cs_ownerid=" + ics.GetVar("id") + " AND cs_attrid=" + ics.GetVar("AttrID");
		else 
			sqlQry = "SELECT id, blobvalue FROM " + tableName + " WHERE cs_ownerid=" + ics.GetVar("id") + " AND cs_attrid=" + ics.GetVar("AttrID") + " AND cs_ordinal like '" + ics.GetCounter("MultiValCounter") + "%'";
%>	
				<ics:callelement element='OpenMarket/Xcelerate/Util/ValidateData'>
			<ics:argument name = "val_variable" value ='<%=ics.GetVar("id")%>'/>
			<ics:argument name = "dataType" value ="long"/>
		</ics:callelement>
		<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
 	    <ics:then>
			<ics:callelement element='OpenMarket/Xcelerate/Util/ValidateData'>
				<ics:argument name = "val_variable" value ='<%=ics.GetVar("AttrID")%>'/>
				<ics:argument name = "dataType" value ="long"/>
			</ics:callelement>
			<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
 	        <ics:then>
				<ics:sql
	      sql="<%= sqlQry %>"
	      table="<%= tableName %>"
	      listname="BlobIdList"/>

			</ics:then>
			</ics:if>
		</ics:then>
		</ics:if>
		<ics:if condition='<%=ics.GetList("BlobIdList") != null && ics.GetList("BlobIdList").hasData()%>'>
		<ics:then>
			<ics:listget listname="BlobIdList" fieldname="blobvalue" output="mungoBlobId"/>
		</ics:then>
		</ics:if>	
<%		
	}
	
	ITempObjects tempObj = new TempObjects(ics);
	tempObjId = "";
	if (Utilities.goodString(mungoBlobId))
		tempObjId = tempObj.getTempObjectId(mungoBlobId);
	else {			
		// Create temp object
		FTValList list = new FTValList();
		String blobdataVar = "_tmp_image_";
		list.setValBLOB(blobdataVar, fileData);
		ics.SetVar(blobdataVar, list.getVal(blobdataVar));
		tempObjId = tempObj.setTempObject(null, blobdataVar, fileName);
		ics.RemoveVar(blobdataVar);
	}	
%>
	<url:unpack value='%0D%0A' varname='CRLF'/>
	<url:pack value='<%= fileName %>' varname='encodedFileName'/>
	<url:pack value='<%= fileType %>' varname='packedCT'/>
	<ics:setvar name="bheadcontent-type" value='<%= ics.GetVar("packedCT") + ";charset=UTF-8" %>'/>
	<% String headContentDisposition = "attachment; filename=" + ics.GetVar("encodedFileName") + ";filename*=UTF-8''" + ics.GetVar("encodedFileName"); %>
	<ics:setvar name="bheadContent-Disposition" value='<%= headContentDisposition %>'/>
	<ics:setvar name="bheadMDT-Type" value='abinary; charset=UTF-8'/>

<% 	if (null != mungoBlobId) { %>		 								
	<satellite:blob assembler="query"
			blobtable='MungoBlobs'
			blobkey='id'
			blobwhere='<%=ics.GetVar("mungoBlobId")%>'
			blobcol='urldata'
			csblobid='<%=ics.GetSSVar("csblobid")%>'
			blobnocache='true'
			outstring="dataurl">				
			<satellite:parameter name='blobheadername1' value='content-type'/>
			<satellite:parameter name='blobheadervalue1' value='<%= ics.GetVar("bheadcontent-type") %>'/>
			
			<satellite:parameter name='blobheadername2' value='Content-Disposition'/>
			<satellite:parameter name='blobheadervalue2' value='<%= ics.GetVar("bheadContent-Disposition") %>'/>
			
			<satellite:parameter name='blobheadername3' value='MDT-Type'/>
			<satellite:parameter name='blobheadervalue3' value='<%= ics.GetVar("bheadMDT-Type") %>'/>				
	</satellite:blob>
<% 	} else { %>		
	<satellite:blob assembler="query"
			blobtable='TempObjects'
			blobkey='id'
			blobwhere='<%= tempObjId %>'
			blobcol='urldata'
			csblobid='<%=ics.GetSSVar("csblobid")%>'
			blobnocache='true'
			outstring="dataurl">				
			<satellite:parameter name='blobheadername1' value='content-type'/>
			<satellite:parameter name='blobheadervalue1' value='<%= ics.GetVar("bheadcontent-type") %>'/>
			
			<satellite:parameter name='blobheadername2' value='Content-Disposition'/>
			<satellite:parameter name='blobheadervalue2' value='<%= ics.GetVar("bheadContent-Disposition") %>'/>
			
			<satellite:parameter name='blobheadername3' value='MDT-Type'/>
			<satellite:parameter name='blobheadervalue3' value='<%= ics.GetVar("bheadMDT-Type") %>'/>				
	</satellite:blob>

<%				
	}
	// /cs/BlobServer?blobcol=urldata&blobtable=MungoBlobs&csblobid=1315374993747&blobkey=id&blobwhere=1315374993657	
	//StringBuilder tmpVal = new StringBuilder((String) ics.GetVar("tempval"));
	tmpVal = new StringBuilder("");
	ics.RemoveVar("mungoBlobId");

	tmpVal.append("{'filename': '" + fileName + "',");
	tmpVal.append("'tempObjectId': '" + tempObjId + "',");
	tmpVal.append("'blobURL': '" + ics.GetVar("dataurl") + "',");
	
	if (Utilities.goodString(fileType) && fileType.contains("image")) {
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
	
	ics.SetVar("processedValue", tmpVal.toString());
%>	
</cs:ftcs>
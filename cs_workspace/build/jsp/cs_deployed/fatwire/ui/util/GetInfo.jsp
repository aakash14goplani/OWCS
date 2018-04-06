<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/ui/util/GetInfo
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

<%@ page import="com.fatwire.system.*"%>
<%@ page import="com.fatwire.assetapi.data.*"%>
<%@ page import="com.fatwire.assetapi.query.*"%>
<%@ page import="com.openmarket.xcelerate.asset.*"%>
<%@ page import="java.util.*"%>


<cs:ftcs>
<ics:if condition='<%= "GetTempObjectId".equals(ics.GetVar("requestFor")) %>'>
<ics:then>	
	<ics:if condition='<%=Utilities.goodString(ics.GetVar("mungoBlobId")) %>'>
	<ics:then>
	<%
		ITempObjects tempObj = new TempObjects(ics);
		String tempObjId = tempObj.getTempObjectId(ics.GetVar("mungoBlobId"));
		out.println(tempObjId.trim());
	%>
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>

<ics:if condition='<%= "GetBlobInfo".equals(ics.GetVar("requestFor")) %>'>
<ics:then>
<%
	String attr = ics.GetVar("attribute");
	byte[] attrDataBytes = null;
	
	Session ses = SessionFactory.getSession();	
	AssetDataManager adm = (AssetDataManager) ses.getManager(AssetDataManager.class.getName());
	
	AssetId assetId = new AssetIdImpl(ics.GetVar("type"), Long.parseLong(ics.GetVar("id")) );
	List<String> attrNames = new ArrayList<String>();
	attrNames.add(attr);
	AssetData data = adm.readAttributes(assetId, attrNames);
	AttributeData ad = data.getAttributeData(attr);
	
	BlobObject blobObj = (BlobObject) ad.getData();
	attrDataBytes = new byte[blobObj.getBinaryStream().available()];
	blobObj.getBinaryStream().read(attrDataBytes);

	String blobVar = "blobdata";
	ITempObjects tempObj = new TempObjects(ics);
	FTValList list = new FTValList();
	list.setValBLOB(blobVar, attrDataBytes);
	ics.SetVar(blobVar, list.getVal(blobVar));
	String tempObjId = tempObj.setTempObject(null, blobVar, ics.GetVar("filename"));	
%>
	<satellite:blob assembler="query"
		blobtable='TempObjects'
		blobkey='id'
		blobwhere='<%= tempObjId %>'
		blobcol='urldata'
		csblobid='<%=ics.GetSSVar("csblobid")%>'
		outstring="imageurl"/>
<%
	String blobURL = ics.GetVar("imageurl");
	String blobdata = "{" + 
						"filename: '" + ics.GetVar("filename") + "'," +
						"tempObjectId: '" + tempObjId + "'," +
						"blobURL: '" + blobURL + "'," +
						"filetype: '" + "jpeg" + "'" +
					  "}";
	out.println(blobdata);
	
	ics.RemoveVar("imageurl");
	ics.RemoveVar(blobVar);
%>
</ics:then>
</ics:if>

</cs:ftcs> 
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.fatwire.assetapi.def.AttributeDef"%>
<%@page import="com.fatwire.assetapi.def.AssetTypeDefImpl"%>
<%@page import="com.fatwire.assetapi.def.AssetTypeDefManagerImpl"%>
<%@page import="com.fatwire.assetapi.def.AssetTypeDef"%>
<%@page import="com.fatwire.assetapi.def.AssetTypeDefManager"%>
<%@page import="com.fatwire.assetapi.def.AttributeDefProperties"%>
<%@page import="com.fatwire.assetapi.def.AttributeTypeEnum"%>
<%@page import="com.openmarket.gator.interfaces.FlexTypeManagerFactory"%>
<%@page import="com.openmarket.gator.interfaces.IFlexAssetTypeManager"%>
<%@page import="com.openmarket.gator.interfaces.IFlexGroupTypeManager"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/convertAssetFormsTZ
//
// INPUT
//
// This code is used to convert date fields from the 
// asset forms from client's time zone to server's time zone (UTC).
//
// The date fields are asset attributes and start end dates.
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.assetapi.util.*"%>
<%@ page import="com.fatwire.assetapi.data.*"%>
<%@ page import="com.openmarket.xcelerate.asset.*"%>
<%@ page import="com.openmarket.xcelerate.util.*"%>
<cs:ftcs>
<!-- user code here -->
<%
try{
	 String assetType = ics.GetVar("AssetType");
	 
	 List<String> skipList = Arrays.asList("createddate","updateddate");
	 List<String> specialDates = Arrays.asList("startdate","enddate");
	 
	 String clientTimeZone = ics.GetSSVar("time.zone");
	 String serverTimeZone = TimeZone.getDefault().getID();

	 boolean isComplexAsset = AssetUtil.isComplexAsset(ics,assetType);
	 boolean isFlexAsset = AssetUtil.isFlexAsset(ics,assetType);
	 boolean flexOrComplexAsset = isFlexAsset || isComplexAsset;
	 
	String subType = "";
	String prefixForAttr = "flexassets:";
	if(isFlexAsset)
	{
		String subTypeId = ics.GetVar("flexassets:flextemplateid");
		//find the subtype from flextemplateid or flexgrouptemplateid
		boolean isParentType = AssetUtil.isParentType(ics, assetType);
		if(isParentType)
		{
			prefixForAttr ="flexgroups:";
			subTypeId =ics.GetVar("flexgroups:flexgrouptemplateid");
		}
		
		String defType = null;
		if(isParentType)
			{
				IFlexGroupTypeManager iftm = FlexTypeManagerFactory.getFlexGroupTypeManager(ics);				
				defType = iftm.getTemplateType(assetType);
			}
			else
			{
				IFlexAssetTypeManager iftm = FlexTypeManagerFactory.getFlexAssetTypeManager(ics);
				defType = iftm.getTemplateType(assetType);
			}
		   
		if(!Utilities.goodString(subTypeId))
		{
			 throw new RuntimeException("Subtype id could not be resolved. Check the scattered variables in the form for asset type = " + assetType );
		}
		
		AssetId id = new AssetIdImpl(defType,Long.parseLong(subTypeId));
		subType = AssetUtil.getSubtypeNameWithid(ics, assetType, id);
	}
	else if("Page".equals(assetType))
	{
		//if it is a page asset.
		subType = ics.GetVar("flexassets:subtype");
	}
	else
	{
			prefixForAttr = assetType +":";	
	}

	//after find the asset subtype.
	AssetTypeDefManager atdm = new AssetTypeDefManagerImpl(ics);
	AssetTypeDef  assetTypeDef = atdm.findByName(assetType, subType);
	List<AttributeDef> attrDefs = assetTypeDef.getAttributeDefs();
	for(AttributeDef attr : attrDefs)
	{
		String attrType = attr.getType().getName();
		String attrName = attr.getName();
		String prefix =  !flexOrComplexAsset || specialDates.contains(attrName) ? prefixForAttr : "Attribute_" ;
		
		if(AttributeTypeEnum.DATE.toString().equals(attrType) && !skipList.contains(attrName)  )
		{
			if(specialDates.contains(attrName) )
			{
					String varToConvert = ics.GetVar(prefix+attrName);
					if(Utilities.goodString(varToConvert))
					{
						String newDate = ConverterUtils.convertJDBCDate(varToConvert,clientTimeZone,serverTimeZone);	
						ics.SetVar(prefix+attrName ,newDate);					
					}	
			}
			else
			{
				//in case of attributes
				boolean singleAttr = attr.getProperties().getValueCount().equals(AttributeDefProperties.ValueCount.SINGLE);
				int valueCount = singleAttr ? 1 : Integer.parseInt(ics.GetVar(attrName +"VC"));
				int count = 1;
				do
				{
					String prefixAndAttrName = prefix+attrName;
					String attrKeyVar = singleAttr ? prefixAndAttrName : prefixAndAttrName+"_" +count;
					String varToConvert = ics.GetVar(attrKeyVar);								
					if(Utilities.goodString(varToConvert))
					{
						String newDate = null;
						if(flexOrComplexAsset)
						{
							String dbFormat = ConverterUtils.convertDateToDBFormat(varToConvert, ics.GetSSVar("locale"));
							newDate = ConverterUtils.convertJDBCDate(dbFormat,clientTimeZone,serverTimeZone);
						}
						else
						{
							newDate = ConverterUtils.convertJDBCDate(varToConvert,clientTimeZone,serverTimeZone);
						}
						ics.SetVar(attrKeyVar ,newDate);					
					}
				} while(++count<=valueCount);
			}
		}
			
	}
} catch(Exception e){
	//Log the error here..
%>
	<ics:logmsg severity="error"
				name="oracle.fatwire.sites.timezone" msg='<%=e.getMessage()%>'/>
<%
}
%>
</cs:ftcs>

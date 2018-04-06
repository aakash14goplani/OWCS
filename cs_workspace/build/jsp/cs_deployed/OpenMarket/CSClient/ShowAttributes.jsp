<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/CSClient/ShowAttributes
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
<%
IList typeInfo = ics.GetList("lTypeInfo", false);
IList clientFields = ics.GetList(ics.GetVar("clientInfoListName"), false);
if (!typeInfo.getValue("clienttype").equals("unsupported"))
{
    ics.SetVar("cs_readOnly", ("true".equals(ics.GetVar("editLegal")))?typeInfo.getValue("readonly"):"true");
   
    if ("name".equals(clientFields.getValue("property")))
    {
%>
	<string:encode variable='asset:name' varname='currentName'/>
	<ATTRIBUTE NAME="name" DISPLAYNAME='<%=ics.GetVar("_XLAT_Name")%>' VALUE='<%=ics.GetVar("currentName")%>' DataType="String" REQUIRED="true" READONLY='<%=ics.GetVar("cs_readOnly")%>" DESCRIPTION="<%=typeInfo.getValue("description")%>' />
<%
    }
    else if ("description".equals(clientFields.getValue("property")))
    {
%>
	<string:encode variable='asset:description' varname='currentDesc'/>
	<xlat:lookup key='dvin/Common/Description' varname='_XLAT_Desc'/>
	<ATTRIBUTE NAME="description" DISPLAYNAME='<%=ics.GetVar("_XLAT_Desc")%>' VALUE='<%=ics.GetVar("currentDesc")%>' DataType="String" REQUIRED="false" READONLY='<%=ics.GetVar("cs_readOnly")%>' DESCRIPTION='<%=typeInfo.getValue("description")%>' />
<%
    }
    else if ("Dimension".equals(clientFields.getValue("property")))
    {
	// donothing 
    }
    else if ("true".equals(ics.GetVar("inspectLegal")))
    {
	// System.out.println("Forming list with "+clientFields.getValue("property")+" attribute");
%>
	<string:encode list='lTypeInfo' column='description' varname='fieldDesc'/>
<%
	java.util.ArrayList values = new java.util.ArrayList();
      
	StringBuffer valBuf = new StringBuffer();
	valBuf.append("asset");
	valBuf.append(String.valueOf(ics.GetCounter("currentInst")));
	valBuf.append(":");
	valBuf.append(clientFields.getValue("property"));
	valBuf.append(":Total");
	String currentVal = ics.GetVar(valBuf.toString());
	// System.out.println("currentVal for property "+clientFields.getValue("property")+" is "+currentVal);
	String fileString = "";
	boolean isMultiple = false;
	String type = typeInfo.getValue("type");
	String currentList = null;
	if ("assetreference".equals(type))
	{
		String refType = typeInfo.getValue("reftype");
		String refSubtype = typeInfo.getValue("refsubtype");
          
		if (refSubtype.length() == 0)
		{
			currentList = "l"+refType+"__"+ics.GetSSVar("pubid");
			if (ics.GetList(currentList) == null)
			{
				ics.ClearErrno();
%>
				<asset:list type='<%=refType%>' list='<%=currentList%>' order='name' excludevoided='true' pubid='<%=ics.GetSSVar("pubid")%>'/>
<%
			}
		}
		else
		{
			currentList = "l"+refType+"__"+refSubtype+"__"+ics.GetSSVar("pubid");
			if (ics.GetList(currentList) == null)
			{
				ics.SetVar("searchfor:Publist_op", "=");
				ics.SetVar("searchfor:Publist:Total", "1");
				ics.SetVar("searchfor:Publist:0", ics.GetSSVar("pubid"));
%>
				<asset:search type='<%=refType%>' subtype='<%=refSubtype%>' prefix='searchfor' order='name' list='<%=currentList%>' fieldlist='LocalFields'/>
<%
			}
		}
	}
      
	if ("file".equals(type))
	{
		fileString = "_file";
	}

	if (currentVal != null)
	{
		// System.out.println("currentVal total length was not null");
		isMultiple = true;
		int currentCount = Integer.parseInt(currentVal);
		for (int currentRow = 0; currentRow < currentCount; currentRow++)
		{
			StringBuffer currentBuf = new StringBuffer();
			currentBuf.append("asset");
			currentBuf.append(String.valueOf(ics.GetCounter("currentInst")));
			currentBuf.append(":");
			currentBuf.append(clientFields.getValue("property"));
			currentBuf.append(":");
			currentBuf.append(String.valueOf(currentRow));
			currentBuf.append(fileString);
			currentVal = ics.GetVar(currentBuf.toString());
			if (currentVal != null)
			{
				// System.out.println("  Adding value "+currentVal+" to current values array");
				values.add(currentRow, currentVal);
			}
		}
	}
	else
	{
		// single
		StringBuffer currentBuf = new StringBuffer();
		currentBuf.append("asset");
		currentBuf.append(String.valueOf(ics.GetCounter("currentInst")));
		currentBuf.append(":");
		currentBuf.append(clientFields.getValue("property"));
		currentBuf.append(fileString);
		currentVal = ics.GetVar(currentBuf.toString());
		if (currentVal != null)
		{
			values.add(0, currentVal);
		}
	}

	if ("assetreference".equals(type))
	{
		// <!-- display multi list here -->
		// System.out.println("  Asset reference output");
%>
	<ATTRIBUTE NAME='<%=clientFields.getValue("property")%>' DESCRIPTION='<%=typeInfo.getValue("description")%>' DISPLAYNAME='<%=ics.GetVar("fieldDesc")%>' DataType='<%=(isMultiple)?"mslist":"list"%>' READONLY='<%=ics.GetVar("cs_readOnly")%>' REQUIRED='<%=typeInfo.getValue("required")%>' >
		<OPTIONS>
<%
		IList valueList = ics.GetList(currentList);
		if (valueList != null && valueList.hasData())
		{
			do
			{
%>
			<string:encode list='<%=currentList%>' column='name' varname='currentDisplayValue'/>
			<OPTION VALUE='<%=valueList.getValue("id")%>' SELECTED='<%=values.contains(valueList.getValue("id"))?"true":"false"%>' DISPLAYVALUE='<%=ics.GetVar("currentDisplayValue")%>'/>
<%
			} while (valueList.moveToRow(IList.next,0));
		}
%>
		</OPTIONS>
	</ATTRIBUTE>
<%
	}
	else
	{
	
		String enumVals = typeInfo.getValue("enumvals");                                                                             
		String enumDisplay = typeInfo.getValue("enumdisplay");

		// Publication is handled specially because the convention is now that you cannot share an asset to a publication that you are not
		// a registered user for.  Asset.Inspect does not do anything different based on user identity (just on site), so this has to be checked
		// prior to user presentation in all cases.  Pr 15659.
		if ("Publist".equals(clientFields.getValue("property")))
		{
			// System.out.println("  Detected publist property!");
			// Replace the values that came back from asset.inspect with something else...
			// Use the security element to calculate the legal list of share sites for the current user.  (This is how the advanced UI does it.)
			FTValList vN = new FTValList();
			vN.setValString("VARNAME", "loginuser");
			ics.runTag("usermanager.getloginuser", vN);
%>
			<ics:getproperty name="xcelelem.manageuserpub" file="futuretense_xcel.ini" output="propmanageuserpub"/>
			<ics:callelement element='<%=ics.GetVar("propmanageuserpub")%>'>
				<ics:argument name="upcommand" value="GetPublications"/>
				<ics:argument name="qryprefix" value="publist"/>
				<ics:argument name="username" value='<%=ics.GetVar("loginuser")%>'/>
			</ics:callelement>
<%
			// The CS list "publist" should be set at this point.  Generate the attribute options list.
			StringBuffer enumValuesBuffer = new StringBuffer();
			StringBuffer enumDisplayBuffer = new StringBuffer();
%>
			<ics:listloop listname="publist">
				<ics:listget listname="publist" fieldname="pubid" output="value"/>
				<ics:listget listname="publist" fieldname="description" output="display"/>
<%
				if (enumValuesBuffer.length() > 0)
				{
					enumValuesBuffer.append(",");
					enumDisplayBuffer.append(",");
				}
				enumValuesBuffer.append(ics.GetVar("value"));
				enumDisplayBuffer.append(ics.GetVar("display"));
%>
			</ics:listloop>
<%
			enumVals = enumValuesBuffer.toString();
			enumDisplay = enumDisplayBuffer.toString();
			// System.out.println("  Enumvals = '"+enumVals+"', enumdisplay='"+enumDisplay+"'");
		}
		
		if (enumVals.length() != 0)
		{
			// System.out.println("  Forming attribute option.  isMultiple = "+(isMultiple?"true":"false")+" Readonly = "+ics.GetVar("cs_readOnly"));
			String currentEnum = null;
			String currentDisplay = null;
			java.util.StringTokenizer vals = new java.util.StringTokenizer(enumVals, ",");
			java.util.StringTokenizer display = new java.util.StringTokenizer(enumDisplay, ",");
%>

	<ATTRIBUTE NAME='<%=clientFields.getValue("property")%>' DESCRIPTION='<%=typeInfo.getValue("description")%>' DISPLAYNAME='<%=ics.GetVar("fieldDesc")%>' DataType='<%=(isMultiple)?"mslist":"list"%>' READONLY='<%=ics.GetVar("cs_readOnly")%>' REQUIRED='<%=typeInfo.getValue("required")%>' >
		<OPTIONS>
<%
			while (vals.hasMoreTokens())
			{
				currentEnum = vals.nextToken();
				if (enumDisplay.length() != 0)
				{
					currentDisplay = display.nextToken();
				}
				else
				{
					currentDisplay = currentEnum;
				}
				FTValList vN = new FTValList();
				vN.setValString("VALUE",currentEnum);
				vN.setValString("VARNAME","currentEnumValue");
				ics.runTag("string.encode",vN);
				vN.removeAll();
				vN.setValString("VALUE",currentDisplay);
				vN.setValString("VARNAME","currentDisplayValue");
				ics.runTag("string.encode",vN);
				
				// System.out.println("    Added an option: "+ics.GetVar("currentEnumValue")+" selected="+(values.contains(currentEnum)?"true":"false")+" display: "+ics.GetVar("currentDisplayValue"));
%>
			<OPTION VALUE='<%=ics.GetVar("currentEnumValue")%>' SELECTED='<%=(values.contains(currentEnum)?"true":"false")%>' DISPLAYVALUE='<%=ics.GetVar("currentDisplayValue")%>'/>
<%
			}
%>
		</OPTIONS>
	</ATTRIBUTE>
<%
		}
		else
		{
			// System.out.println("  Final else clause");
			// <!-- this could be the drop field, property is 'Name' if it is -->
			if (!"List".equals(typeInfo.getValue("clienttype")) && !(ics.GetVar("cs_dropField").equals(clientFields.getValue("property"))))
			{
				valBuf = new StringBuffer();
				java.util.Iterator it = values.iterator();
				while (it.hasNext())
				{
					if (valBuf.length()!=0)
					{
						valBuf.append(",");
					}
					valBuf.append((String) it.next());
				}
				FTValList vN = new FTValList();
				vN.setValString("VALUE",valBuf.toString());
				vN.setValString("VARNAME","currentVal");
				ics.runTag("string.encode",vN);
%>
	<ATTRIBUTE NAME='<%=clientFields.getValue("property")%>' DISPLAYNAME='<%=ics.GetVar("fieldDesc")%>' VALUE='<%=ics.GetVar("currentVal")%>' DataType='<%=typeInfo.getValue("clienttype")%>' READONLY='<%=ics.GetVar("cs_readOnly")%>' DESCRIPTION='<%=typeInfo.getValue("description")%>' REQUIRED='<%=typeInfo.getValue("required")%>'/>
<%
			}
		}
	}
    }
}
%>

</cs:ftcs>

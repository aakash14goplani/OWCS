<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%
    //
    // OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyEdit
    //
    // INPUT
    //
    // OUTPUT
    //
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="javax.servlet.jsp.JspWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.fatwire.realtime.util.Util"%>
<%@ page import="java.util.StringTokenizer, COM.FutureTense.Util.IterableIListWrapper" %>
<%!
    public static final String TREENAME = "LocaleTree";

    void printTree(JspWriter out, ICS ics, HashMap<String, Object> hmTree, String sCurID, int iDepth) throws Exception
    {
        String sql = "select name from Dimension where id = " + sCurID;
        IList iList = ics.SQL("Dimension", sql, null, -1, false, true, null);
        String sName = iList.getValue("name");

        ArrayList<String> alistChildren = (ArrayList) hmTree.get(sCurID);

        out.println("<div style='padding-left: " + (iDepth * 20) + "px'><input type='radio' name='parent_node' value='" + sCurID + "'> <span>" + sName + "</span>");

        if (null == alistChildren || alistChildren.size() == 0)
        {   // The root cannot be removed if it has children because we don't know which one of its chidren should be
            // chosen as the root asset.
            out.println("<span style='position: relative; top: 1px;'><a href='javascript:removeFromTree(\"localeID\", \""+sCurID+"\")' onmouseover=\"window.status='"+ics.GetVar("_XLAT_deleteDimension")+"';return true;\" onmouseout=\"window.status='';return true\">\n" +
                "<img height=\"14\" width=\"14\" src=\""+ics.GetVar("cs_imagedir")+"/graphics/common/icon/iconDeleteContentUp.gif\" hspace=\"2\" border=\"0\" alt='"+ics.GetVar("_XLAT_deleteDimension")+"'/>\n" +
                "</a></span>");
        }
        out.println("</div>");

        if (null != alistChildren)
        {
            for (int i = 0, l = alistChildren.size(); i < l; i++)
            {
                printTree(out, ics, hmTree, alistChildren.get(i), iDepth + 1);
            }
        }
    }

    HashMap<String, Object> toHashMap(String sTempTree)
    {
        StringTokenizer st = new StringTokenizer(sTempTree, ",");
        HashMap<String, Object> hmTree = new HashMap<String, Object>();

        ArrayList<String> alistTemp;
        while (st.hasMoreTokens())
        {
            String sToken = st.nextToken().trim();

            if (sToken.length() == 0)
                continue;

            int iIndex = sToken.indexOf(":");
            String sParentID = sToken.substring(0, iIndex);
            String sNodeID = sToken.substring(iIndex + 1);

            alistTemp = (ArrayList) hmTree.get(sParentID);

            if (null == alistTemp)
            {
                alistTemp = new ArrayList<String>();
                hmTree.put(sParentID, alistTemp);
            }
            alistTemp.add(sNodeID);
        }
        return (hmTree);
    }

    /**
     *
     * @param result string being built up in the form a string in the form parentoid:childoid,parent2oid:child2oid etc.
     * @param ics
     * @param parentNode
     * @throws Exception
     */
    void toString(StringBuffer result, ICS ics, String parentNode) throws Exception
    {
        FTValList params1 = new FTValList();
        params1.put("ftcmd", "getnode");
        params1.put("treename", TREENAME);
        params1.put("join", "false");
        params1.put("node", parentNode);
        ics.TreeManager(params1);
        IList self = ics.GetList(TREENAME);

        FTValList params = new FTValList();
        params.put("ftcmd", "getchildren");
        params.put("treename", TREENAME);
        params.put("orderby", "nrank");
        params.put("nparentid", parentNode);
        ics.TreeManager(params);
        IList ilistChildren = ics.GetList(TREENAME);

        for (IList child : new IterableIListWrapper(ilistChildren))
        {
            if (result.length() > 0)
                result.append(',');
            result.append(self.getValue("oid")).append(":").append(child.getValue("oid"));

            toString(result, ics, child.getValue("nid"));
        }
    }

    String getDimSetNodeID(ICS ics) throws NoSuchFieldException
    {
        FTValList params1 = new FTValList();
        params1.put("ftcmd", "findnode");
        params1.put("treename", TREENAME);
        params1.put("where", "oid");
        params1.put("oid", ics.GetVar("DimensionSet:id"));

        ics.TreeManager(params1);
        IList rootNode = ics.GetList(TREENAME);
		return (rootNode != null && rootNode.hasData()) ? rootNode.getValue("nid") : null;
    }
%>
<cs:ftcs>
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<string:encode variable="cs_environment" varname="cs_environment"/>
<script language="javascript">

var enabledDimensions = new Array();

function DecodeUTF8(encoded)
{
    var i = 0;
    var currentUnicode = 0;
    var UnicodeString = new Array();
    var UnicodeIndex = 0;

    var currentState = "Start";

    for (i = 0; i < encoded.length; i += 2)
    {
        var twochars = encoded.substr(i, 2);
        var currentByte = parseInt(twochars, 16);

        // utf-8 representation may have up to 4 bytes per character
        if (currentState == "Start")
        {
            if ((currentByte & 0x80) != 0)
            {
                // if 1st 3 bits are 110 then 2 bytes
                if ((currentByte >> 5) == 0x06)
                {
                    // 2 bytes - want 3 bits after 0xC0 as low 3 bits in first unicode byte
                    currentUnicode = (currentByte & 0x1C) >> 2;

                    // 2 remaining bits of byte 1 become low bits of currentUnicode
                    currentUnicode = currentUnicode << 2;
                    currentUnicode = currentUnicode | (currentByte & 0x03);
                    currentState = "Done";
                }
                // if first 4 bits are 1110 then 3 bytes
                else if ((currentByte >> 4) == 0x0E)
                {
                    currentUnicode = (currentByte & 0x0F);
                    currentState = "Middle1";
                }
                // if first 5 bits are 11110 then 4 bytes
                else if ((currentByte >> 3) == 0x1E)
                {
                    currentUnicode = (currentByte & 0x07);
                    currentState = "Middle2";
                }
            }
            else
            {
                UnicodeString[UnicodeIndex] = currentByte;
                UnicodeIndex++;
            }
        }
        else if (currentState == "Done")
        {
            currentUnicode = currentUnicode << 6;
            currentUnicode = currentUnicode | (currentByte & 0x3F);
            UnicodeString[UnicodeIndex] = currentUnicode;
            UnicodeIndex++;
            currentState = "Start";
        }
        else if (currentState == "Middle1")
        {
            currentUnicode = currentUnicode << 6;
            currentUnicode = currentUnicode | (currentByte & 0x3F);
            currentState = "Done";
        }
        else if (currentState == "Middle2")
        {
            currentUnicode = currentUnicode << 6;
            currentUnicode = currentUnicode | (currentByte & 0x3F);
            UnicodeString[UnicodeIndex] = currentUnicode;
            UnicodeIndex++;
            currentState = "Middle1";
        }

    }
    var StringCode = "String.fromCharCode(";
    StringCode += UnicodeString[0];
    for (var y = 1; y < UnicodeIndex; y++)
    {
        StringCode += "," + UnicodeString[y];
    }
    StringCode += ");";

    return(eval(StringCode));
}

function pickFromTree(where, idwhere, assettype)
{
    var obj = document.forms[0].elements[0];
    var id,name;
    var EncodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections() + '';
    var idArray = EncodedString.split(',');
    var assetcheck = unescape(idArray[0]);
    if (assetcheck.indexOf('assettype=') != -1 && assetcheck.indexOf('id=') != -1)
    {
        // string is of the format: id=[id],[name]:
        var test = new String(EncodedString);

        var nameVal = test.split(",");
        if (nameVal.length != 2)
            alert('<xlat:stream key="dvin/AT/DimensionSet/PleaseSelect1AssetFromTree" encode="false" escape="true"/>');
        else
        {
            var i = 0;
            for (i = 0; i < nameVal.length; i += 2)
            {
                if (assettype != null)
                {
                    id = unescape(nameVal[i]);
                    var splitid = id.split(',');
                    if (splitid.length == 1)
                    {
						var xlatstr= '<xlat:stream key="dvin/AT/DimensionSet/NodeNotValidSelection" encode="false" escape="true"/>' ;
                        var replacestr = /Variables.id/;
                        xlatstr = xlatstr.replace(replacestr, id);
                        alert(xlatstr);
                        return;
                    }

                    var splitpair = splitid[1].split("=");

                    if (assettype != splitpair[1])
                    {
                        var xlatstr = '<xlat:stream key="dvin/AT/DimensionSet/SelectionMustBeOfTypeSelectionTypeInvalid" encode="false" escape="true"/>';
                        var replacestr = /Variables.assettype/;
                        xlatstr = xlatstr.replace(replacestr, assettype);
                        replacestr = /Variables.splitpair/;
                        alert(xlatstr.replace(replacestr, splitpair[1]));
                        return;
                    }
                    splitpair = splitid[0].split("=");
                    id = splitpair[1];

                }
                name = nameVal[i + 1].replace(/\+/g, ' ');
                name = DecodeUTF8(name.substr(0, name.length - 1));
            }

            // Check if current id is already in the tree
            var tempTree = obj.form.elements["tmpTree"].value;
            if (tempTree.indexOf(id) > -1)
            {    // Already in the tree, alert.
				var xlatstr = '<xlat:stream key="dvin/AT/DimensionSet/SelectedLocaleAlreadyInTreeSelectAnother1" encode="false" escape="true"/>';
                var replacestr = /Variables.name/;
                xlatstr = xlatstr.replace(replacestr, name);
                alert(xlatstr);
            }
            else
            {
            	// id not in the tree
            	// Check if asset is enabled for the DimensionSet
				if (!checkEnabledDimension('Dimension', id))
				{
					var xlatstr = '<xlat:stream key="dvin/AT/DimensionSet/SelectedLocaleNotEnabledForDimension" encode="false" escape="true"/>';
					var replacestr = /Variables.name/;
					xlatstr = xlatstr.replace(replacestr, name);
					alert(xlatstr);
				}
				// See if a parent is selected
                else if (tempTree.length > 0 && !isParentSelected())
                {
                    alert('<xlat:stream key="dvin/AT/DimensionSet/PleaseSelectParentNode" encode="false" escape="true"/>');
                }
                else
                {
					obj.form.elements[idwhere].value = id;
					obj.form.elements[where].value = name;

					submitForm('step');
                }
            }
        }
    }
    else
    {
        alert('<xlat:stream key="dvin/AT/DimensionSet/PleaseSelectAssetFromTree" encode="false" escape="true"/>');
    }
}

function removeFromTree(idwhere, id)
{
    var obj = document.forms[0].elements[0];
    obj.form.elements[idwhere].value = id;
    //obj.form.elements[where].value = name;

    submitForm('remove');
}

function isParentSelected()
{
    var obj = document.forms[0].elements["parent_node"];

    if (obj == null)
        return (true);

    if (null == obj.length)
    {
        return (obj.checked);
    }
    else
    {
        for (var i = 0, l = obj.length; i < l; i++)
        {
            if (obj[i].checked)
                return (true);
        }
    }

    return (false);
}

function submitForm(action)
{
    obj = document.forms[0].elements[0];
    obj.form.elements["form_action"].value = action;
    obj.form.submit();
}

function checkEnabledDimension(type, id)
{
	var seek = type+'_'+id;
	for (var i = 0, l = enabledDimensions.length; i < l; i++)
	{
		if (seek == enabledDimensions[i])
			return true;
	}

	return false;
}

<%-- Load the DimensionSet asset and get the enabled Dimensions --%>
<asset:load name="as" type="DimensionSet" objectid='<%=ics.GetVar("DimensionSet:id")%>' />
<asset:scatter name="as" prefix="ContentDetails" />
<%
int iTotal = Integer.parseInt(ics.GetVar("ContentDetails:EnabledDimension:Total"));

if (iTotal > 0)
{
	for (int i = 0; i < iTotal; i++)
	{
		// load the dimension so we can spit out its name.
		// todo: replace this with a tag?
		String type = ics.GetVar("ContentDetails:EnabledDimension:"+i+"_type");
		String id = ics.GetVar("ContentDetails:EnabledDimension:"+i);

		%>
		enabledDimensions[enabledDimensions.length] = "<%=type+"_"+id%>";
		<%
	}
}
%>

</script>

<xlat:lookup key="dvin/AT/Dimension/DeleteThisDimension" varname="_XLAT_deleteDimension" />
<input type="hidden" name="DimensionSet:id" value="<string:stream value='<%=ics.GetVar("DimensionSet:id")%>'/>"/>
<input type="hidden" name="form_action" value="step"/>
<input type="hidden" name="pagename" value="OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyPost"/>

<table class="width-outer-70" border="0" cellpadding="0" cellspacing="0">
<!-- DimensionSet page title with asset name -->
<tr>
    <td>
        <span class="title-text">
            <xlat:stream key="dvin/AT/DimensionSet/ConfigureLocaleHierarchy"/>
        </span>
    </td>
</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
    <ics:argument name="SpaceBelow" value="No" />
</ics:callelement>

<%--<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar">
    <ics:argument name="SpaceAbove" value="No" />
</ics:callelement>--%>
<tr>
<td>
<%
	String sTempTree = ics.GetVar("tmpTree");
	if (null == sTempTree)
	{
		String dimSetNode = getDimSetNodeID(ics);
		if (dimSetNode != null)
		{
			StringBuffer b = new StringBuffer();
			toString(b, ics, getDimSetNodeID(ics));
			sTempTree = b.toString();
		}
	}

	HashMap<String, Object> hmTree;

	if (null == sTempTree || "null".equals(sTempTree) || sTempTree.length() == 0)
	{
		if("ucform".equals(ics.GetVar("cs_environment")))			
			out.println("Please drag and drop a default locale from the tree.");
		else
			out.println(Util.xlatLookup(ics, "dvin/AT/DimensionSet/PleaseSelectDefaultLocaleFromTree", false, false));
	}
	else
	{
		hmTree = toHashMap(sTempTree);

		String sRootNode = (String) ((ArrayList) hmTree.get(ics.GetVar("DimensionSet:id"))).get(0);
		printTree(out, ics, hmTree, sRootNode, 0);
	}
%>
</td>
</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr>
	<td>
		<% if ("ucform".equals(ics.GetVar("cs_environment"))) {%>
			<div>
				<div name="typeAheadLocHierar"> </div>	
				<div>Drag And Drop Dimension Assets</div>		
			</div>
			<script type="text/javascript" language="JavaScript">
				var selectDnDLocHierar = function(){
					var widgetName="typeAheadLocHierar";
					var nodes= [];
					nodes = dojo.query('div[name='+widgetName+']');
					if(nodes.length === 0)
						nodes = dojo.query('input[name='+widgetName+']');
					var	typeWidgetIns=dijit.getEnclosingWidget(nodes[0]),
						valueArray=typeWidgetIns.getAllDnDValues();
					var obj = document.forms[0].elements[0], s = typeWidgetIns._source,
						destroyItem = dojo.partial(fw.ui.dnd.util.destroyItem, s);
					if(valueArray.length > 0){
						var assetDataArray =  valueArray[0];
						var tempTree = obj.form.elements["tmpTree"].value;
						if (tempTree.indexOf(assetDataArray[0]) > -1)
						{    // Already in the tree, alert.
							parent.fw.ui.app.clearMessage();
							var xlatstr = '<xlat:stream key="dvin/AT/DimensionSet/DroppedLocaleAlreadyInTreeDragDropAnother1" encode="false" escape="true"/>';
							var replacestr = /Variables.assetDataArray/;
							xlatstr = xlatstr.replace(replacestr, assetDataArray[2]);
							parent.fw.ui.app.displayMessage(xlatstr, "warn");
							s.getAllNodes().forEach(destroyItem);
							typeWidgetIns.showDropZone();
						}
						else
						{
							// id not in the tree
							// Check if asset is enabled for the DimensionSet
							if (!checkEnabledDimension('Dimension', assetDataArray[0]))
							{
								parent.fw.ui.app.clearMessage();
								var xlatstr = '<xlat:stream key="dvin/AT/DimensionSet/DroppedLocaleNotEnabledDimension" encode="false" escape="true"/>';
								var replacestr = /Variables.assetDataArray/;
								xlatstr = xlatstr.replace(replacestr, assetDataArray[2]);
								parent.fw.ui.app.displayMessage(xlatstr, "warn");
								s.getAllNodes().forEach(destroyItem);
								typeWidgetIns.showDropZone();
							}
							// See if a parent is selected
							else if (tempTree.length > 0 && !isParentSelected())
							{
								parent.fw.ui.app.clearMessage();
								var xlatstr = '<xlat:stream key="dvin/AT/DimensionSet/PleaseSelectParentNode" encode="false" escape="true"/>';
								parent.fw.ui.app.displayMessage(xlatstr, "warn");
								s.getAllNodes().forEach(destroyItem);
								s.getAllNodes().forEach(destroyItem);
								typeWidgetIns.showDropZone();
							}
							else
							{
								parent.fw.ui.app.clearMessage();
								obj.form.elements['localeName'].value = assetDataArray[2];
								obj.form.elements['localeID'].value = assetDataArray[0];
								submitForm('step');
							}
						}
							
					}
				};
			</script>
			<%
				StringBuilder acceptedAType = new StringBuilder();
				acceptedAType.append("[")
				.append("\""+ "Dimension" + "\"")
				.append("]");
			%>	
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget'>			
				<ics:argument name="parentType" value='<%=acceptedAType.toString()%>'/>
				<ics:argument name="subTypesForWidget" value='*'/>
				<ics:argument name="subTypesForSearch" value=''/>
				<ics:argument name="multipleVal" value="true"/>
				<ics:argument name="widgetValue" value=''/>	
				<ics:argument name="funcToRun" value='selectDnDLocHierar'/>
				<ics:argument name="widgetNode" value='typeAheadLocHierar'/>
				<ics:argument name="typesForSearch" value='Dimension'/>	
				<ics:argument name="displaySearchbox" value='false'/>
				<ics:argument name="multiOrderedAttr" value='true'/>				
			</ics:callelement>
		<% } %>
	</td>
</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr>	
    <xlat:lookup key="dvin/Common/CancelChanges" varname="_XLAT_Cancel" escape="true" />
    <xlat:lookup key="dvin/UI/Cancel" varname="_Cancel_ALT" />
    <xlat:lookup key="dvin/Common/SaveChanges" varname="_XLAT_Save" escape="true" />
    <xlat:lookup key="dvin/UI/Save" varname="_Save_ALT" />
    <td align="left"> 			
		<% if ("ucform".equals(ics.GetVar("cs_environment"))) {%>
			<a href="javascript:parent.fw.ui.app.clearMessage();submitForm('cancel');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></a>
		<% } else {%>
			<a href="javascript:submitForm('cancel')"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></a>
		<% } %>
		<% if (!"ucform".equals(ics.GetVar("cs_environment"))) {%>
			<xlat:lookup key="dvin/AT/Common/SelectFromTree" varname="_XLAT_alt"/>
			<a href="javascript:pickFromTree('localeName', 'localeID', 'Dimension')" alt='<%=ics.GetVar("_XLAT_alt")%>' title='<%=ics.GetVar("_XLAT_alt")%>'><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems"/></ics:callelement></a>
		<% } %>
		<% if ("ucform".equals(ics.GetVar("cs_environment"))) {%>
			<a href="javascript:parent.fw.ui.app.clearMessage(); submitForm('save');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/SaveChanges"/></ics:callelement></a>
		<% } else {%>
			<a href="javascript:submitForm('save')"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/SaveChanges"/></ics:callelement></a>
		<% } %>
    </td>
</tr>
</table>
<input type="hidden" name="localeName" id="localeName"/>
<input type="hidden" name="localeID" id="localeID"/>
<input type="hidden" name="tmpTree" value="<string:stream value='<%=sTempTree%>'/>"/>
</cs:ftcs>
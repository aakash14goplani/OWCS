<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyPost
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.util.*" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%!
	public static final String TREENAME = "LocaleTree";

	String getRootNode(ICS ics)	throws Exception
	{	FTValList params = new FTValList();
		params.put("ftcmd", "findnode");
		params.put("treename", TREENAME);
		params.put("where", "otype,oid");
		params.put("otype", "DimensionSet");
		params.put("oid", ics.GetVar("DimensionSet:id"));
		ics.TreeManager(params);

		IList ilist = ics.GetList(TREENAME);
		if (null != ilist && ilist.hasData())
		{	return (ilist.getValue("nid"));
		}

		return (null);
	}

	void saveTree(JspWriter out, ICS ics, HashMap<String, Object> hmTree, String sParentID, String sCurID) throws Exception
	{
		FTValList params = new FTValList();
		params.put("ftcmd", "addchild");
		params.put("treename", TREENAME);

		IList iListTemp;

		if (sParentID == null)
		{	//params.put("nparentid", "0");
			params.put("otype", "DimensionSet");
			params.put("oid", ics.GetVar("DimensionSet:id"));
			ics.TreeManager(params);

			iListTemp = ics.GetList(TREENAME);
			sParentID = iListTemp.getValue("nid");
			sCurID = (String)((ArrayList)hmTree.get( ics.GetVar("DimensionSet:id") )).get(0);
		}

		params.put("nparentid", sParentID);
		params.put("otype", "Dimension");
		params.put("oid", sCurID);

		ics.TreeManager(params);

		iListTemp = ics.GetList(TREENAME);
		sParentID = iListTemp.getValue("nid");

		ArrayList<String> alistChildren = (ArrayList)hmTree.get(sCurID);
		if (null != alistChildren)
		{	for (int i = 0, l = alistChildren.size(); i < l; i++)
			{	saveTree(out, ics, hmTree, sParentID, alistChildren.get(i));
			}
		}
	}

	void deleteTree(ICS ics) throws Exception
	{	String sRootNode = getRootNode(ics);

		if (null != sRootNode)
		{	FTValList params = new FTValList();
			params.put("ftcmd", "delchild");
			params.put("treename", TREENAME);
			params.put("node", sRootNode);
			ics.TreeManager(params);
		}
	}

	HashMap<String, Object> toHashMap(String sTempTree)
	{	StringTokenizer st = new StringTokenizer(sTempTree, ",");
		HashMap<String, Object> hmTree = new HashMap<String, Object>();

		ArrayList<String> alistTemp;
		while (st.hasMoreTokens())
		{	String sToken = st.nextToken().trim();

			if (sToken.length() == 0)
				continue;

			int iIndex = sToken.indexOf(":");
			String sParentID = sToken.substring(0, iIndex);
			String sNodeID = sToken.substring(iIndex+1);

			alistTemp = (ArrayList)hmTree.get(sParentID);

			if (null == alistTemp)
			{	alistTemp = new ArrayList<String>();
				hmTree.put(sParentID, alistTemp);
			}
			alistTemp.add(sNodeID);
		}

		return (hmTree);
	}
%>
<cs:ftcs>

<!-- user code here -->
<%
	String sFormAction = ics.GetVar("form_action");

	if ("delete".equals(sFormAction))
	{	deleteTree(ics);
		%><ics:callelement element="OpenMarket/Xcelerate/UIFramework/AdminPage"><%
			%><ics:argument name="ThisPage" value='LocaleHierarchy/LocaleHierarchyView' /><%
		%></ics:callelement><%
	}
	else if ("cancel".equals(sFormAction))
	{	%><ics:callelement element="OpenMarket/Xcelerate/UIFramework/AdminPage"><%
			%><ics:argument name="ThisPage" value='LocaleHierarchy/LocaleHierarchyView' /><%
		%></ics:callelement><%
	}
	else if ("save".equals(sFormAction))
	{	// Saving the tree

		// First, delete the old tree
		deleteTree(ics);

		// Resave the tree
		if (ics.GetVar("tmpTree") != null && !"null".equals(ics.GetVar("tmpTree")))
        {
            HashMap hmTree = toHashMap(ics.GetVar("tmpTree"));
            saveTree(out, ics, hmTree, null, null);
        }

		%><ics:callelement element="OpenMarket/Xcelerate/UIFramework/AdminPage"><%
			%><ics:argument name="ThisPage" value='LocaleHierarchy/LocaleHierarchyView' /><%
		%></ics:callelement><%

        // Resave the DimensionSet asset so that the new tree can be published
		%><asset:load name="as" type="DimensionSet" objectid='<%=ics.GetVar("DimensionSet:id")%>' option="editable" /><%
		%><asset:save name="as" /><%
	}
	else if ("remove".equals(sFormAction))
    {   // Remove an element from the tree
        String sTempTree = ics.GetVar("tmpTree");
        String sLocaleID = ics.GetVar("localeID");

        String sTempOutput = "";

        StringTokenizer st = new StringTokenizer(sTempTree, ",");
        while (st.hasMoreTokens())
        {
            String sToken = st.nextToken();
            if (sToken.indexOf(sLocaleID) < 0)
            {
                if (sTempOutput.length() > 0)
                    sTempOutput += ',';
                sTempOutput += sToken;
            }
        }

        sTempTree = sTempOutput;
        ics.SetVar("tmpTree", sTempTree);

		%><ics:callelement element="OpenMarket/Xcelerate/UIFramework/AdminPage"><%
			%><ics:argument name="ThisPage" value='LocaleHierarchy/LocaleHierarchyEdit' /><%
		%></ics:callelement><%
    }
	else if ("step".equals(sFormAction))
	{	String sTempTree = ics.GetVar("tmpTree");
		String sLocaleID = ics.GetVar("localeID");
		String sLocaleName = ics.GetVar("localeName");

		if (null == sTempTree || "null".equals(sTempTree))
		{	sTempTree = "";
		}

		if (null != sLocaleID)
		{	String sParentNode = ics.GetVar("parent_node");
			if (null == sParentNode)
				sParentNode = ics.GetVar("DimensionSet:id");

			if (sTempTree.length() > 0)
				sTempTree += ',';
			sTempTree += sParentNode+':'+sLocaleID;
		}

		ics.SetVar("tmpTree", sTempTree);

		%><ics:callelement element="OpenMarket/Xcelerate/UIFramework/AdminPage"><%
			%><ics:argument name="ThisPage" value='LocaleHierarchy/LocaleHierarchyEdit' /><%
		%></ics:callelement><%
	}
%>
</cs:ftcs>
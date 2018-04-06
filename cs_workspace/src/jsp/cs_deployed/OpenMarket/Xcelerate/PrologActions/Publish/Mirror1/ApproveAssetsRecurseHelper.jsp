<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/Mirror1/ApproveAssetsRecurseHelper
//
// INPUT
//      anAsset
//      target
//      force
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.openmarket.basic.interfaces.IListObject" %>
<%@ page import="com.openmarket.basic.interfaces.ListObjectFactory" %>
<%@ page import="com.fatwire.assetapi.data.AssetId" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<cs:ftcs>

<%--<asset:get name="anAsset" field='name'/>--%>
<%--<asset:get name="anAsset" field='id'/>--%>
<%--<ics:logmsg msg='<%="DEBUG: Executing ApproveAssetsR on "+ ics.GetVar("name") +" - "+ics.GetVar("id")%>'/>--%>

<%
//    ics.LogMsg("DEBUG: ApproveAssetsRecurseHelper");
    HashSet approvalSet = new HashSet();
    if (ics.GetObj("approvalSet")!=null)
    {
        approvalSet = (HashSet)ics.GetObj("approvalSet");
    }
    else
    {
        ics.SetObj("approvalSet", approvalSet);
    }
%>
    <asset:getpubdeps name="anAsset" depth="1" list="oneLevelofDeps"/>
<%
    IListObject listObj = ListObjectFactory.newListObject();
    listObj.setColumns("assettype,assetid");
    IList oneLevelofDeps = ics.GetList("oneLevelofDeps");
//    ics.LogMsg("DEBUG: oneLevelofDeps size: "+oneLevelofDeps.numRows());
    for (int i = 1; oneLevelofDeps.moveTo(i); i++)
    {
        listObj.startNewRow();
        listObj.setColumnValue("assettype", oneLevelofDeps.getValue("otype"));
        listObj.setColumnValue("assetid", oneLevelofDeps.getValue("oid"));
    }
    ics.RegisterList("deplist",listObj.getList());

    if (ics.GetVar("force").equals("false")){
        FTValList list = new FTValList();
        list.setValString("LISTVARNAME", "depsToApprove");
        list.setValString("LIST", "deplist");
        list.setValString("TEMPLATEDEPS", "true");
        list.setValString("TARGET", ics.GetVar("target"));
        ics.runTag("ApprovedAssets.FindUnapprovedAssets", list);
    }
    else{
        ics.CopyList("deplist", "depsToApprove");
    }

    IList depsToApprove = ics.GetList("depsToApprove");
//    ics.LogMsg("DEBUG: depsToApprove: "+depsToApprove.numRows());
    if (depsToApprove != null && depsToApprove.hasData())
    {
        Map<String,String> depsToApproveMap = new HashMap<String,String>();
        for (int i = 1; depsToApprove.moveTo(i); i++)
        {
            //seperate by assetType so that it can be used effectively with LoadAll
            String assettype = depsToApprove.getValue("assettype");
            String assetid = depsToApprove.getValue("assetid");

            //if already exist in approval, dont bother adding to prevent infinite recursion
            if (!approvalSet.contains(assettype+"_"+assetid)){
//                ics.LogMsg("DEBUG: ****"+assettype+"****"+assetid+"**** added");
                approvalSet.add(assettype+"_"+assetid);
                if (depsToApproveMap.get(assettype)!=null)
                {
                    depsToApproveMap.put(assettype,depsToApproveMap.get(assettype)+","+assetid);
                }
                else
                {
                    depsToApproveMap.put(assettype,assetid);
                }
            }
        }

        if (!depsToApproveMap.isEmpty())
        {
            for (String assettype : depsToApproveMap.keySet())
            {
                %>
                <asset:loadall prefix="_dependents" type='<%=assettype%>' ids='<%=depsToApproveMap.get(assettype)%>'/>
                <%
                Map<String, Object> tempMap = new HashMap<String, Object>();
                for(int i=0;i<Integer.parseInt(ics.GetVar("_dependentsTotal"));i++)
                {
                    tempMap.put("_dependents"+i, ics.GetObj("_dependents"+i));
                }
                for (String key : tempMap.keySet())
                {
                    //recurse the current dep for next level of dependencies
                    ics.SetObj("anAsset", tempMap.get(key));
                    FTValList lin = new FTValList();
                    lin.setValString("target", ics.GetVar("target"));
                    lin.setValString("force", ics.GetVar("force"));
                    ics.CallElement("OpenMarket/Xcelerate/PrologActions/Publish/Mirror1/ApproveAssetsRecurseHelper", lin);

                    // Add to java-friendly dependency accumulator in case caller wants to know.
                    // Combined with a dry run, this will tell the caller what dependencies would have gotten approved
                    // without actually approving; otherwise this tells caller what deps actually got approved in addition to
                    // the asset(s) supplied as input
                    HashSet<AssetId> acc = (HashSet<AssetId>)ics.GetObj("myUnapprovedDependencies");
                    if(null == acc)
                    {
                        acc = new HashSet();
                        ics.SetObj("myUnapprovedDependencies", acc);
                    }
                    acc.add(new com.openmarket.xcelerate.asset.AssetIdImpl(
                            assettype,
                            Long.parseLong(((com.openmarket.xcelerate.interfaces.IAsset)tempMap.get(key)).Get("id"))));

                    if(!"true".equalsIgnoreCase(ics.GetVar("dryrun")))
                    {
                        //if this is not a dry run, approve the current dep
	                    lin = new FTValList();
	                    ics.SetObj("anAsset", tempMap.get(key));
	                    lin.setValString("assetname", "anAsset");
	                    lin.setValString("target", ics.GetVar("target"));
	                    ics.CallElement("OpenMarket/Xcelerate/PrologActions/Publish/Mirror1/ApproveAsset", lin);
                    }
                    %>
                    <%--<asset:get name="anAsset" field='name'/>--%>
                    <%--<asset:get name="anAsset" field='id'/>--%>
                    <%--<ics:logmsg msg='<%="DEBUG: Approved "+ ics.GetVar("name") +" - "+ics.GetVar("id")%>'/>--%>
                    <%
                }
            }
        }
    }
%>
</cs:ftcs>
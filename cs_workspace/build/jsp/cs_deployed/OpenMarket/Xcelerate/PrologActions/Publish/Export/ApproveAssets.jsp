<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/Export/ApproveAssets
//
// INPUT
//      list -- IList of assets to be approved
//      recursive -- (boolean)approve dependencies or not
//      force -- (boolean)force approval or not
//      target -- target id      
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.HashSet" %>
<cs:ftcs>

<%
	ics.SetVar("recursive", "false");
    //create set to hold approvals for this request
    HashSet approvalSet = new HashSet();
    if (ics.GetObj("approvalSet")!=null)
    {
        approvalSet = (HashSet)ics.GetObj("approvalSet");    
    }
    else
    {
        ics.SetObj("approvalSet", approvalSet);
    }

    FTValList list = new FTValList();
    list.setValString("ID", ics.GetVar("target"));
    list.setValString("OBJVARNAME", "pubtgt");
    ics.runTag("PUBTARGETMANAGER.LOAD", list);

    list = new FTValList();
    list.setValString("NAME", "pubtgt");
    list.setValString("PREFIX", "pubfact:");
    ics.runTag("PUBTARGET.SCATTER", list);

    list = new FTValList();
    list.setValString("NAME", "pubtgt");
    list.setValString("PREFIX", "pubfact:");
    list.setValString("FIELD", "factors");
    ics.runTag("PUBTARGET.UNPACK", list);

    if (ics.GetVar("force").equals("false"))
    {
        list = new FTValList();
        list.setValString("LISTVARNAME", "unApprovedList");
        list.setValString("LIST", ics.GetVar("list"));
        list.setValString("TEMPLATEDEPS", "true");
        list.setValString("TARGET", ics.GetVar("target"));
        ics.runTag("ApprovedAssets.FindUnapprovedAssets", list);
    }
    else
    {
        //copy list to unApprovedList
        ics.CopyList(ics.GetVar("list"), "unApprovedList");
    }

    //create approvals
    if (ics.GetErrno()==0)
    {
        list = new FTValList();
        list.setValString("OBJVARNAME", "approvals");
        ics.runTag("Approvals.create", list);
    }

    //loop through unapproved assets, get their deps, and add them to approvals
    if (ics.GetErrno()==0)
    {
        IList unapprovedList = ics.GetList("unApprovedList");
        for (int i=1; unapprovedList.moveTo(i);i++)
        {
            if (!approvalSet.contains(unapprovedList.getValue("assettype")+"_"+unapprovedList.getValue("assetid")))
            {
                ics.SetVar("rendererror", "0");
                %>
                <asset:load name="asset" type='<%=unapprovedList.getValue("assettype")%>' objectid='<%=unapprovedList.getValue("assetid")%>'/>        
                <%
                if (ics.GetErrno()==0)
                {
                    ics.SetVar("asset:pagename", "");
                    if (ics.ResolveVariables("Variables.pubfact:OLDTEMPLATE").equals("true"))
                    {
                        ics.SetVar("asset:pagename", "OpenMarket/Xcelerate/Export");
                    }
                    else
                    {
                        list = new FTValList();
                        list.setValString("NAME", "asset");
                        list.setValString("TARGET", ics.GetVar("target"));
                        list.setValString("SITE", ics.GetSSVar("PublicationName"));
                        list.setValString("OUTPUT", "asset:pagename");
                        ics.runTag("ASSET.GetTemplatePageName", list);
                        
                        if (ics.GetErrno()<0)
                        {
                            //error getting pagename - do not approve it 
                            ics.SetVar("rendererror", "-30");
                            %>
                            <asset:get name="asset" field="name" output="asset:name"/>
                            <xlat:lookup key="dvin/UI/Publish/renderedPageError" varname="_xlat_render" evalall="false">
                                <xlat:argument name="errno" value='<%=ics.GetVar("rendererror")%>'/>
                                <xlat:argument name="asset:pagename" value='<%=ics.GetVar("asset:pagename")%>'/>
                                <xlat:argument name="asset:name" value='<%=ics.GetVar("asset:name")%>'/>
                            </xlat:lookup>
                            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
                                <ics:argument name="severity" value="error"/>
                                <ics:argument name="msgtext" value='<%=ics.GetVar("_xlat_render")%>'/>
                            </ics:callelement>
                            <%
                        }
                    }

                    if (ics.GetVar("asset:pagename")!=null && ics.GetVar("asset:pagename").length()>0)
                    {
                        int wrapperidx = ics.GetVar("asset:pagename").indexOf("WRAPPERPAGE");
                        //no wrapper page found
                        if (wrapperidx==-1)
                        {
                            list = new FTValList();
                            list.setValString("PAGENAME", ics.GetVar("asset:pagename"));
                            list.setValString("cid", unapprovedList.getValue("assetid"));
                            list.setValString("c", unapprovedList.getValue("assettype"));
                            list.setValString("TARGET", ics.GetVar("target"));
                            ics.runTag("RENDER.GETDEPS", list);
                        }
                        //wrapper page, find the pagename and wrapperpagename params
                        else
                        {
                            wrapperidx = wrapperidx - 1;
                            String pname = ics.GetVar("asset:pagename").substring(0, wrapperidx);
                            wrapperidx = wrapperidx + 13;
                            String wrapperpname = ics.GetVar("asset:pagename").substring(wrapperidx);
                            list = new FTValList();
                            list.setValString("PAGENAME", pname);
                            list.setValString("WRAPPERPAGE", wrapperpname);
                            list.setValString("cid", unapprovedList.getValue("assetid"));
                            list.setValString("c", unapprovedList.getValue("assettype"));
                            list.setValString("TARGET", ics.GetVar("target"));
                            ics.runTag("RENDER.GETDEPS", list);
                        }

                        //ignore no children or no rows since these are generally not errors
                        if (ics.GetErrno()!=0 && ics.GetErrno()!=-111 && ics.GetErrno()!=-101)
                        {
                            // an error from the template does not necssarily mean the approval shouldn't happen
                            // display an information error but continue
                            ics.SetVar("rendererror", ics.GetErrno());
                            %>
                            <asset:get name="asset" field="name" output="asset:name"/>
                            <xlat:lookup key="dvin/UI/Publish/renderedPageError" varname="_xlat_render" evalall="false">
                                <xlat:argument name="errno" value='<%=ics.GetVar("rendererror")%>'/>
                                <xlat:argument name="asset:pagename" value='<%=ics.GetVar("asset:pagename")%>'/>
                                <xlat:argument name="asset:name" value='<%=ics.GetVar("asset:name")%>'/>
                            </xlat:lookup>
                            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
                                <ics:argument name="severity" value="info"/>
                                <ics:argument name="msgtext" value='<%=ics.GetVar("_xlat_render")%>'/>
                            </ics:callelement>
                            <%
                        }
                    }
                    //if error is pagenotfound, do not approve the asset
                    if (!ics.GetVar("rendererror").equals("-30"))
                    {
                        list = new FTValList();
                        list.setValString("NAME", "approvals");
                        list.setValString("ASSET", "asset");
                        ics.runTag("Approvals.add", list);

                        approvalSet.add(unapprovedList.getValue("assettype")+"_"+unapprovedList.getValue("assetid"));
                    }
                }
                else
                {
                    %>
                    <xlat:stream key="dvin/UI/Error/loadingassetassettypeunApprovedList" evalall="false">
                        <xlat:argument name="errno" value='<%=String.valueOf(ics.GetErrno())%>'/>
                        <xlat:argument name="assettype" value='<%=unapprovedList.getValue("assettype")%>'/>
                        <xlat:argument name="assetid" value='<%=unapprovedList.getValue("assetid")%>'/>
                    </xlat:stream>
                    <br/>
                    <%
                }
            }
        }

        //if recursive
        if (ics.GetVar("recursive").equals("true"))
        {
            list = new FTValList();
            list.setValString("NAME", "approvals");
            list.setValString("LISTVARNAME", "depsList");
            ics.runTag("Approvals.GetDeps", list);

            list = new FTValList();
            list.setValString("OBJECT", "approvals");
            list.setValString("TARGET", ics.GetVar("target"));
            list.setValString("TEMPLATEDEPS", "true");
            ics.runTag("APPROVEDASSETS.APPROVEASSETS", list);

            if (ics.GetErrno()<0)
            {
                %>
                <xlat:stream key="dvin/UI/Error/approveassetsError" evalall="false">
                    <xlat:argument name="errno" value='<%=String.valueOf(ics.GetErrno())%>'/>
                    <xlat:argument name="errdetail1" value='<%=ics.GetVar("errdetail1")%>'/>
                </xlat:stream>
                <br/>
                <%
            }

            if (ics.GetVar("force").equals("false"))
            {
                list = new FTValList();
                list.setValString("LISTVARNAME", "unApprovedDepsList");
                list.setValString("LIST", "depsList");
                list.setValString("TEMPLATEDEPS", "true");
                list.setValString("TARGET", ics.GetVar("target"));
                ics.runTag("ApprovedAssets.FindUnapprovedAssets", list);
            }
            else
            {
                ics.CopyList("depsList", "unApprovedDepsList");
            }

            IList tempList = ics.GetList("unApprovedDepsList");
            for (int i=1; tempList.moveTo(i); i++)
            {
                if (!approvalSet.contains(tempList.getValue("assettype")+"_"+tempList.getValue("assetid")))
                {
                    //create new deplist and recurse through it.
                    %>
                    <listobject:create name="tempDepList" columns="assettype,assetid"/>
                    <listobject:addrow name="tempDepList">
                    <listobject:argument name="assettype" value='<%=tempList.getValue("assettype")%>'/>
                    <listobject:argument name="assetid" value='<%=tempList.getValue("assetid")%>'/>
                    </listobject:addrow>
                    <listobject:tolist name="tempDepList" listvarname="depToRecurse"/>

                    <ics:callelement element="OpenMarket/Xcelerate/PrologActions/Publish/Export/ApproveAssets">
                          <ics:argument name="list" value="depToRecurse"/>
                          <ics:argument name="recursive" value='<%=ics.GetVar("recursive")%>'/>
                          <ics:argument name="force" value='<%=ics.GetVar("force")%>'/>
                          <ics:argument name="target" value='<%=ics.GetVar("target")%>'/>
                    </ics:callelement>
                    <%
                }
            }
        }
        else
        {
            list = new FTValList();
            list.setValString("OBJECT", "approvals");
            list.setValString("TARGET", ics.GetVar("target"));
            list.setValString("TEMPLATEDEPS", "true");
            ics.runTag("APPROVEDASSETS.APPROVEASSETS", list);

            if (ics.GetErrno()<0)
            {
                %>
                <xlat:stream key="dvin/UI/Error/approveassetsError" evalall="false">
                    <xlat:argument name="errno" value='<%=String.valueOf(ics.GetErrno())%>'/>
                    <xlat:argument name="errdetail1" value='<%=ics.GetVar("errdetail1")%>'/>
                </xlat:stream>
                <%
            }
        }
    }
%>

</cs:ftcs>
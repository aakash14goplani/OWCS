<%@ page contentType="text/html; charset=UTF-8"
		import="COM.FutureTense.Interfaces.IList,
				COM.FutureTense.Interfaces.FTValList,
				com.openmarket.gator.interfaces.IFlexGroupTemplateManager,
				com.openmarket.gator.interfaces.ITemplateAssetInstance,
				com.openmarket.gator.interfaces.ITemplateableAssetManager,
				com.openmarket.assetframework.interfaces.AssetTypeManagerFactory,
				com.openmarket.assetframework.interfaces.IAssetTypeManager,
				java.util.Hashtable,
				java.util.StringTokenizer" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/AssocParents
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<!-- user code here -->
<hash:create name='NoGroupsForTemplate'/>
<hash:create name='TreeTmpls'/>
<hash:create name='FolderTmpls'/>
<hash:create name='AbsenteeParents'/>
    
<%
ics.SetCounter("selectBoxes", 0);

Hashtable enabledParents = (Hashtable) ics.GetObj("enabledParents");

IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
IFlexGroupTemplateManager fgtm = (IFlexGroupTemplateManager)atm.locateAssetManager(ics.GetVar("GroupTemplateType"));

ITemplateAssetInstance ita = (ITemplateAssetInstance)ics.GetObj(ics.GetVar("TemplateInstance"));
IList tmplparents = ita.getParentGroupTemplates();
ics.RegisterList("TmplParents",tmplparents);

IList tmpllist = null;
%>
<assettype:load name='type' type='<%=ics.GetVar("grouptype")%>'/>
<assettype:scatter name='type' prefix='AssetTypeObj'/>

<hash:create name='SelectedGroups'/>

<% ics.SetCounter("currentParentTmpl", 0); %>

<ics:if condition='<%=ics.GetVar("errno").equals("0")%>'>
<ics:then>
	<ics:if condition='<%=tmplparents!=null%>'>
	<ics:then>
		<%
			int totalParentTmpls = 0;
		%>
         	<!--lstOfParents Variable is used to pass the list of originial parents of an asset to AssetGather.jsp--> 
        <!--on asset save, we need to refresh the tree to remove the asset from the original parents nodes-->  <%
        String strParents = ics.GetVar("lstOfParents");
        boolean repost = false;
        if (strParents != null)
            repost = true;
        %>
            	
        <ics:if condition='<%=tmplparents.hasData()%>'>
		<ics:then>
			<ics:listloop listname='TmplParents'>
                <asset:list type='<%=ics.GetVar("GroupTemplateType")%>' list='tmplList' field1='id' value1='<%=tmplparents.getValue("assetid")%>'/>

				<%
				tmpllist = ics.GetList("tmplList"); %>
                <hash:create name='<%="hSelected"+tmpllist.getValue("name")%>'/> <%
				if (enabledParents == null || enabledParents.containsKey(tmpllist.getValue("name"))) {
					if (totalParentTmpls ==0) {
						//Display the parent section header only if at least 1 parent is enabled.
					}
					totalParentTmpls++;

					boolean usePathLike = "DM".equalsIgnoreCase(ics.GetVar("cs_formmode")) &&
						fgtm.isPathLike(tmplparents.getValue("assetid"));
					if (usePathLike) {
						Hashtable hPathParents = (Hashtable) ics.GetObj("FolderTmpls");
						hPathParents.put(tmplparents.getValue("assetid"), tmplparents.getValue("assetid"));
					} else {
						ics.SetVar("required", (ita.getParentGroupRequired(tmplparents.getValue("assetid"))?"true":"false"));
						ics.SetVar("multiple", (ita.getParentGroupMultiple(tmplparents.getValue("assetid"))?"true":"false"));

                        boolean bThisDefHasParents = false;
						if (ics.GetVar("multiple").equals("false")) {
							 if (ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name"))!=null) {
                                String deleteTest = ics.GetVar("d"+ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")));

                                %><!--Only collects the original parents ie. When edit it clicked and first time AssocParents gets called--><%
                                if (repost != true){
                                                 
                                      if (strParents != null)
                                      {
                                            String id = ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name"));
                                            if (strParents.indexOf(id) == -1)
                                            {
                                                 strParents =  strParents + ";" + id;
                                            }
                                      }
                                      else
                                      {
                                            strParents = ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name"));
                                      }
                               }
 

                                if (deleteTest == null || !"deleted".equals(deleteTest)) {
                                  bThisDefHasParents = true; %>
                                  <hash:add name='<%="hSelected"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name"))%>'/>
								  <hash:add name='SelectedGroups' value='<%=ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name"))%>'/> <%
                                }
								else
                                {
									//Added to retain the parent def id that was removed
                                %>
									<INPUT TYPE="hidden" NAME="<%="d"+ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name"))%>" VALUE="deleted"/>
                                <%
                                }
							}else if(ics.GetVar("_parentAssetName") != null){
								%>
									<hash:add name='<%="hSelected"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("ID")%>'/>
								  <hash:add name='SelectedGroups' value='<%=ics.GetVar("ID")%>'/>
								<%
							}
						} else {
							String total = ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")+":Total");
							int multiParentCount = total == null ? 0 : Integer.parseInt(total);
							for (int i = 0; i < multiParentCount; i++) {
                                String deleteTest = ics.GetVar("d"+ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")+":"+i));

                                    %><!--Only collects the original parents ie. When edit it clicked and first time AssocParents gets called--><%
                                  if (repost != true){

                                        if (strParents != null)
                                        {
                                              String id = ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")+":"+i);
                                              if (strParents.indexOf(id) == -1)
                                              {
                                                  strParents =  strParents + ";" + id;
                                              }
                                        }
                                        else
                                        {
                                            strParents = ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")+":"+i);
                                        }
                                  }

                                if (deleteTest == null || !"deleted".equals(deleteTest)) {
                                  bThisDefHasParents = true; %>
                                  <hash:add name='<%="hSelected"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")+":"+i)%>'/>
                                  <hash:add name='SelectedGroups' value='<%=ics.GetVar("ContentDetails:Group_"+tmpllist.getValue("name")+":"+i)%>'/> <%
                                }
							}
						} %>

                        <input type="hidden" name="<%="_ParentDef_"+tmpllist.getValue("name")+"_HasParents_"%>" value="<%=bThisDefHasParents%>">

						<ics:setvar name='<%="req"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("required")%>'/>
						<ics:setvar name='<%="mult"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("multiple")%>'/>
                        <ics:setvar name='<%="_id_"+tmpllist.getValue("name")%>' value='<%=tmpllist.getValue("id")%>'/>
						<listobject:create name='singleTmpl' columns='assetid'/>
						<listobject:addrow name='singleTmpl'>
							<listobject:argument name='assetid' value='<%=tmplparents.getValue("assetid")%>'/>
						</listobject:addrow>
						<listobject:tolist name='singleTmpl' listvarname='currentList'/>
						<%
						ITemplateableAssetManager itam = (ITemplateableAssetManager)ics.GetObj(ics.GetVar("GroupManager"));
						IList myparentgroups = itam.getSortedTypedAssets(ics.GetSSVar("pubid"),ics.GetList("currentList"));

						ics.RegisterList("MyParentGroups",myparentgroups);
                        ics.ClearErrno(); %>

						<ics:setvar name='SelectionStyle' value='<%=tmpllist.getValue("style")%>'/>
						<ics:if condition='<%="false".equals(ics.GetVar("showSiteTree"))%>'>
						<ics:then>
							<ics:setvar name='SelectionStyle' value='S'/>
						</ics:then>
						</ics:if>

						<ics:if condition='<%=!(ics.GetVar("SelectionStyle").equals("T")) && !("A".equals(ics.GetVar("SelectionStyle")))%>'>
						<ics:then>

							<ics:if condition='<%=ics.GetVar("errno").equals("0")%>'>
							<ics:then>
								<ics:if condition='<%=myparentgroups!=null%>'>
								<ics:then>
									<ics:if condition='<%=myparentgroups.hasData()%>'>
									<ics:then>
										<% ics.SetCounter("currentParentTmpl", ics.GetCounter("currentParentTmpl")+1); %>
										<INPUT TYPE="hidden" NAME="<%="_ParentDef_"+ics.GetCounter("currentParentTmpl")+"_Info_"%>" VALUE="<%=ics.GetVar("required")+","+ics.GetVar("multiple")+","+tmpllist.getValue("name")+","+tmpllist.getValue("id")%>"/>
										<% ics.SetCounter("selectBoxes", ics.GetCounter("selectBoxes")+1); %>
									</ics:then>
									<ics:else>
										<hash:add name='NoGroupsForTemplate' value='<%=tmpllist.getValue("name")%>'/>
									</ics:else>
									</ics:if>
								</ics:then>
								</ics:if>
							</ics:then>
							</ics:if>
							<%
								String templateName = tmpllist.getValue("description");
								if("".equals(templateName)) templateName = tmpllist.getValue("name");
							%>
							<ics:setvar name='AttrID' value='<%=tmpllist.getValue("id")%>'/>
							<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/ParentSelectDialogs'>
								<ics:argument name='parentCount' value='<%=String.valueOf(ics.GetCounter("selectBoxes"))%>'/>
								<ics:argument name='templateName' value='<%=templateName%>'/>
							</ics:callelement>
						</ics:then>
						<ics:else> <!-- pick these parents from tree -->
							<ics:if condition='<%=ics.GetVar("errno").equals("0")%>'>
							<ics:then>
                                <ics:if condition='<%=myparentgroups==null || !myparentgroups.hasData()%>'>
								<ics:then>
                                  <hash:add name='NoGroupsForTemplate' value='<%=tmpllist.getValue("name")%>'/>
                                </ics:then>
                                </ics:if>
								<hash:add name='TreeTmpls' value='<%=tmpllist.getValue("name")%>'/>
							</ics:then>
							</ics:if>
						</ics:else>
						</ics:if>
					<%
					}
				}
                //Empty the hash
                Hashtable storedGroups = (Hashtable)ics.GetObj("SelectedGroups");
                storedGroups.clear();
                %>
			</ics:listloop>
            <!-- if any selected parents aren't available parents then they are parents from another site so we need to preserve -->
            <%
              Hashtable selectedParents = (Hashtable) ics.GetObj("SelectedGroups");
              boolean inputIt = false;

              for (java.util.Iterator it = selectedParents.keySet().iterator(); it.hasNext();) {
				String currentParent = (String) it.next();
                ics.ClearErrno(); %>
                <asset:list type='<%=ics.GetVar("grouptype")%>' list='lCurrentParent' field1='id' value1='<%=currentParent%>' pubid='<%=ics.GetSSVar("pubid")%>'/> <%
                if (ics.GetErrno()!=0) {
                  inputIt = true; %>
                  <hash:add name='AbsenteeParents' value='<%=currentParent%>'/> <%
                }
              }
              if (inputIt) { %>
                <hash:tostring name='AbsenteeParents' varname='cs_AbsenteeParents' delim=';'/>
                <input type="hidden" name="cs_AbsenteeParents" value="<%=ics.GetVar("cs_AbsenteeParents")%>"/> <%
              }
            %>
		</ics:then>
		</ics:if>
		<INPUT TYPE="hidden" NAME="totalParentTmpls" VALUE="<%=totalParentTmpls%>"/>

        <INPUT TYPE="hidden" NAME="lstOfParents" VALUE='<string:stream value='<%=strParents%>'/>' />

    </ics:then>
	</ics:if>
</ics:then>
</ics:if>

<!-- TreeTmpls Starts -->
<%
Hashtable treetmpls = (Hashtable) ics.GetObj("TreeTmpls");
Hashtable folders = (Hashtable) ics.GetObj("FolderTmpls");
if (!(treetmpls.isEmpty() && folders.isEmpty())) {
	ics.SetCounter("selectBoxes", ics.GetCounter("selectBoxes")+1);
	%>
	<hash:create name='ParentPost'/>
    <%
	if (!folders.isEmpty()) {
		ics.CallElement("OpenMarket/Gator/FlexibleAssets/Common/ParentFolderSelect", null);
	}
	if (!treetmpls.isEmpty()) {
		ics.CallElement("OpenMarket/Gator/FlexibleAssets/Common/ParentTreeSelect", null);
	}
	%>
	<hash:tostring name='ParentPost' delim=';' varname='parentpost'/>
 	<INPUT TYPE="hidden" NAME="<%="_ParentDef_"+ics.GetCounter("selectBoxes")+"_SelectedParents_"%>" VALUE="<%=ics.GetVar("parentpost")%>"/>
	<INPUT TYPE="hidden" NAME="ParentSelect" VALUE=""/>
	<%
}
%>
<INPUT TYPE="hidden" NAME="numTreeTmpls" VALUE="<%=treetmpls.size()+folders.size()%>"/>
<!-- TreeTmpls Ends -->

<hash:hasdata name='NoGroupsForTemplate' varname='hasdata'/>
<ics:if condition='<%=ics.GetVar("hasdata").equals("true")%>'>
<ics:then>
	<hash:tostring name='NoGroupsForTemplate' delim=',' varname='nogroups'/>
	<%
      StringTokenizer st = new StringTokenizer(ics.GetVar("nogroups"), ",");
      while (st.hasMoreTokens())
      {
        String currentToken = st.nextToken();
        ics.SetCounter("currentParentTmpl", ics.GetCounter("currentParentTmpl")+1); %>

		<INPUT TYPE="hidden" NAME="<%="_ParentDef_"+ics.GetCounter("currentParentTmpl")+"_Info_"%>" VALUE="<%=ics.GetVar("req"+currentToken)+","+ics.GetVar("mult"+currentToken)+","+currentToken+","+ics.GetVar("_id_"+currentToken)%>"/>
    <% } %>
</ics:then>
</ics:if>

<INPUT TYPE="hidden" NAME="numParents" VALUE="<%=ics.GetCounter("selectBoxes")%>"/>

<!-- End Associating Groups -->
</cs:ftcs>
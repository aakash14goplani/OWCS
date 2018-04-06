<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">

    <div dojoType="dijit.layout.ContentPane" region="top">
        <div class='toolbarContent'>
            <table>
                <tr>
                    <td align="left">
                      <a href="javascript:void(0)"
                        onclick="document.getElementById('btn_cancel').src='<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/goBackClick.png';return cancelRuleForm();"
                        onmouseover="window.status='Go Back';document.getElementById('btn_cancel').src='<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/goBackHover.png';return true;"
                        onmouseout="window.status='';document.getElementById('btn_cancel').src='<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/goBack.png';return true;">
                        <img id="btn_cancel" src="<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/goBack.png" title="<xlat:stream key="dvin/UI/Cancel"/>" align="absmiddle" border="0" />
                      </a>
                      <a href="javascript:void(0)"
                        onclick="document.getElementById('btn_save').src='<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/btnSaveClick.png';return submitRuleForm();"
                        onmouseover="window.status='Save';document.getElementById('btn_save').src='<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/btnSaveHover.png';return true;"
                        onmouseout="window.status='';document.getElementById('btn_save').src='<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/btnSave.png';return true;">
                        <img id="btn_save" src="<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/ui/toolbar/btnSave.png" title="<xlat:stream key="dvin/UI/Save"/>" align="absmiddle" border="0" />
                      </a></td>
                </tr>
            </table>
        </div>
        <div id="msgArea"></div>
        <div class="toolbarBorder"></div>
    </div>

    <div dojoType="dijit.layout.ContentPane" region="center">

        <div id="ruleStepWizard" data-dojo-type="fw.ui.dijit.StepWizard" data-dojo-props="style:'position:absolute; top:0; bottom:0; left:0; right:0; border: solid #96999c 1px; border-top: none;', nextButtonLabel:'Go on'">

            <div data-dojo-type="fw.ui.dijit.StepWizardPane" data-dojo-props='title:"<span style=\"font-size:17px;margin-right:7px;\">1</span> <xlat:stream key="wcc/rule/step/1" escape="true" encode="true"/>"'>
                <table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><span id="ruleNameIdAtNameTab" class="title-text"></span></td>
                    </tr>
                    <tr>
                        <td><img height="5" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td class="light-line-color"><img height="2" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td><img height="10" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td class="form-label-text">
                                        <span class="alert-color">*</span>
                                        <xlat:stream key="dvin/Common/Name"></xlat:stream>:</td>
                                    <td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
                                    <td id="ruleNameTdId" class="form-inset"><!-- Created by JS: input id="ruleNameId" type="text" size="45" value="" onchange="onRuleNameChange()"/ --></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td class="form-label-text">
                                        <span class="alert-color">*</span>
                                        <xlat:stream key="dvin/Common/Description"></xlat:stream>:</td>
                                    <td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
                                    <td id="ruleDescTdId" class="form-inset">
                                        <!-- Created by JS: input id="ruleDescId" type="text" size="45" value="" onchange="onRuleDescChange()"/--></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td class="form-label-text"><xlat:stream key="dvin/UI/Common/Enabled"></xlat:stream>:</td>
                                    <td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
                                    <td id="ruleEnabledTdId" class="form-inset"></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                            </table></td>
                    </tr>
                </table>
            </div>

            <div data-dojo-type="fw.ui.dijit.StepWizardPane" data-dojo-props='title:"<span style=\"font-size:17px;margin-right:7px;\">2</span> <xlat:stream key="wcc/rule/step/2" escape="true" encode="true"/>"'>
                <table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><span id="ruleNameIdAtRuleTab" class="title-text"></span></td>
                    </tr>
                    <tr>
                        <td><img height="5" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td class="light-line-color"><img height="2" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td><img height="10" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td>
                            <div id="ruleDiv"></div></td>
                    </tr>
                </table>
            </div>

            <div data-dojo-type="fw.ui.dijit.StepWizardPane" data-dojo-props='title:"<span style=\"font-size:17px;margin-right:7px;\">3</span> <xlat:stream key="wcc/rule/step/3" escape="true" encode="true"/>"'>
                <table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><span id="ruleNameIdAtTargetTab" class="title-text"></span></td>
                    </tr>

                    <tr>
                        <td><img height="5" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td class="light-line-color"><img height="2" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td><img height="10" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td>
                            <table class="inner" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td valign="top" class="form-label-text">
                                        <span class="alert-color">*</span>
                                        <xlat:stream key="wcc/rule/label/asset/type"></xlat:stream>:</td>
                                    <td></td>
                                    <td id="asset-type-td" class="form-inset"></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td valign="top" class="form-label-text">
                                        <span class="alert-color">*</span>
                                        <xlat:stream key="wcc/rule/label/asset/subtype"></xlat:stream>:</td>
                                    <td></td>
                                    <td id="asset-subtype-td" class="form-inset"></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td valign="top" class="form-label-text"><xlat:stream key="wcc/rule/label/parents"></xlat:stream>:</td>
                                    <td></td>
                                    <td id="asset-parent-td" class="form-inset"></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img height="20" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                                </tr>
                                <tr>
                                    <td valign="top" class="form-label-text">
                                        <span class="alert-color">*</span>
                                        <xlat:stream key="wcc/rule/label/sites"></xlat:stream>:</td>
                                    <td></td>
                                    <td id="asset-site-td"></td>
                                </tr>
                            </table></td>
                    </tr>
                </table>
            </div>

            <div data-dojo-type="fw.ui.dijit.StepWizardPane" data-dojo-props='title:"<span style=\"font-size:17px;margin-right:7px;\">4</span> <xlat:stream key="wcc/rule/step/4" escape="true" encode="true"/>"'>
                <table class="width70BottomExMargin" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><span id="ruleNameIdAtAttrTab" class="title-text"></span></td>
                    </tr>
                    <tr>
                        <td><img height="5" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td class="light-line-color"><img height="2" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td><img height="10" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td>
                            <table class="inner" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="form-label-text">
                                        <xlat:stream key="wcc/rule/label/asset/type"></xlat:stream>:</td>
                                    <td></td>
                                    <td class="form-inset">
                                        <span id="currentTypeText"></span></td>
                                </tr>
                                <tr>
                                    <td class="form-label-text">
                                        <xlat:stream key="wcc/rule/label/asset/subtype"></xlat:stream>:</td>
                                    <td></td>
                                    <td class="form-inset">
                                        <span id="currentSubtypeText"></span></td>
                                </tr>
                                <tr>
                                    <td class="form-label-text"><xlat:stream key="wcc/console/label/keyfield"></xlat:stream>:</td>
                                    <td></td>
                                    <td class="form-inset">
                                        <span id="currentDocNameFieldText"></span></td>
                                </tr>
                                <tr>
                                    <td class="form-label-text">&nbsp;</td>
                                    <td></td>
                                    <td class="form-inset">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="form-label-text"></td>
                                    <td></td>
                                    <td class="form-inset">

<table class="width-inner-100" border="0" cellpadding="0" cellspacing="0" class="inset">
    <tr>
        <td></td>
        <td class="tile-dark" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
        <td></td>
    </tr>
    <tr>
        <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
        <td >
            <span id="attrMappingTable">
            </span></td>
        <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
    </tr>
    <tr>
        <td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
    </tr>
    <tr>
        <td></td>
        <td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif">
            <IMG WIDTH="1" HEIGHT="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
        <td></td>
    </tr>
</table>									
									
									</td>
                                </tr>
                            </table></td>
                    </tr>
                    <tr>
                        <td><img height="10" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"></td>
                    </tr>
                    <tr>
                        <td>
                            <table class="width-inner-100" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td colspan="3">



							</td>
                                </tr>
                            </table></td>
                    </tr>
                </table>
            </div>

        </div>
    </div>

</div>

</cs:ftcs>

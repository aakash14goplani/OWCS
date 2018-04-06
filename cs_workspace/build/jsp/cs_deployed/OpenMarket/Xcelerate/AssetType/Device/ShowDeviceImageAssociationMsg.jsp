<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/ShowDeviceImageAssociationMsg
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
<%@ page import="COM.FutureTense.Util.ftMessage,COM.FutureTense.Util.ftUtil, COM.FutureTense.Mobility.DeviceHelper" %>
<cs:ftcs>

<ics:if condition='<%=("Y".equalsIgnoreCase(ics.GetVar("Device:enabled")) || "on".equalsIgnoreCase(ics.GetVar("Device:enabled")))%>'>
<ics:then>
<ics:if condition='<%=(ics.GetErrno()== 0)%>'>
   <ics:then>
		<ics:if condition='<%=(!ftUtil.emptyString( ics.GetVar("matchedDevice") ) && !ftUtil.emptyString( ics.GetVar("matchedGroup") )  && !DeviceHelper.DEFAULT_DEVICEGROUP_NAME.equalsIgnoreCase( ics.GetVar("matchedGroup") )) %>' >
		<ics:then>
					<xlat:lookup key="dvin/UI/MobilitySolution/SkinSaveAssociationMsg" varname="SkinSaveAssociationMsg" />
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
							<ics:argument name="msgtext" value='<%=ics.GetVar("SkinSaveAssociationMsg")%>'/>
							<ics:argument name="severity" value="info"/>
					</ics:callelement>
		</ics:then>
		<ics:else>		
				<ics:if condition='<%=(!ftUtil.emptyString(ics.GetVar("matchedDevice"))) %>' >
						<ics:then>
									<xlat:lookup key="dvin/UI/MobilitySolution/SkinSaveAssociationFailedMsg" varname="SkinSaveAssociationFailedMsg" />
									<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
									<ics:argument name="msgtext" value='<%=ics.GetVar("SkinSaveAssociationFailedMsg")%>'/>
									<ics:argument name="severity" value="warning"/>
									</ics:callelement>
						</ics:then>	
						<ics:else>
						            <ics:if condition='<%=("true".equals(ics.GetVar("result"))) %>'>
						            <ics:then>
						                       <xlat:lookup key="dvin/UI/MobilitySolution/SkinAssociationFailedInternalError" varname="SkinAssociationFailedInternalError" />
												<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
												<ics:argument name="msgtext" value='<%=ics.GetVar("SkinAssociationFailedInternalError")%>'/>
												<ics:argument name="severity" value="warning"/>
												</ics:callelement>
						            </ics:then>
						            <ics:else>
						                        <xlat:lookup key="dvin/UI/MobilitySolution/SkinAssociationFailedDeviceNotFound" varname="SkinAssociationFailedDeviceNotFound" />
												<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
												<ics:argument name="msgtext" value='<%=ics.GetVar("SkinAssociationFailedDeviceNotFound")%>'/>
												<ics:argument name="severity" value="warning"/>
												</ics:callelement>
						            </ics:else>
						            </ics:if>	
						     </ics:else>					            
						<ics:else>
						
						
						</ics:else>	
				</ics:if>		
		</ics:else>
		</ics:if>
				
   </ics:then>              
</ics:if>
</ics:then>
<ics:else>
					<xlat:lookup key="fatwire/admin/DeviceImageDisabledWarning" varname="DeviceImageDisabledWarning" />
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
							<ics:argument name="msgtext" value='<%=ics.GetVar("DeviceImageDisabledWarning")%>'/>
							<ics:argument name="severity" value="warning"/>
					</ics:callelement>
</ics:else>
</ics:if>
</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%//
// UI/Data/WebView/DeviceHtml
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
<div 
	data-dojo-type="fw.ui.dijit.FlexibleMenu"
	data-dojo-props="
		'class': 'newStartMenu',
		noDataMessage: 'You do not have any device skins',
		afterPostCreate: function() {
			this.set({
				'items': [<%= request.getAttribute("skinsJson") %>],
				'rows': 10,
				'columns': 4
			});
		},
		
		createMenuItem: function(item) {
			return new fw.dijit.UIMenuItem({
				label: item.description,
				title: item.description,
				baseClass: 'dijitMenuItem deviceMenuItem',
				onClick: function() {
					dojo.publish('fw/ui/app/gotoview', [{
						'doctype': item.doctype,
						'type': 'insite',  
						'params': {
							'checkAccess': true,
							'device': item.device,
							'suffix': item.suffix
						},
						'name': item.name,
						'description': item.description,
						'device': item.device
					}]);
				}
			});
		}
	">
</div>

</cs:ftcs>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.ui.util.InsiteUtil"
%><%@ page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.services.SiteService"
%><%@ page import="com.fatwire.services.beans.entity.RoleBean"
%><%@ page import="java.util.List"%><cs:ftcs>
webcenter.sites['${param.namespace}'] = function (config) {

	// maximum length of character in asset name 
	config.maxNameLength = <%=ics.GetProperty("xcelerate.asset.sizeofnamefield", "futuretense_xcel.ini", true) %>;

	// Mobility Configuration
	config.mobility = {
		defaultDeviceImage: 'Desktop'
	};

	// maximum number of tabs which can be opened by a user
	config.maxTabCount = 50;
	
	// enable web mode
	config.enableWebMode = <%=new Boolean(ics.GetProperty("xcelerate.enableinsite", "futuretense_xcel.ini", true)) %>;
	
	// enabled date-based preview (a.k.a."site preview")
	config.enableDatePreview = <%=ftMessage.cm.equals(ics.GetProperty(ftMessage.cssitepreview, "futuretense.ini", true))%>;
	
	// force non flash file uploader
	config.forceHTMLUploader = <%=new Boolean(ics.GetProperty("cs.disableSWFFlashUploader", "futuretense_xcel.ini", true))%>;

	// token
	config.token = "<%=InsiteUtil.getUploadToken(ics) %>";
	
	// session id
	config.sessionid = "<%=session.getId() %>";
	
	// enable preview
	<%
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	boolean enabled = siteService.isPreviewEnabled(GenericUtil.getLoggedInSite(ics));
	List<RoleBean> roles = siteService.getUserRoles(GenericUtil.getLoggedInSite(ics));
	pageContext.setAttribute("roles", roles, PageContext.PAGE_SCOPE);
	%>
	config.enablePreview = <%=enabled %>
	
	config.roles = [
	<c:forEach var="role" items="${roles}" varStatus="status">
		'${role.name}'${status.last ? '' : ','}
	</c:forEach>];
	
	<ics:callelement element="UI/Data/Site/GetRestrictedTypes" />
	config.supportedTypes = [
	<c:forEach var="type" items="${supportedTypes}" varStatus="status">
		'${type}'${status.last ? '' : ','}
	</c:forEach>
	];
	
	<ics:callelement element="UI/Data/Site/GetPreviewableTypes" />
	config.previewableTypes = [
	<c:forEach var="type" items="${previewableTypes}" varStatus="status">
		'${type}'${status.last ? '' : ','}
	</c:forEach>
	];

	config.searchableTypes = [
	<c:forEach var="type" items="${searchableTypes}" varStatus="status">
		'${type}'${status.last ? '' : ','}
	</c:forEach>
	];
	
	config.proxyTypes = [
	<c:forEach var="type" items="${proxyTypes}" varStatus="status">
		'${type}'${status.last ? '' : ','}
	</c:forEach>
	];
	
	// document classes
	// alias -> class name
	config.documents = {
		"asset": "fw.ui.document.AssetDocument",
		"proxy": "fw.ui.document.ProxyAssetDocument",
		"SitePlan": "fw.ui.document.SitePlanDocument"
	};
	
	// Additional data stores for client-side integration
	// with 3rd party repositories
	config.stores = {};
	
	// third-party dojo modules which should be loaded
	config.modules = {};
	
	//
	// views
	// -----
	// alias -> view class name
	// or
	// alias -> view class name and controller class name
	// {
	//		"view": class name,
	//		"controller": class name
	// }
	//
	config.views = {
		// dashboard screen
		"dashboard": {
		 	"viewClass": "fw.ui.view.DashboardView"
		},
		
		// approval screen
		"approval": {
			"viewClass": "fw.ui.view.ApprovalView",
			"controllerClass": "fw.ui.controller.ApprovalController"
		},
		
		// SAFE permission screen (advanced UI)
		"permission": {
			"viewClass": "fw.ui.view.advanced.PermissionView"
		},
		
		// web mode
		"web": {
			"viewClass": "fw.ui.view.MobilityInsiteView",
			"controllerClass": "fw.ui.controller.MobilityInsiteController"
		},
		
		// form mode
		"form": {
			"viewClass": "fw.ui.view.advanced.FormView",
			"controllerClass": "fw.ui.controller.AdvancedController"
		},
		
		// delete screen
		"delete": {
			"viewClass": "fw.ui.view.DeleteView",
			"controllerClass": "fw.ui.controller.DeleteController"
		},
		
		// see dashboard
		'finishassignment': {
			 "viewClass": 'fw.ui.view.advanced.FinishAssignmentView'
		},
		
		// asset preview
		'preview': {
			'viewClass': 'fw.ui.view.MobilityPreview',
			'controllerClass': 'fw.ui.controller.MobilityPreviewController'
		},
		
		// show asset revision (advanced UI)
		'revision': {
			"viewClass": 'fw.ui.view.advanced.RevisionView'
		} ,	
		
		// rollback view (advanced UI)
		'rollback': {
			"viewClass": 'fw.ui.view.advanced.RollbackView'
		},
		
		// search view
		"search": {
			'viewClass': 'fw.ui.view.SearchView',
			'controllerClass': 'search', // refers to class in singleton object factory
			'isSingleton': true
		},
		
		//contentquery view
		'contentquery': {
			'viewClass':'fw.ui.view.ContentQueryView'
		},
		
		// asset sharing view
		'share': {
			"viewClass": 'fw.ui.view.SharedView'
		},
		
		// asset status screen (advanced UI)
		'status': {
			"viewClass": 'fw.ui.view.advanced.StatusView'
		} ,
		
		// versioning screen
		'versioning': {
			'viewClass': 'fw.ui.view.VersioningView',
			'controllerClass': 'fw.ui.controller.VersioningController'
		},
		
		// show revision screen (advanced UI)
		'versions': {
			"viewClass": 'fw.ui.view.advanced.ShowVersionView'
		},
		
		// default proxy asset form (inspect only)
		'form-proxy': {
			'viewClass': 'fw.ui.view.SimpleAssetView',
			'viewParams': {
				// default inspect form for proxy assets
				element: 'UI/Layout/CenterPane/Form/Proxy'
			}
		},
		
		'multi-device-preview': {
			"viewClass": "fw.ui.view.MultiDevicePreview",
			"controllerClass": "fw.ui.controller.MultiDevicePreviewController"
		},
		
		'siteplan-approval': {
			"viewClass": "fw.ui.view.SitePlanApprovalView",
			"controllerClass": "fw.ui.controller.ApprovalController"
		}
	};
	
	/**
	 * Controllers configuration
	 * -------------------------
	 * 
	 * For each controller, contains a function -> handler mapping
	 * 
	 */
	config.controllers = {
		"fw.ui.document.DocumentController": {
			"new":        "newDocument",
			"save-all":   "saveAll",
			"closetab":   "closedocTab"
		},
		
		"fw.ui.document.AssetDocument": {
			"approve": {
				"next-view": "approval",
				"model-update-required": true
			},
			
			"authorize": {
				"next-view": "permission",
				"model-update-required": false
			},
			
		
			"bookmark": {
				"event-handler": "bookmark",
				"enable-if": function (doc) {
					return !doc.get('bookmarked');
				},
				"mutable": "bookmarked",
				"model-update-required": false
			},
			"checkin": {
				"next-view": "versioning",
				"enable-if": function (doc) {
					var tracked = doc.get('tracked'),
						status = doc.get('versioningStatus');
					return tracked && status && status.locked && status.checkedOut;
				},
				"mutable": "versioningStatus"
			},
			
			"checkout": {
				"event-handler": "checkout",
				"enable-if": function (doc) {
					var versioningStatus = doc.get('versioningStatus');
					if (versioningStatus) {
						return doc.get('tracked') && !versioningStatus.checkedOut
					}
					return false;
				},
				"mutable": "versioningStatus"
			},
			
			"copy": "default",
			
			"delete": {
				"next-view": "delete"
			},
			
			"edit": {
				"event-handler": "edit",
				"next-view": "default",
				"enable-if": function (doc) {
					return !doc.get('isNew') && !doc.get('editable');
				},
				"mutable": "editable"
			},
			
			"inspect" :{
				"event-handler": "inspect",
				"next-view": "default",
				"enable-if": function (doc) {
					return doc.get('editable');
				},
				"mutable": "editable"
			},
			
			"preview": {
				"next-view": "preview",
				"enable-if": function (doc) {
					return doc.get('previewable');
				}
			},
			
			"revision": {
				"next-view": "revision"
			},
			
			"rollback": {
				"next-view": "rollback",
				"enable-if": function (doc) {
					var asset = doc.get('asset');
					return asset && asset.tracked && !asset.lockStatus.checkedOut;
				},
				"mutable": "versioningStatus"
			},
			
			"share": {
				"next-view": "share",
				"enable-if": function (doc) {
					var asset = doc.get('asset');
					return (asset && asset.permissions && asset.permissions.canShare === true);
				}
			},
			
			"showversions": {
				"next-view": "versions",
				"enable-if": function (doc) {
					var asset = doc.get('asset');
					return asset && asset.tracked;
				},
				"mutable": "versioningStatus"
			},
			"translate": "default",
			"viewstatus": {
				"next-view": "status",
				"model-update-required": false
			},
			"unbookmark": {
				"event-handler": "unbookmark",
				"enable-if": function (doc) {
					var asset = doc.get('asset');
					return asset && asset.bookmarked;
				},
				"mutable": "bookmarked"
			},
			"tagasset": {
				"event-handler": "tagasset",
				"enable-if": function (doc) {
					var asset = doc.get('asset');
					return asset.flex || asset.type == 'Page' || !asset.complex;
				},
				"mutable": "tagasset",
				"model-update-required": false
			},
			"undocheckout": {
				"event-handler": "undoCheckout",
				"enable-if": function (doc) {
					var asset = doc.get('asset');
					return asset && asset.tracked && asset.lockStatus.locked && asset.lockStatus.checkedOut;
				},
				"mutable": "versioningStatus"
			},
			"finishassignment": {
				"next-view": "finishassignment",
				"mutable": "workflowStatus"
			} ,
			"previewnewwin": {
				"event-handler": "openPreviewWindow",
				"enable-if": function (doc) {
					return doc.get('previewable');
				}
			}
		},
		
		"fw.ui.controller.AdvancedController": {
			"edit": {
				"event-handler": "edit",
				"enable-if": function (doc) {
					return !doc.get('isNew') && !doc.get('editable');
				},
				"mutable": "editable"
			},
			"inspect": {
				"event-handler": "inspect",
				"enable-if": function (doc) {
					return doc.get('editable');
				},
				"mutable": "editable",
				"model-update-required": true
			},
			"multi-device-preview": {
				"next-view": "multi-device-preview",
				"enable-if": function (doc) {
					if(doc.get("previewable") === false){
						return false;
					}
					var activeTab = SitesApp.tabController.getActiveTab();

					var size = (activeTab && dojo.byId('noOfDeviceImages_' + activeTab.view.id)) ? dojo.byId('noOfDeviceImages_' + activeTab.view.id).value : null;
					
					// Show the multi-device-preview button only if the number of device images are more than one.
					if (size && size > 1)
						return true;
					return false;
				}
			},
			"web-mode": {
				"event-handler": "switchToWebMode",
				"next-view": "web",
				"enable-if": function (doc) {
					return !doc.get('isNew');
				},
				"always-visible": true
			},
			
			"save": {
				"event-handler": "save",
				"authorization-required": false,
				"model-update-required": false,
				"enable-if": function (doc) {
					return doc.get('editable') || doc.get('isNew');
				},
				"always-visible": "true"
			},
			
			"saveandclose": {
				"event-handler": "saveandclose",
				"authorization-required": false,
				"model-update-required": false,
				"enable-if": function (doc) {
					return doc.get('editable') || doc.get('isNew');
				},
				"always-visible": "true"
			},
			
			"refresh": "default"
		},
		
		"fw.ui.controller.InsiteController": {
			"edit": {
				"event-handler": "edit",
				"enable-if": function (doc) {
					return !doc.get('editable');
				},
				"mutable": "editable"
			},
			"inspect": {
				"event-handler": "inspect",
				"enable-if": function (doc) {
					return doc.get('editable');
				},
				"mutable": "editable",
				"model-update-required": true
			},
			"form-mode": {
				"next-view": "form"
			},
			"changelayout": {
				"event-handler": "changeLayout",
				"enable-if": function (doc) {
					return doc.get('editable') === true;
				},
				"mutable": "editable"
			},
			"checkincheckout": {
				"next-view": "versioning",
				"model-update-required": true
			},
			"save": {
				"event-handler": "save",
				"authorization-required": false,
				"enable-if": function (doc) {
					return doc.get('editable') || doc.get('isNew');
				},
				"model-update-required": true
			},
			"saveandclose": {
				"event-handler": "saveandclose",
				"authorization-required": false,
				"model-update-required": false,
				"enable-if": function (doc) {
					return doc.get('editable') || doc.get('isNew');
				},
				"always-visible": "true"				
			},
			"refresh": "default"
		},
		
		"fw.ui.controller.PreviewController": {
			"changetemplate": "changeTemplate",
			"changesegment": "changeSegment",
			"changeWrapper": "changeWrapper",
			"changeDate": "changeDate",
			"refresh": "refresh",
			"goback": "goBack"
		},
		
		"fw.ui.controller.SearchController": {
			"dock": "dock",
			"undock": "undock",
			"toggle": "toggleView",
			"browse": "browse",
			"create-smartlist": "createSmartList",
			"run-smartlist": "runSmartList",
			"edit-smartlist": "editSmartList",
			"delete-smartlist": "deleteSmartList",
			"sort": "sortSearchResults",
			"advanced-search": "advancedSearch",
			"approve": "handleBulk",
			"delete": "handleBulk",
			"refresh": "refresh",
			"bookmark": "handleBulk",
			"tagasset": "handleBulk",
			"copy": "handleBulk"
		},
		
		"fw.ui.controller.DeleteController": {
			"goback": "goBack",
			"delete-asset": "deleteAsset",
			"delete-selected": "deleteAssets",
			"show-referring": "showDeleteReference",
			"remove-reference": "removeReference",
			"remove-references": "removeReferences",
			"refresh": "default"
		},
		
		"fw.ui.controller.VersioningController": {
		
			"goback": "goBack",
			"checkin": "default",
			"checkout": "default",
			"checkin-selected": "checkinAll",
			"checkout-selected": "checkoutAll",
			"undocheckout-selected": "undoCheckoutAll",
			"refresh": "default"
		},
		
		"fw.ui.controller.ApprovalController": {
			"goback": "goBack",
			"approve-all": "approveAll",
			"approve-all-recursive": "approveAllRecursive",
			"approve-selected": "approve",
			"unapprove": "unapprove",
			"show-blocking": "showBlockingAssets",
			"approve-blocking": "approveBlockingAsset",
			"approve-selected-blocking": "approveBlockingAssets",
			"refresh": "default"
		},
		
		"fw.ui.controller.BulkController": {
			"asset": "bulkasset",
			"proxy": "bulkproxyasset"
		},
		
		"fw.ui.controller.BulkAssetController": {
			"bookmark": "default",
			"unbookmark": "default",
			"tagasset": {
				"event-handler": "tagasset",
				"enable-if": function (doc) {
					return doc.isFlex() || doc.getAssetType() == 'Page' || !doc.isComplex();
				}
			},
			"copy": "default",
			"delete": {
				"next-view": "delete"
			},
			"share": {
				"next-view": "share"
			},
			"approve": {
				"next-view": "approval"
			}
		},
		
		"fw.ui.controller.BulkProxyAssetController": {
			"bookmark": "default",
			"tagasset": "default",
			"unbookmark": "default",
			"copy": "default",
			"delete": {
				"next-view": "delete"
			},
			"share": {
				"next-view": "share"
			},
			"approve": {
				"next-view": "approval"
			}
		},
		
		// The following assume view and controller role
		"fw.ui.view.advanced.PermissionView": {
			"goback": "goBack"
		},
		
		"fw.ui.view.advanced.RollbackView": {
			"goback": "goBack"
		},
		
		"fw.ui.view.advanced.ShowVersionView": {
			"goback": "goBack"
		},
		
		"fw.ui.view.advanced.RevisionView": {
			"goback": "goBack"
		},
		
		"fw.ui.view.advanced.StatusView": {
			"goback": "goBack"
		} ,
		
		"fw.ui.view.advanced.FinishAssignmentView": {
			"goback": "goBack"
		},
		
		"fw.ui.view.ContentQueryView": {
			"goback": "goBack"
		},
		
		"fw.ui.view.DashboardController": {
			"refresh": "default"
		},
		
		'fw.ui.document.SitePlanDocument': {
			"approve": {
				"next-view": "siteplan-approval"
			},
			"inspect": {
				// SitePlan Asset does not have any inspect view in Contributor UI
				'next-view': ''
			}
		},
		
		'fw.ui.controller.TreeController': {
			"copy-site-navigation": "copySiteNavigation",
			"paste-site-navigation": "pasteSiteNavigation"
		}
	};
	
	var baseConfig = config.controllers['fw.ui.document.AssetDocument'];
	config.controllers['fw.ui.document.ProxyAssetDocument'] = {		
		"inspect": baseConfig.inspect,
		"delete": baseConfig['delete'],
		"approve": baseConfig.approve,
		"bookmark": baseConfig.bookmark,
		"unbookmark": baseConfig.unbookmark,
		"tagasset": baseConfig.tagasset,
		"viewstatus": baseConfig.viewstatus,
		"preview": baseConfig.preview
	}
	
	config.controllers["fw.ui.controller.MobilityInsiteController"] = dojo.clone(config.controllers["fw.ui.controller.InsiteController"]);
	dojo.mixin(config.controllers["fw.ui.controller.MobilityInsiteController"], {
		"skin-widget": {
			"event-handler": "toggleSkinWidget",
			"enable-if": function (doc) {
				var activeView = doc.get('activeView'),
					eligibleDevicesStore;
				
				if ( !activeView || !activeView._getEligibleDevicesStore ) return false; 
				
				// Show the Skin widget button only if it exists.
				eligibleDevicesStore = activeView._getEligibleDevicesStore();
				if ( eligibleDevicesStore && eligibleDevicesStore.data.length > 1 ) return true;
				
				return false;
			}
		},
		
		"change-skin": "changeSkin",
		
		"multi-device-preview": {
			"next-view": "multi-device-preview",
			"enable-if": function (doc) {
				if(doc.get("previewable") === false){
						return false;
				}
				var activeTab = SitesApp.tabController.getActiveTab(),
					eligibleDevicesStore;

				if ( !activeTab || !activeTab.view._getEligibleDevicesStore ) return false; 
				
				// Show the multi-device-preview button only device groups other than desktop is available.
				eligibleDevicesStore = activeTab.view._getEligibleDevicesStore();
				if ( eligibleDevicesStore && eligibleDevicesStore.data.length > 1 )
					return true;
				return false;
			}
		}, 

		"preview": {
			"next-view": "preview",
			"enable-if": function (doc) {
				return doc.get('previewable');
			}
		}
	});
	
	config.controllers["fw.ui.controller.MobilityPreviewController"] = dojo.clone(config.controllers["fw.ui.controller.PreviewController"]);
	dojo.mixin(config.controllers["fw.ui.controller.MobilityPreviewController"], {

		"change-skin": "changeSkin",

		"skin-widget": {
			"event-handler": "toggleSkinWidget",
			"enable-if": function (doc) {
				var activeView = doc.get('activeView'),
					eligibleDevicesStore;
				
				if ( !activeView || !activeView._getEligibleDevicesStore ) return false; 
				
				// Show the Skin widget button only if it exists.
				eligibleDevicesStore = activeView._getEligibleDevicesStore();
				if ( eligibleDevicesStore && eligibleDevicesStore.data.length > 1 ) return true;
				
				return false;
			}
		},

		"multi-device-preview": {
			"next-view": "multi-device-preview",
			"enable-if": function (doc) {
				if(doc.get("previewable") === false){
						return false;
				}
				var activeTab = SitesApp.tabController.getActiveTab(),
					eligibleDevicesStore;

				if ( !activeTab || !activeTab.view._getEligibleDevicesStore ) return false; 
				
				// Show the multi-device-preview button only device groups other than desktop is available.
				eligibleDevicesStore = activeTab.view._getEligibleDevicesStore();
				if ( eligibleDevicesStore && eligibleDevicesStore.data.length > 1 )
					return true;
				return false;
			}
		}
	});

	config.controllers["fw.ui.controller.MultiDevicePreviewController"] = dojo.clone(config.controllers["fw.ui.controller.PreviewController"]);
	dojo.mixin(config.controllers["fw.ui.controller.MultiDevicePreviewController"], {
		"change-devicegroup": "changeDeviceGroup",

		"preview": {
			"next-view": "preview",
			"enable-if": function (doc) {
				return doc.get('previewable');
			}
		}
	});
	
	// enables or disables the browser context menu in web mode
	config.enableContextMenu = false;
	
	// default view mode
	// global setting, per asset type and/or subtype
	config.defaultView = {
		"default": "form",
		"proxy": "form-proxy"
	};
	
	config.treeActions = {};
	
	// specific config for Tree Context Menu buttons which do not map to simple buttons
	//
	config.treeMenuItems = {
		"approve": {
			alt: fw.util.getString("dvin/UI/AssetMgt/Approve"),
			title: fw.util.getString("dvin/UI/AssetMgt/Approve"),
			functionid: 'approve',
			buttonType: 'dropdown',
			dropDownUrl: 'UI/Actions/Asset/Approve/Destination'
		}
	};
	
	// specific config for toolbar buttons which do not map to simple buttons
	//
	config.toolbarButtons = {
		"approve": {
			alt: fw.util.getString("dvin/UI/AssetMgt/Approve"),
			title: fw.util.getString("dvin/UI/AssetMgt/Approve"),
			buttonType: 'dropdown',
			dropDownUrl: 'UI/Actions/Asset/Approve/Destination'
		}
		, "changesegment": {
			alt: fw.util.getString("UI/UC1/Layout/PreviewWithSegment"),
			title: fw.util.getString("UI/UC1/Layout/PreviewWithSegment"),
			buttonType: 'dropdown',
			dropDownUrl: 'UI/Data/Segment/SegmentStore'
		}
	};	
	
	config.contextMenus = {
		"default":["bookmark", "tagasset", "delete"],
		"asset":["edit", "copy", "preview", "share", "delete", "bookmark", "tagasset"],
		"asset/Page":["edit", "copy", "preview", "delete", "bookmark", "tagasset"],
		"proxy":["preview", "bookmark", "tagasset", "delete"]
	};
	
	config.bookmarkContextMenus = {
		"default":["tagasset", "unbookmark"],
		"asset":["edit", "preview", "unbookmark", "tagasset"],
		"proxy":["preview", "unbookmark", "tagasset"]
	};
	
	config.checkoutContextMenus = {
		"default":["tagasset", "bookmark"],
		"asset":["edit", "preview", "bookmark", "tagasset", "showversions"],
		"proxy":["preview", "bookmark", "tagasset"]
	};
	
	config.workflowContextMenus = {
		"default":["bookmark", "tagasset"],
		"asset":["edit", "preview", "bookmark", "tagasset", "viewstatus", "finishassignment"],
		"proxy":["preview", "bookmark", "tagasset"]
	};

	config.toolbars = {
		"approval": ["goback","refresh"],
		"delete": ["goback","refresh"],
		"web": {
			"edit": ["form-mode", "inspect", "separator", "save", "preview", "multi-device-preview", "approve", "delete",
					 "separator", "changelayout", "separator", "checkincheckout", "skin-widget", "refresh"],
			"view": ["form-mode", "edit", "separator", "preview", "multi-device-preview", "approve", "delete","separator","checkincheckout",
					 "skin-widget", "refresh"]
		},
		"form": {
			"view": ["web-mode", "edit", "separator", "preview", "multi-device-preview", "approve", "delete","separator",
					 "undocheckout", "checkin", "checkout", "rollback", "showversions", "refresh"],
			"edit": ["web-mode", "inspect", "separator", "save", "preview", "multi-device-preview", "approve", "delete","separator",
					 "undocheckout", "checkin", "checkout", "rollback", "showversions", "refresh"],
			"copy": ["web-mode", "save"],
			"translate": ["web-mode", "save"],
			"create": ["save"]
		},
		"form-proxy": {
			"view": ["approve", "bookmark", "unbookmark", "delete", "preview"]
		},
		"permission": ["goback"],
		"preview": ["goback", "changetemplate", "changesegment", "multi-device-preview", "sitePreview", "skin-widget", "refresh"],
		"revision": ["goback"],
		"rollback": ["goback"],
		"search": {
			"search": ["bookmark","approve", "delete","refresh"],
			"advanced": ["refresh"]
		},
		
		"status": ["goback"],
		"finishassignment": ["goback"],
		"versioning": ["goback","refresh"],
		"versions": ["goback"],
		"dashboard": ["refresh"],
		"multi-device-preview": ["goback", "changetemplate", "changesegment", "sitePreview", "refresh"]
	},
	
	config.menubar = {
		"default": [
			{
				"id": "content",
				"label": fw.util.getString("UI/Forms/Content"),
				"children": [
					{label: fw.util.getString('dvin/Common/New'), cache: true, deferred: 'UI/Data/StartMenu/New'},
					{separator: true},
					{label: fw.util.getString('dvin/UI/Save'), action: 'save'},
					{label: fw.util.getString('UI/UC1/Layout/SaveAndClose'), action: 'saveandclose'},
					{separator: true},
					{label: fw.util.getString('UI/Forms/Approve'), action: 'approve', deferred: 'UI/Actions/Asset/Approve/Destination'},
					{separator: true},
					{label: fw.util.getString('dvin/Common/Share'), action: 'share'},
					{label: fw.util.getString('dvin/UI/AccessPrivileges'), action: 'authorize'},
					{separator: true},
					{label: fw.util.getString('UI/UC1/Layout/Bookmark'), action: 'bookmark'},
					{label: fw.util.getString('UI/UC1/Layout/Unbookmark'), action: 'unbookmark'}
				]
			},
			{
				"id": "edit",
				"label": fw.util.getString("dvin/Common/Edit"),
				"children": [
					{label: fw.util.getString('dvin/Common/Inspect'), action: 'inspect'},
					{label: fw.util.getString('dvin/Common/Edit'), action: 'edit'},
					{label: fw.util.getString('dvin/Common/Copy'), action: 'copy'},
					{label: fw.util.getString('dvin/Common/Delete'), action: 'delete'},
					{separator: true},
					{label: fw.util.getString('dvin/Common/Version'), children: [
						{label: fw.util.getString('dvin/CSDocLink/UndoCheckout'), action: 'undocheckout'},
						{label: fw.util.getString('dvin/Common/CheckIn'), action: 'checkin'},
						{label: fw.util.getString('UI/Forms/CheckOut'), action: 'checkout'},
						{label: fw.util.getString('dvin/UI/ShowVersions'), action: 'showversions'},
						{label: fw.util.getString('dvin/Common/Rollback'), action: 'rollback'}
					]},
					{separator: true},
					{label: fw.util.getString('UI/UC1/Layout/ChangePageLayout'), action: 'changelayout'}
				]
			},
			{
				"id": "view",
				"label": fw.util.getString("dvin/Common/View"),
				"children": [
					{label: fw.util.getString('UI/UC1/Layout/FormView'), action: 'form-mode'},
					{label: fw.util.getString('UI/UC1/JS/WebView'), action: 'web-mode'},
					{label: fw.util.getString('dvin/Common/Preview'), action: 'preview'},
					{label: fw.util.getString('UI/MobilitySolution/UC1/MultiDevicePreview'), action: 'multi-device-preview'},
					{label: fw.util.getString('UI/UC1/Layout/PreviewWithPageLayout'), action: 'changetemplate'},
					{label: fw.util.getString('UI/UC1/Layout/PreviewWithSegment'), action: 'changesegment', deferred: 'UI/Data/Segment/SegmentStore'},
					{label: fw.util.getString('UI/UC1/Layout/PreviewWithWrapper'), action: 'changeWrapper', deferred: 'UI/Data/Template/WrapperStore'},
					{label: fw.util.getString('UI/UC1/Layout/PreviewInNewWindow'), action: 'previewnewwin'},
					{label: fw.util.getString('UI/UC1/Layout/ViewStatus'), action: 'viewstatus'}
				]
			}
		]
	};
	
	config.webmode = {
		"slots": {
			// list of all possible buttons
			"buttons": {
				"newtab": {
					'label': fw.util.getString('UI/UC1/JS/OpenInANewTab'),
					'icon': 'iconEditInNewTab.png'
				},
				"edit": {
					'label': fw.util.getString("dvin/Common/Edit"),
					'icon': 'iconEdit.png'
				},
				"changelayout": {
					'label': fw.util.getString("UI/UC1/JS/ChangeContentLayout"),
					'icon': 'iconChangeLayout.png'
				},
				"clear": {
					'label': fw.util.getString("UI/UC1/JS/ClearSlot"),
					'icon': 'iconDelete.png'
				},
				"properties": {
					'label': fw.util.getString("UI/UC1/JS/SlotProperties"),
					'icon': 'iconSlotProperties.png'
				}
			},
			"toolbars": {
				"default": ["edit", "newtab", "changelayout", "properties", "clear"]
			}
		}
	};
}
</cs:ftcs>

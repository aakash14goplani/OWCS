<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/systemtools/SystemInfo/SysInfoCommons
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
<%@ page import="com.fatwire.realtime.util.Util"%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<script type="text/javascript">
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urltimeouterror">
</satellite:link>
var errorPage = '<%=ics.GetVar("urltimeouterror")%>';
function execute(url,info){
			showLoading();
			$('appForm').action = url;
			$('appForm').request(
			{
			method: 'post',
			parameters: {op: info} ,
			onSuccess: function(transport) {
				    hideLoading();
					var respText= transport.responseText;
					var index1 = respText.indexOf('_FW_MARKER1_');
				    var index2 = respText.indexOf('_FW_MARKER2_');
					var json = respText.substring(index1+12,index2).evalJSON();
					var urlValue = json['outPutUrl'];
				    if(urlValue != undefined && urlValue !== null && urlValue !== '')
				    	location.href=urlValue;
				    else
					{
						var errorMessage = json['X-errorMessage'];
						if(errorMessage !=undefined && errorMessage !== null && errorMessage !== '')
							alert(errorMessage);
					}
			},
			onComplete: function(transport) {
				var header = transport.getResponseHeader("userAuth");
				if(header == "false")
					parent.parent.location=errorPage;
			}
		});
		}
		
		function showLoading(){
			$('ajaxLoading').style.display='block';
			$('processing').style.display='block';
		}
		function hideLoading(){
			$('processing').style.display='none';
			$('ajaxLoading').style.display='none';
		}
	   
		function moveleft(src,target)
		{
			var sc, itemText, i, newIndex, listy;
			for (i=0; i<src.options.length; i++)
			{
				if (src.options[i].selected)
				{
					var sc=i;
					var o=src.options[sc];
					var newValue=o.value;
					items=new Option(o.text,newValue);
					newIndex=target.options.length;
					target.options[newIndex]=items;
					target.options[newIndex].selected=true;
				}
			}
			i = 0;
			while (i<src.options.length)
			{
				if (src.options[i].selected)
					src.options[i]=null;
				else
					i = i + 1;
			}
			delNul(src);
			delNul(target);
		}


		function moveright(src,target)
		{
			var sc, itemText, i, oldIndex, numSelected, newIndex, listy;
			numSelected=0;
			for (i=0; i<src.options.length; i++)
			{
				if (src.options[i].selected)
				{
					var sc=i;
					var o=src.options[sc];
					var newValue=o.value;
					items=new Option(o.text,newValue);
					newIndex=target.options.length;
					target.options[newIndex]=items;
					target.options[newIndex].selected=true;
					oldIndex=i;
					numSelected++;
				}
			}
			i = 0;
			while (i<src.options.length)
			{
				if (src.options[i].selected)
					src.options[i]=null ;
				else
					i = i + 1;
			}
			delNul(src);
			delNul(target);
			if (src.options.length>0)
			{
				if (src.options.length>(oldIndex-numSelected+1))
					src.options[oldIndex-numSelected+1].selected=true;
				else
					src.options[src.options.length-1].selected=true;
			}
		}
	
		function delNul(lst){
			i = 0;
			while (i<lst.options.length) {
				if (lst.options[i].value==-1)
					lst.options[i]=null
				else
					i = i + 1;
			}
		}
		
		function selAll(lst){
			 if (!lst) { 
			   return;
			 }
			for (i=0; i<lst.options.length; i++)
				lst.options[i].selected=true
			delNul(lst);
		}
		
		if(dojo){
			dojo.addOnLoad(function() {
				if(typeof(dijit.byId('dijit_layout_BorderContainer_0')) != 'undefined'){
					dijit.byId('dijit_layout_BorderContainer_0').resize();
				}
				//The following code is needed to remove the underline from the text in the dojo buttons..
				var buttonsAndTitles = dojo.query('span.fwButton, div.new-table-title');
				for(var i=0; i < buttonsAndTitles.length; i++){
					var anchorNode = buttonsAndTitles[i].parentNode;
					if(anchorNode && anchorNode.nodeName.toLowerCase() === 'a'){
						anchorNode.className+=" button-anchor";
					}
				}
				}
			);
		}
</script>
</cs:ftcs>
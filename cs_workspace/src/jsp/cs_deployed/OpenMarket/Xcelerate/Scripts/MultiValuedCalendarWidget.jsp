<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Scripts/MultiValuedCalendarWidget
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
<ics:callelement element="OpenMarket/Xcelerate/Util/SetUpDateFormat"></ics:callelement>
<ics:callelement element="OpenMarket/Xcelerate/Util/ConvertJDBCDateTimeZone">
	<ics:argument name="inputDate" value="now"/>
	<ics:argument name="fromTimeZone" value="server"/>
	<ics:argument name="toTimeZone" value="client"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Xcelerate/Util/GetLocalizedDate">
	<ics:argument name="inputDate" value='<%=ics.GetVar("outputDate")%>'/>
	<ics:argument name="outputVar" value='nowDate'/>
</ics:callelement>
<ics:removevar name="outputDate" />
<script type="text/javascript">
	var datValsArry_<%=ics.GetVar("AttrID")%> = [];
</script>
<%
	String inputTagImgPi = ics.GetVar("inputname");	
	//inputTagImgPi.substring(0, inputTagImgPi.lastIndexOf('_'));
	ics.SetVar("inputTagMulti", inputTagImgPi.substring(0, inputTagImgPi.lastIndexOf('_')));
	
	Object o = ics.GetObj("strAttrValues");
	String str =  o != null ? ((StringBuilder)o).toString() : "" ;
	String[] strArr= str.split(",");
	int i = 0;
	StringBuilder sbMultVal = new StringBuilder();
	sbMultVal.append("[");
	for(String strM : strArr){
		if(i > 0){
			sbMultVal.append(",");
		}	
		%>
			<ics:callelement element="OpenMarket/Xcelerate/Util/ConvertJDBCDateTimeZone">
				<ics:argument name="inputDate" value="<%=strM%>" />
				<ics:argument name="fromTimeZone" value="server"/>
				<ics:argument name="toTimeZone" value="client"/>
			</ics:callelement>
			<ics:callelement element="OpenMarket/Xcelerate/Util/GetLocalizedDate"> 
				  <ics:argument name="inputDate" value='<%=ics.GetVar("outputDate")%>'/>
				  <ics:argument name="outputVar" value='convertedDate'/>
			</ics:callelement>
			<ics:removevar name="outputDate" />
			<script type="text/javascript">
				datValsArry_<%=ics.GetVar("AttrID")%>.push('<%=ics.GetVar("convertedDate")%>');
			</script>
		<%		
			sbMultVal.append(ics.GetVar("convertedDate"));

			i++;
		}
		sbMultVal.append("]");
		String maximumValues =  ics.GetVar("maxValsSetting");
%>
<tr>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>
	<td>&nbsp;</td>
	<td>			
		<div class="ddP">
			<div name="<%=ics.GetVar("inputTagMulti")  + "_dndSrc_"%>"></div>
			<div name="<%=ics.GetVar("inputTagMulti")  + "_addB_"%>"></div>
		</div>
	</td>
</tr>
<script type="text/javascript">
dojo.addOnLoad(function(){
	var beginTime = (new Date()).getTime();
	var maxVals = <%= Utilities.goodString(maximumValues) && !"0".equals(maximumValues) ? maximumValues : -1 %>,
		_tstampwgt;
	var createButton = function(args){
		var buttonTextVal = args || 'Provide Button Text';

		var buttonMainDiv =  dojo.create('div', {
		//var buttonMainDiv =  dojo.create('span', {
			'class': 'inline-left',
			name: 'delBttnNode'
		});
		
		var buttonLeftSide =  dojo.create('div', {
			'class': 'button-left'
		}, buttonMainDiv, 'last');

		var buttonMiddleSide = dojo.create('div', {
			'class': 'button-middle'
		}, buttonMainDiv, 'last');

		var buttonText = dojo.create('div', {
			'class': 'button-text',
			innerHTML: buttonTextVal
		}, buttonMiddleSide, 'last');

		var buttonRightSide =  dojo.create('div', {
			'class': 'button-right'
		}, buttonMainDiv, 'last');

		return buttonMainDiv;	
	};
	
	var prepareMultiDateAttrs = function(){
		var obj = document.forms[0],
			i = 1, j,
			dateValueArr = [],
			str ='', strVC = '<%=ics.GetVar("AttrName")+"VC"%>',
			str1 = '<%=ics.GetVar("inputTagMulti")+"_1"%>',
			strRequireInfo = '<%=ics.GetVar("AttrNumber") + "RequireInfo"%>',
			isRequired = <%=ics.GetVar("RequiredAttr")%>;
		dojo.forEach(dndDateContainer.getAllNodes(), function(node){
			var wids = dijit.findWidgets(node);
			dateValueArr.push(wids[0].get('value'));
		});
		obj.elements['<%=ics.GetVar("AttrName")+"VC"%>'].value = dateValueArr.length;
		
		if(dateValueArr.length == 0){
			if(obj.elements[str1])
				obj.elements['str1'].value = '';
			else{
				dojo.place('<input type="hidden" value="" name="' + str1 + '"/>', dojo.query("input[name="+strVC+"]")[0], 'after');
			}		
			if (isRequired){
				obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_1"%>*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqTrue*<%=ics.GetVar("type")%>!';
			}else{	
				obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_1"%>*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqFalse*<%=ics.GetVar("type")%>!';
			}
		}
		else {
			for(j = 1; j <= dateValueArr.length; j++){
				if(j > 1){
					if (isRequired){
						obj.elements[strRequireInfo].value = obj.elements[strRequireInfo].value + '*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqTrue*<%=ics.GetVar("type")%>!';
					}else{
						obj.elements[strRequireInfo].value = obj.elements[strRequireInfo].value + '*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqFalse*<%=ics.GetVar("type")%>!';
					}				
				}
				else{
					if (isRequired){
						obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqTrue*<%=ics.GetVar("type")%>!';
					}else{
						obj.elements[strRequireInfo].value ='*<%=ics.GetVar("inputTagMulti") + "_"%>' + j.toString() + '*<%=ics.GetVar("currentAttrNameorDesc")%>*ReqFalse*<%=ics.GetVar("type")%>!';
					}						
				}
			}
		}
		dojo.forEach(dateValueArr, function(val){	
			str = '<%=ics.GetVar("inputTagMulti") + "_"%>' + i.toString();
			dojo.query("input[name="+str+"]").forEach(function(delNode){
				dojo.destroy(delNode);
			});
			var inNode = dojo.place('<input type="hidden" value="" name="'+str+'"/>', dojo.query("input[name="+strVC+"]")[0], 'after');
			dojo.attr(inNode, 'value', val);
			i++;	
		});
		if(this.multiple && i > 1){
			str =  '<%=ics.GetVar("inputTagMulti") + "_"%>'+i.toString();
			dojo.query("input[name="+str+"]").forEach(function(delNode){
				dojo.destroy(delNode);
			});				
		}
	};

	var buildDndDateBox = function(val){
		var dndDateNode = dojo.create('div', {});
		var dndCalNode = dojo.create('div', {'class': 'calButton'});
		var datBox = new fw.dijit.UIInput({
			size: "25",
			clearButton: true,
			readOnly: true,
			value: val ? val : ""
		});
		dojo.addClass(datBox.domNode, 'defaultFormStyle');
		datBox.placeAt(dndDateNode, 'first');		
		datBox.startup();		
		
		var _ddCalButton_ = new dijit.form.DropDownButton({
			label: '<img alt="<%=ics.GetVar("datePickerString")%>" title="<%=ics.GetVar("pickADateString")%>" src="<%=ics.GetVar("cs_imagedir")%>/../wemresources/images/ui/ui/toolbar/calendarButton.png" border="0"/>',
			dropDown: null,
			_onDropDownMouseDown: function(evt) {
				this.dropDown = getTStampWidget(datBox.get('value'), datBox);				
				this.dropDown.set('timeStamp', datBox.get('value') !== '' ?
					new Date(datBox.get('value')) : 
					dojo.date.add(new Date('<%=ics.GetVar("nowDate")%>'), "second" ,((new Date()).getTime() - beginTime)/1000));
				this.dropDown.set('currentFocus', this.dropDown.get('timeStamp'));
				this.openDropDown();
			}
		});
		_ddCalButton_.placeAt(dndCalNode);
		dojo.place(dndCalNode, dndDateNode, 'second');
		_ddCalButton_.startup();
		var rmButtonDiv = dojo.create('div' , {'class':'rmButtonDivDPCls',name: 'delBttnNode'});
		var rmNodeA = dojo.create('a', {'class': 'rmACrossDPCls', style: { display: 'inline-block' }}, rmButtonDiv,'last');
		dojo.place(rmButtonDiv, dndDateNode, 'last');
		dojo.connect(rmButtonDiv, 'onclick', dojo.hitch(rmButtonDiv, removeNode, dndDateNode));
		dndDateContainer && dndDateContainer.insertNodes(false, [dndDateNode]);
		dojo.connect(datBox, 'onChange',  function(){
			prepareMultiDateAttrs();
		});	
		updateDelNodes();	
	};
	
	var addNew = function(){
		if(dndDateContainer.getAllNodes() && (dndDateContainer.getAllNodes().length < maxVals || maxVals < 0))
			buildDndDateBox();	
	};
	
	var removeNode = function(dndDateNode){
		var wids = dijit.findWidgets(dndDateNode);
		dojo.forEach(wids, function(widToDestroy){
			widToDestroy.destroy();	
		});
		dojo.forEach(dndDateNode.children, function(node){
			dojo.destroy(node);		
		});
		dojo.destroy(dndDateNode);
		updateDelNodes();	
	};
	
	var _valueChanged = function(){
		var isUIInputFound = false, dndItems = dndDateContainer.getAllNodes();
		for(var j = 0; j < dndItems.length; j++){
			var wids = dijit.findWidgets(dndItems[j]);
			for(var i = 0; i < wids.length; i++){
				if(!isUIInputFound && wids[i].declaredClass && wids[i].declaredClass === "fw.dijit.UIInput"){
					wids[i].onChange();
					isUIInputFound = true;
					break;
				}
			}
			if(isUIInputFound) break;
		}
	};

	var updateDelNodes = function(){
		if(dndDateContainer.getAllNodes().length === 1){
			dojo.forEach(dndDateContainer.getAllNodes(), function(node){				;
				dojo.style(dojo.query('div[name=delBttnNode]', node)[0], {visibility: 'hidden'});
			});
		}
		if(dndDateContainer.getAllNodes().length > 1){
			dojo.forEach(dndDateContainer.getAllNodes(), function(node){
				dojo.style(dojo.query('div[name=delBttnNode]', node)[0], {visibility: 'visible'});
			});
		}
		_valueChanged();
		prepareMultiDateAttrs();
	};
	
	var container = dojo.query("div[name=<%=ics.GetVar("inputTagMulti") + "_dndSrc_"%>]")[0],
		addButton = createButton('Add');
	dojo.place(addButton, container, 'after');
	dojo.connect(addButton, 'onclick', addNew);
		
	var dndDateContainer = new dojo.dnd.Source(container, {skipForm: true, horizontal:false});
	dojo.safeMixin(dndDateContainer,{
		checkAcceptance:function(source, nodes){
			if(source != this)
				return false;
			return true;
		}
	});
	
	var getTStampWidget = function(dateString, inputDateBox){
		if(!_tstampwgt || (_tstampwgt && !_tstampwgt.domNode)){			
			_tstampwgt  = new fw.ui.dijit.TimestampPicker({
				timePicker: true,
				timeStamp: dateString && dateString!=="" ? new Date(dateString) : new Date()
			});
		}
		dojo.mixin(_tstampwgt, {corrDateBox: inputDateBox});
		var conn_timeStampSelect = dojo.connect(_tstampwgt,	'onTimeStampSelect', function(timeStamp) {
			var formatdate = dojo.date.locale.format(this.timeStamp,{
				selector: 'date',
				datePattern: '<%=ics.GetVar("dateFormatPattern")%>'
			});
			_tstampwgt.corrDateBox.set('value', formatdate);			
			dojo.disconnect(conn_timeStampSelect);		
		});
		
		return _tstampwgt;	
	};
	
	dojo.forEach(datValsArry_<%=ics.GetVar("AttrID")%>, function(eachVal){
		buildDndDateBox(eachVal);
	});	
	
	// if no values byDefault show one dateBox
	if(datValsArry_<%=ics.GetVar("AttrID")%>.length === 0)
		buildDndDateBox();	
	dojo.connect(dndDateContainer, "onDrop", function(source, nodes){
		prepareMultiDateAttrs();
		_valueChanged();
	});
});

</script>
<ics:removevar name="nowDate"/>
</cs:ftcs>
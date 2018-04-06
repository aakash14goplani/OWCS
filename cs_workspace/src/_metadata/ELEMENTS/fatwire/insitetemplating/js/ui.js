// GRM: Reset an object to it's original position and re-init it for dragging (why?)
function insiteReset(obj)
{
  obj.style.left = 0;
  obj.style.top  = 0;

    // does it hurt to do this to an object more than once?    
  Drag.init(obj);

    // register the end event 
  obj.onDragEnd   = insiteEndDrag;
  obj.onDrag      = insiteDrag;
  obj.onDragStart = insiteStartDrag;
}

function insiteStartDrag(x, y) {
  this._dragStarted = true;
  this._xDrag = x;
  this._yDrag = y;
}

function getScrollTop() {
  // IE: document.body.scrollTop returns 0 if a valid doctype is specified
  if (document.documentElement && document.documentElement.scrollTop)
  	return document.documentElement.scrollTop;  	
  else
  	return document.body.scrollTop;
}

function getScrollLeft() {
  if (document.documentElement && document.documentElement.scrollLeft)
  	return document.documentElement.scrollLeft;  	
  else
  	return document.body.scrollLeft;
}

// Check and see if we dragged the given object into the boundary of another object
// if so, swap the two and return true, otherwise return false.
function insiteInBoundary(obj)
{
  // get all the <div class="insite-inner"> elements
  var divs = document.getElementsByTagName("div");
  // loop over each div, skipping the one being moved
  var targetDiv;
  for (i=0; i<divs.length; i++)
  {    
    var current = divs.item(i);
    if (current.id != obj.id && current.className=='insite-inner')
    {
      unhighlightDiv(current);
	  var scrollTop = getScrollTop();
	  var scrollLeft = getScrollLeft();

      if (((obj.lastMouseX+scrollLeft) > getTotalOffsetX(current)) && 
      ((obj.lastMouseX+scrollLeft) < (getTotalOffsetX(current)+current.offsetWidth)) &&
      ((obj.lastMouseY+scrollTop) > getTotalOffsetY(current)) && 
      ((obj.lastMouseY+scrollTop) < (getTotalOffsetY(current)+current.offsetHeight)) )      
      {     
		targetDiv = current;
      }
    }
  }
  if (targetDiv)
  	return targetDiv;
  else
    return false;
}

// Mihir: this function is responsible for changing the highlighted color
function highlightDiv(obj)
{
  obj.style.border="3px dashed #999999";
}

// Mihir: this function is responsible for changing the border back to normal
function unhighlightDiv(obj)
{
  obj.style.border="1px solid #808080";  
}

//GRM: When the user is done dragging, we go to work. 
// if we are in the boundary of another object, great, 
// otherwise we must reset the object to it's original position.
function insiteEndDrag(x,y) {
  // preview window default position may be right on top of a slot.
  // We need to make sure that drag and drop has started AND window
  // has moved before running the handler (otherwise event is fired 
  // together with onclick on delete button).
  if (!this._dragStarted || (this._dragStarted && this._xDrag == x && this._yDrag == y) ) {
	return false;
  }
  
  var target = insiteInBoundary(this);  
  if (target==false) {
    insiteReset(this);
  } else {
    var previewdiv = document.getElementById("fw_it_preview");
        
    previewdiv.style.position = "absolute";  
    previewdiv.style.backgroundColor = "transparent";
    previewdiv.style.top="100px";
    previewdiv.style.left="30px";
    previewdiv.style.zIndex="10000";
    previewdiv.style.width="450px";    
                
    parent.frames['ControlPanel'].fw.controlPanel.setDirty(true);    
    if ( this.className=='insite-inner' )
      swap(target,this);

    var divs = this.getElementsByTagName("div");        
    for (i=0; i<divs.length; i++) {
      if (divs.item(i).className == 'insite-Search') {
        place(target, divs.item(i));  
      }      
    }    
  }
}

//GRM: While the user is dragging, highligh the boxes as he passes
function insiteDrag(x,y)
{
  var target = insiteInBoundary(this);  
  var oldTarget = null;

  if (target!=false)
  {
    highlightDiv(target); 
    oldTarget = target; 
  } else
  {
    if (oldTarget!=null)
      unhighlightDiv(oldTarget);
  }
}

// GRM: place a node from the search
// obj1 is the target slot contents to replace (class insite-inner)
// obj2 is the search result replacing it (class insite-Search)
// obj1's parent should have his child replaced by obj2, and obj2 should have it's class renamed to insite-inner
function place(obj1, obj2) 
{
  // get slot
  var slot = obj1.parentNode;

  // change the classname to insite-inner. It is insite-Search until then
  obj2.className = 'insite-inner';  
  // we need to update the args property with the target inner slot args
  obj2.args = obj1.args;
  // replace the slot contents
  slot.replaceChild(obj2,obj1);  
  // need to update delete button id
  var deleteButton = document.getElementById("delbtn_fw_it_preview");
  if (deleteButton) {
  	deleteButton.id="delbtn_" + slot.id;
  }
  
  // reset the object
  insiteReset(obj2);
  
  // recalc for safety
  recalculateSlots();
}

//GRM: Here's the element swap code, obviously this needs a different 
// alorithm when it's not a swap but an addElement with ajax loader
function swap(obj1, obj2) 
{
  var parent1 = obj1.parentNode;
  var parent2 = obj2.parentNode;

  var child1  = obj1.cloneNode(true);
  var child2  = obj2.cloneNode(true);
  // we need to swap slot arguments too
  var tmpArgs = child1.args;
  child1.args = child2.args;
  child2.args = tmpArgs;

  parent1.replaceChild(child2,obj1);
  parent2.replaceChild(child1,obj2);

  var delbtn1 = document.getElementById("delbtn_" + parent1.id);
  var delbtn2 = document.getElementById("delbtn_" + parent2.id);
  if (delbtn1) delbtn1.id = "delbtn_" + parent2.id;
  if (delbtn2) delbtn2.id = "delbtn_" + parent1.id;

  insiteReset(child1);
  insiteReset(child2);

  recalculateSlots();

  unhighlightDiv(child1);
  unhighlightDiv(child2);
}

function recalculateSlots() 
{
  if (document.all || document.getElementById)
  {
    // get all the <div class="insite-inner"> elements
    var divs = document.getElementsByTagName("div");
    
    // loop over each div
    for (i=0; i<divs.length; i++)
    {
      if (divs.item(i).className=='insite-slot')
      {
        var o=divs.item(i);
        o.style.position = "";
        o.style.zIndex="0";
      }
    }
  }
}

//GRM: Do some setup to get things draggable
function initDragDrop()
{   
  if (document.all || document.getElementById)
  {
    // get all the <div class="insite-inner"> elements
    var divs = document.getElementsByTagName("div");
    // loop over each div
    for (i=0; i<divs.length; i++)
    {
      if (divs.item(i).className=='insite-inner')
        insiteReset(divs.item(i));
      if (divs.item(i).className=='insite-Search')
        insiteReset(divs.item(i));
    }
  }
}


// TODO: This really should not use innerHTML, it should copy a node that is placed in the page from elsewhere.
function deleteSlot(obj) {
  var btnId = obj.id;
  var slotid = btnId.substring(7); // syntax is delbtn_<slotid>
  var slot = document.getElementById(slotid);
  if (slot) {    
    // only delete if we are in a slot
    if (slot.className == 'insite-slot') {
    	var innerSlot; // we need the inner slot, to get slot arguments
    	for (var j = 0; j < slot.childNodes.length; j++) {
    		var current = slot.childNodes[j];
    		if (current.className == "insite-inner") {
    			innerSlot = current;
    			continue;
    		}
    	}
       var args = "";
       // slot arguments are stored in the custom 'args' property
       if (innerSlot.args) args = innerSlot.args;
      slot.innerHTML = '<div class="insite-inner" args="' + innerSlot.args + '"><div class="insite-inner-handle" style="height:50px; vertical-align: middle;"><table height="100%"><tr><td class="empty_slot" nowrap>This slot is empty</td></tr></table></div></div>';
      recalculateSlots();
      var panel = parent.frames["ControlPanel"].fw.controlPanel;
      panel.setDirty(true);
    } else if (slot.id == "fw_it_preview") {
        slot.style.visibility = "hidden";
    }
  }
}


function toggle( targetId, cgipath )
{
  if (document.getElementById)
  {
    target = document.getElementById( targetId ); 
    if (target.style.display == "none")
    {
      target.style.display = ""; 
      document.getElementById('show_hide').style.width="";
      document.getElementById('cpanel_cell').style.display="";
      document.getElementById('hideshow_btn').src=cgipath + "Xcelerate/graphics/common/controlpanel/hide_on.gif";
    } else
    {
      document.getElementById('show_hide').style.width="30px";
      target.style.display = "none"; 
      document.getElementById('cpanel_cell').style.display="none";
      document.getElementById('hideshow_btn').src= cgipath + "Xcelerate/graphics/common/controlpanel/show_on.gif";
    } 
  }
}

function getTotalOffsetX(obj) {
  if (obj.offsetParent) {
  	return obj.offsetLeft + getTotalOffsetX(obj.offsetParent);
  } else {
    return obj.offsetLeft;
  }
}

function getTotalOffsetY(obj) {
  if (obj.offsetParent) {
  	return obj.offsetTop + getTotalOffsetY(obj.offsetParent);
  } else {
    return obj.offsetTop;
  }
}

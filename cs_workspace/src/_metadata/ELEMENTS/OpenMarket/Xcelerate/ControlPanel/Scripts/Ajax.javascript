// namespace
if (fw == undefined) var fw = new Object();

// status codes
fw.READY_STATE_UNINITIALIZED = 0;
fw.READY_STATE_LOADING = 1;
fw.READY_STATE_LOADED = 2;
fw.READY_STATE_INTERACTIVE = 3;
fw.READY_STATE_COMPLETE = 4;

// constructor for Request objects
// params:
//      url
//      onload: handler when request succeeds
//      onerror: handler when request fails
//      method: GET|POST (defaults to GET)
//      params: URL-encoded parameters
//      contentType: defaults to "application/x-www-form-urlencoded" for POST
//
fw.Request=function(url, method, object, onload, onerror, params, contentType) {
    this.url = url;
    this.onerror = (onerror)?onerror:this.defaultErrorHandler;
    this.object = object;
    this.onload = onload;
    this.method = (method)?method:"GET";
    this.params = params;
    this.request = null;
    this.contentType = contentType;
    if (!this.contentType && this.method == "POST") { 
        this.contentType = "application/x-www-form-urlencoded; charset=UTF-8";
    }      
}
 

fw.Request.prototype = {
    load: function(params) {                
        if (window.XMLHttpRequest) {
            this.request = new XMLHttpRequest();        
        } else if (window.ActiveXObject) {
            this.request = new ActiveXObject("Microsoft.XMLHTTP");
        }
           
        if (this.request) {
            try {                          
                var loader = this;                                
                this.request.onreadystatechange=function() { loader.onReadyState(loader); };
                this.request.open(this.method, this.url, true);
                if (this.contentType) {
                    this.request.setRequestHeader("Content-Type", this.contentType);                 
                }
                if(this.method == "POST"){
					var WEM = (typeof WemContext != 'undefined') ? WemContext.getInstance() :  window.parent.WemContext ? 
					window.parent.WemContext.getInstance() : (typeof window.parent.parent.WemContext != 'undefined') ? window.parent.parent.WemContext.getInstance() : window.parent.parent.WemContext;
				
					if(WEM && WEM.getAuthTicket()){
						this.request.setRequestHeader("X-CSRF-Token", WEM.getAuthTicket());
					} else {
						if(this.object && this.object.authticket){
							this.request.setRequestHeader("X-CSRF-Token", this.object.authticket);
						} else {
							this.request.setRequestHeader("X-CSRF-Token", "X-CSRF-Token");
						}
					}
				} 
                this.request.send(params);
            } catch(err) {
                this.onerror.call(this);
            }
        }
    },
    
    onReadyState: function() {          
      try {      
        var request = this.request;        
        var state = request.readyState;                
        if (state == fw.READY_STATE_COMPLETE) {                
            var status = request.status;
            if (status == 200 || status == 0) {                
                this.onload.call(this.object, this.request);
            } else {
                this.onerror.call(this.object, this.request);
            }
        }
      } catch(err) {      	
      	alert("An error occurred executing request handler:\n" 
      			+ err.name + " (" + err.message + ")\n" + this.onload);
      }
    },
    
    defaultErrorHandler: function() {
        alert("error fetching data: " + this.url); 
    }                           
} // end Request prototype




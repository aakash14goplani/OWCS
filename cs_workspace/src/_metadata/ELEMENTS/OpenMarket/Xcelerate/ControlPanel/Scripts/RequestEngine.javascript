// namespace
if (fw == undefined) var fw = new Object();

/**
*
*
*
*/
fw.RequestEngine = function() {
	this._requests = new Array();
}

fw.RequestEngine.prototype = {
	register: function(requestName, requestUrl, method, requestHandlerObject, requestHandlerMethod, errorHandlerMethod, contentType) {
		var request = new fw.Request(requestUrl, method, requestHandlerObject, requestHandlerMethod, errorHandlerMethod, null, contentType);
		this._requests[requestName] = request;
	},
	
	send: function(requestName, params) {	
		var request = this._requests[requestName];
		if (request) {			
			request.load(params);
		} 
	}
}


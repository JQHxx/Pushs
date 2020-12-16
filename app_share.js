var curBridge;
Initialize();

function Initialize(){
   if(getPlatform()=='ios'){ 
        setupWebViewJavascriptBridge(function(bridge) {
            curBridge = bridge;
            //注册一个JS方法供iOS调用
			bridge.registerHandler('getShare', function(data, responseCallback) {
				//当收到iOS调用JS时做的操作
				getShare();
			});

			//文章图片点击(直接调用)
			$('.text-part img').click(function(){
				var src = $(this).attr('src');
				var params = {"src":src};
				if(getPlatform()=='ios'){
					curBridge.callHandler('pushSrc', params, function(response) {
						
					});
				}
			})
        });
    }
}

function getPlatform(){
	var ua = navigator.userAgent.toLowerCase();	
	if (/iphone|ipad|ipod/.test(ua)) {
		    return "ios";		
	} else if (/android/.test(ua)) {
		return "android";	
	}
	return "";
}

function getShare(){
	var shareJson = $.parseJSON($('#shareJson').val());
	var params = {title:shareJson.title,desc:shareJson.desc,picUrl:shareJson.picUrl,wapUrl:shareJson.wapUrl};
	if(getPlatform()=='ios'){
		curBridge.callHandler('getShare', params, function(response) {});
	}else if(getPlatform()=='android'){
		window.jscontrol.getShare(JSON.stringify(params));
	}
}

function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

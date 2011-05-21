//	IRFlashView

@import <AppKit/CPFlashView.j>

@implementation IRFlashView : CPFlashView

- (void) setParameters:(CPDictionary)aDictionary {
	
	var isIE = CPBrowserIsEngine(CPInternetExplorerBrowserEngine);
	
	if (_paramElements && !isIE) {
		
		var elements = [_paramElements allValues], count = [elements count];
	
		for (var i = 0; i < count; i++)
		_DOMObjectElement.removeChild([elements objectAtIndex:i]);
	
	}
	
	_params = aDictionary;
	
	if (isIE) {
		
		[self _rebuildIEObjects];
		return;
		
	}

	_paramElements = [CPDictionary dictionary];

	var enumerator = [_params keyEnumerator], key;

	while ((key = [enumerator nextObject]) && _DOMObjectElement) {
		
		//	A bug in original implementation makes key = ([enumerator nextObject] && _DOMObjectElement)
		//	Since this project has to work against stock I need to patch it
	
		var param = document.createElement(@"param");
		param.name = key;
		param.value = [_params objectForKey:key];

		_DOMObjectElement.appendChild(param);
		[_paramElements setObject:param forKey:key];
	
	}
	
}





- (id) initWithFrame:(CGRect)aFrame {
	
	self = [super initWithFrame:aFrame];
	
	self.actualID = "IRFlashView_" + [self UID];
	
	if (!self) return nil;

	if (!CPBrowserIsEngine(CPInternetExplorerBrowserEngine))
	_DOMObjectElement.setAttribute('id', self.actualID); 
	
	return self;

}

- (void)_rebuildIEObjects {
	
		[super _rebuildIEObjects];
		if (_DOMObjectElement)
		_DOMObjectElement.outerHTML = _DOMObjectElement.outerHTML.replace("object classid", "object id='" + self.actualID + "' classid");
		
}

- (id) scriptingObject {
	
	return document[self.actualID] || window[self.actualID];
	
}

@end
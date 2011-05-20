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
	
		var param = document.createElement(@"param");
		param.name = key;
		param.value = [_params objectForKey:key];

		_DOMObjectElement.appendChild(param);
		[_paramElements setObject:param forKey:key];
	
	}
	
}

@end
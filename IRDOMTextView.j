//	IRDOMTextView.j
//	A very simple readonly (not editable) view whose DOMElement is used to hold “stuff” which is HTML rich text.
	
@import <AppKit/CPView.j>

IRDOMTextView_LayoutView = nil;
	
@implementation IRDOMTextView : CPView {
	
	CPString contentHTMLString @accessors;
	id contentWrapper;
	
}

- (id) initWithFrame:(CGRect)aFrame {
	
	self = [super initWithFrame:aFrame];
	if (!self) return nil;
	
	[self setContentHTMLString:nil];
	
	return self;
	
}

- (id) contentWrapper {
	
	if (!contentWrapper) {
		
		//	As in CPPlatformString.j
	
		contentWrapper = document.createElement("span");
		
		contentWrapper.style.display = "block";
	    contentWrapper.style.position = "absolute";
	    contentWrapper.style.visibility = "visible";
	    contentWrapper.style.padding = "0px";
	    contentWrapper.style.margin = "0px";
	    contentWrapper.style.width = "100%";
	    contentWrapper.style.wordWrap = "break-word";
		
		_DOMElement.appendChild(contentWrapper);
	
	}
	
	return contentWrapper;
	
}

- (void) setFont:(CPFont)aFont {
	
	[self contentWrapper].style.font = [aFont cssString];
	
}

- (void) setContentHTMLString:(CPString)newString {
	
	if (contentHTMLString == newString)
	return;
	
	[self willChangeValueForKey:@"contentHTMLString"];
	[self contentWrapper].innerHTML = newString || @"";
	[self didChangeValueForKey:@"contentHTMLString"];

}

+ (CGSize) sizeWithString:(CPString)aString font:(CPFont)aFont width:(CGFloat)aWidth {
	
	if (!IRDOMTextView_LayoutView) {

		IRDOMTextView_LayoutView = [[self alloc] initWithFrame:CGRectMake(-1024, -1024, 1024, 1024)];
		[[[[CPApplication sharedApplication] mainWindow] contentView] addSubview:IRDOMTextView_LayoutView];
	
	}
	
	[IRDOMTextView_LayoutView setFrame:CGRectMake(-1 * aWidth, -1 * 1024, aWidth, 1024)];
	[IRDOMTextView_LayoutView setFont:aFont];
	[IRDOMTextView_LayoutView setContentHTMLString:aString];
	
	return CGSizeMake(aWidth, [IRDOMTextView_LayoutView contentWrapper].clientHeight);
	
}

@end

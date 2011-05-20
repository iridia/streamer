//	IRTwitterStreamDataView.j

@import <AppKit/AppKit.j>
@import "IRDOMTextView.j"

@implementation IRTwitterStreamDataView : CPView {
	
	IODOMTextView textView @accessors;
	id objectValue @accessors;
	
}

- (id) initWithFrame:(CGRect)aFrame {
	
	self = [super initWithFrame:aFrame];
	if (!self) return nil;
	
	[self mnConfigure];
	
	return self;
	
}

- (id) initWithCoder:(CPCoder)aCoder {
	
	self = [super initWithCoder:aCoder];
	if (!self) return nil;
	
	[self mnConfigure];
	
	return self;
	
}

- (void) mnConfigure {
	
	textView = [[IRDOMTextView alloc] initWithFrame:[self bounds]];
	[textView setFont:[CPFont systemFontOfSize:13]];
	[textView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[self addSubview:textView];
	
}

- (void) setObjectValue:(id)anObject {
	
	if (objectValue === anObject) return; // -isEqual: ?
	
	[self willChangeValueForKey:@"objectValue"];
	objectValue = anObject;
	[textView setContentHTMLString:[CPString stringWithFormat:@"%@", [anObject valueForKeyPath:@"text"]]];
	[self didChangeValueForKey:@"objectValue"];

}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
	
	CPLog(@"%@, object %@ was set selected? %x, animated? %x", self, [self objectValue], selected, animated);
	
}

- (BOOL) setThemeState:(CPThemeState)aState {
	
	var superAllowed = [super setThemeState:aState];
	[self setSelected:[self hasThemeState:CPThemeStateSelectedDataView] animated:NO];
	return superAllowed;
	
}

- (BOOL) unsetThemeState:(CPThemeState)aState {

	var superAllowed = [super unsetThemeState:aState];
	[self setSelected:[self hasThemeState:CPThemeStateSelectedDataView] animated:NO];
	return superAllowed;

}

+ (CGFloat) preferredRowHeightForObject:(id)anObject width:(CGFloat)aWidth {
	
	CPLog(@"anObject %@", anObject);
	
	var bodySize = [IRDOMTextView sizeWithString:[anObject valueForKeyPath:@"text"] font:[CPFont systemFontOfSize:13.0] width:(aWidth || 0)];
	
	return (bodySize && bodySize.height || 0) + 16;
	
}

@end
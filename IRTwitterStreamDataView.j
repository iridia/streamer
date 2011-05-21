//	IRTwitterStreamDataView.j

@import <AppKit/AppKit.j>
@import "IRDOMTextView.j"

@implementation IRTwitterStreamDataView : CPView {
	
	IODOMTextView textView @accessors;
	CPTextField senderLabel @accessors;
	CPTextField timeLabel @accessors;
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
	
	var ownBounds = [self bounds];
	var paddedWidth = ownBounds.size.width - 20;
	
	[self setBackgroundColor:[CPColor whiteColor]];
	
	textView = [[IRDOMTextView alloc] initWithFrame:[self bounds]];
	senderLabel = [CPTextField labelWithTitle:nil];
	timeLabel = [CPTextField labelWithTitle:nil];
	
	[textView setFrame:CGRectMake(10, 32, paddedWidth, ownBounds.size.height - 40)];
	[textView setFont:[CPFont systemFontOfSize:13]];
	[textView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[self addSubview:textView];
	
	[senderLabel setFont:[CPFont boldSystemFontOfSize:13.0]];
	[senderLabel setFrame:CGRectMake(10, 8, paddedWidth - 56, 24)];
	[senderLabel setAutoresizingMask:CPViewWidthSizable|CPViewMaxYMargin];
	[self addSubview:senderLabel];
	
	[timeLabel setFont:[CPFont systemFontOfSize:13.0]];
	[timeLabel setFrame:CGRectMake(10 + paddedWidth - 48, 8, 48, 24)];
	[timeLabel setAutoresizingMask:CPViewMinXMargin|CPViewMaxYMargin];
	[timeLabel setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[self addSubview:timeLabel];

}

- (void) setObjectValue:(id)anObject {
	
	//	CPLog(@"obj %@", anObject);
	
	if (objectValue === anObject) return; // -isEqual: ?
	
	var creationDate = new Date([anObject valueForKeyPath:@"created_at"]);
	
	[self willChangeValueForKey:@"objectValue"];
	objectValue = anObject;
	[senderLabel setStringValue:[CPString stringWithFormat:@"%@", [anObject valueForKeyPath:@"from_user"]]];	
	[timeLabel setStringValue:!creationDate ? nil : [CPString stringWithFormat:@"%@%i:%@%i", 
		(creationDate.getHours() < 10 ? "0" : ""), creationDate.getHours(), 
		(creationDate.getMinutes() < 10 ? "0" : ""), creationDate.getMinutes()
	]];
	[textView setContentHTMLString:[CPString stringWithFormat:@"%@", [anObject valueForKeyPath:@"text"]]];
	[self didChangeValueForKey:@"objectValue"];

}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
	
	//	CPLog(@"%@, object %@ was set selected? %x, animated? %x", self, [self objectValue], selected, animated);
	
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
	
	var bodySize = [IRDOMTextView sizeWithString:[anObject valueForKeyPath:@"text"] font:[CPFont systemFontOfSize:13.0] width:((aWidth || 20) - 20)];
	
	return (bodySize && bodySize.height || 0) + 40;
	
}

@end
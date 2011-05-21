//	IRStreamerBaseViewController.j
		
@import <AppKit/AppKit.j>
@import "IRStreamingVideoViewController.j"
@import "IRStreamerTwitterStreamViewController.j"

var sidebarWidth = 224;

@implementation IRStreamerBaseViewController : CPViewController {
		
	CPSplitView mainSplitView;
	
	IRStreamingVideoViewController streamingVideoController;
	IRStreamerTwitterStreamViewController twitterStreamViewController;
	
}

- (id) init {
	
	self = [super init];
	if (!self) return nil;
	
	streamingVideoController = [[IRStreamingVideoViewController alloc] init];
	twitterStreamViewController = [[IRStreamerTwitterStreamViewController alloc] init];
	
	return self;
	
}

- (void) loadView {
	
	mainSplitView = [[CPSplitView alloc] initWithFrame:CGRectMake(0, 0, 512, 512)];
	[mainSplitView setIsPaneSplitter:YES];
	[mainSplitView setDelegate:self];
	[self setView:mainSplitView];
	
	var leftView = [streamingVideoController view];
	[leftView setFrame:CGRectMake(0, 0, 384, 512)];
	[mainSplitView addSubview:leftView];
	
	[streamingVideoController beginBroadcastingFromUStreamChannelNamed:@"machinima-live-stream" withAPIKey:@"869AAF2EAB4DC4926A6A62396A68FADB"];
	[twitterStreamViewController beginStreamingWithTerms:@"#TEDxTokyo OR #PP17 OR from:punchparty OR from:OOBE"];
	
	var rightView = [twitterStreamViewController view];
	[rightView setFrame:CGRectMake(0, 0, sidebarWidth, 512)];
	[mainSplitView addSubview:rightView];
	
}

- (CPSplitView) view {
	return [super view];	
}

- (void) splitViewDidResizeSubviews:(CPNotification)notification {
	if ([notification object] == mainSplitView)
	[mainSplitView setPosition:([mainSplitView bounds].size.width - sidebarWidth) ofDividerAtIndex:0];
}

- (CGFloat) splitView:(CPSplitView)aSplitView constrainMinCoordinate:(CGFloat)proposedPosition ofSubviewAt:(int)dividerIndex {
	if (aSplitView == mainSplitView)	
	return [mainSplitView bounds].size.width - sidebarWidth;
	return proposedPosition;
}

- (CGFloat) splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(CGFloat)proposedPosition ofSubviewAt:(int)dividerIndex {
	if (aSplitView == mainSplitView)
	return [mainSplitView bounds].size.width - sidebarWidth;
	return proposedPosition;
}

@end

//	IRStreamerBaseViewController.j
		
@import <AppKit/AppKit.j>
@import "IRStreamingVideoViewController.j"
@import "IRStreamerTwitterStreamViewController.j"

var sidebarWidth = 224;

@implementation IRStreamerBaseViewController : CPViewController {
		
	CPSplitView splitView;
	
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
	
	splitView = [[CPSplitView alloc] initWithFrame:CGRectMake(0, 0, 512, 512)];
	[splitView setIsPaneSplitter:YES];
	[splitView setDelegate:self];
	[self setView:splitView];
	
	var leftView = [streamingVideoController view];
	[leftView setFrame:CGRectMake(0, 0, 384, 512)];
	[splitView addSubview:leftView];
	
	[streamingVideoController beginBroadcastingFromUStreamChannelNamed:@"nied-kyoshin01" withAPIKey:@"869AAF2EAB4DC4926A6A62396A68FADB"];
	
	var rightView = [twitterStreamViewController view];
	[rightView setFrame:CGRectMake(0, 0, sidebarWidth, 512)];
	[splitView addSubview:rightView];
	
}

- (void) splitViewDidResizeSubviews:(CPNotification)notification {

	[splitView setPosition:([splitView bounds].size.width - sidebarWidth) ofDividerAtIndex:0];

}

- (CPSplitView) view {
	
	return [super view];
	
}





- (CGFloat) splitView:(CPSplitView)aSplitView constrainMinCoordinate:(CGFloat)proposedPosition ofSubviewAt:(int)dividerIndex {

	return [splitView bounds].size.width - sidebarWidth;

}

- (CGFloat) splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(CGFloat)proposedPosition ofSubviewAt:(int)dividerIndex {
	
	return [splitView bounds].size.width - sidebarWidth;

}

@end
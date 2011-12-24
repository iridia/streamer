//	IRStreamerBaseViewController.j
		
@import <AppKit/AppKit.j>
@import "IRStreamingVideoViewController.j"
@import "IRStreamerTwitterStreamViewController.j"

var sidebarWidth = 224;
var sidebarVideoHeight = 178;

@implementation IRStreamerBaseViewController : CPViewController {
		
	CPSplitView mainSplitView;
	CPSplitView rightSplitView;
	
	IRStreamingVideoViewController streamingVideoController;
	IRStreamingVideoViewController altStreamingVideoController;
	IRStreamerTwitterStreamViewController twitterStreamViewController;
	
}

- (id) init {
	
	self = [super init];
	if (!self) return nil;
	
	streamingVideoController = [[IRStreamingVideoViewController alloc] init];
	twitterStreamViewController = [[IRStreamerTwitterStreamViewController alloc] init];
	altStreamingVideoController = [[IRStreamingVideoViewController alloc] init];
	
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
	
	var altToggle = [CPButtonBar plusButton];
  [altToggle setImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[self class]] pathForResource:@"Alt.png"]]];
	[altToggle setTarget:self];
	[altToggle setAction:@selector(handleToggle:)];
  
	rightView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, sidebarWidth, 512)];
	var streamViewFrame = CGRectMakeCopy([rightView bounds]);
	
	// var buttonBar = [[CPButtonBar alloc] initWithFrame:CGRectMake(0, 512 - 25, sidebarWidth, 25)];
	// [buttonBar setAutoresizingMask:CPViewWidthSizable|CPViewMinYMargin];
	// [buttonBar setButtons:[CPArray arrayWithObjects:altToggle]];
	// streamViewFrame.size.height -= 25;
	// [rightView addSubview:buttonBar];
	
	rightSplitView = [[CPSplitView alloc] initWithFrame:streamViewFrame];
	[rightSplitView setVertical:NO];
	[[twitterStreamViewController view] setFrame:[rightSplitView bounds]];
	[[twitterStreamViewController view] setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[[altStreamingVideoController view] setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable]; // duh
	[altStreamingVideoController setMuted:YES];
	[rightSplitView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[rightSplitView addSubview:[twitterStreamViewController view]];
//	[rightSplitView addSubview:[altStreamingVideoController view]];
	[rightView addSubview:rightSplitView];
	[mainSplitView addSubview:rightView];
	
//	[rightSplitView setDelegate:self];
	
	[streamingVideoController beginBroadcastingFromUStreamChannelNamed:@"oobe-roadoshow" withAPIKey:@"869AAF2EAB4DC4926A6A62396A68FADB"];
	[[streamingVideoController view] setBackgroundColor:[CPColor blackColor]];
//	[altStreamingVideoController beginBroadcastingFromUStreamChannelNamed:@"machinima-live-stream" withAPIKey:@"869AAF2EAB4DC4926A6A62396A68FADB"];
	[twitterStreamViewController beginStreamingWithTerms:@"#PPTF OR #PunchParty OR from:punchparty"];
	
}

- (CPSplitView) view {
	return [super view];	
}

- (IBAction) handleToggle:(id)sender {
	
	window.setTimeout(function(){
	
	if ([[altStreamingVideoController view] superview]) {
		[[altStreamingVideoController view] removeFromSuperview];
	} else {		
		[[altStreamingVideoController view] setFrame:CGRectMake(0, 0, sidebarWidth, sidebarVideoHeight)];
		[rightSplitView addSubview:[altStreamingVideoController view]];
	}
	
  [rightSplitView setNeedsDisplay:YES];
  [mainSplitView setNeedsDisplay:YES];
	
	}, 1);
	
}

- (void) splitViewDidResizeSubviews:(CPNotification)notification {
	
	if ([notification object] == mainSplitView)
	[mainSplitView setPosition:([mainSplitView bounds].size.width - sidebarWidth) ofDividerAtIndex:0];
	
	if ([notification object] == rightSplitView)
	[rightSplitView setPosition:([rightSplitView bounds].size.height - sidebarVideoHeight) ofDividerAtIndex:0];

}

- (CGFloat) splitView:(CPSplitView)aSplitView constrainMinCoordinate:(CGFloat)proposedPosition ofSubviewAt:(int)dividerIndex {
	if (aSplitView == mainSplitView)	
	return [mainSplitView bounds].size.width - sidebarWidth;

	if (aSplitView == rightSplitView)
	return [rightSplitView bounds].size.height - sidebarVideoHeight;

	return proposedPosition;
}

- (CGFloat) splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(CGFloat)proposedPosition ofSubviewAt:(int)dividerIndex {
	if (aSplitView == mainSplitView)
	return [mainSplitView bounds].size.width - sidebarWidth;
	
	if (aSplitView == rightSplitView)	
	return [rightSplitView bounds].size.height - sidebarVideoHeight;
	
	return proposedPosition;
}

@end

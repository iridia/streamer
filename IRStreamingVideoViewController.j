//	IRStreamingVideoViewController.j
//	http://www.ustream.tv/json/channel/nied-kyoshin01/getEmbedTag?869AAF2EAB4DC4926A6A62396A68FADB

@import <AppKit/AppKit.j>
@import <IRWebAPIKit/IRWebAPIKit.j>
@import <IRBlockEnumeration/IRBlockEnumeration.j>
@import <IRDelegation/IRDelegation.j>
@import <CPObject-DelayedPerforming/CPObject+DelayedPerforming.j>

@import "IRFlashView.j"

@implementation IRStreamingVideoViewControllerAPIContext : IRWebAPIContext

+ (id) context { return [self contextWithBaseURL:[CPURL URLWithString:@"http://www.ustream.tv/json/"]]; }

- (CPURL) connectionURLForMethodNamed:(CPString)methodName arguments:(CPDictionary)argumentsToSend serializer:(Function)serializer {
	
	//	http://www.ustream.tv/json/channel/nied-kyoshin01/getEmbedTag?869AAF2EAB4DC4926A6A62396A68FADB
	
	if ([methodName isEqual:@"getEmbedTag"]) {

		var returnedURL = [CPURL URLWithString:[CPString stringWithFormat:@"channel/%@/%@?callback=%@&key=%@",
	
			[argumentsToSend objectForKey:@"channelName"],
			@"getEmbedTag",
			CPJSONPCallbackReplacementString,
			[argumentsToSend objectForKey:@"apiKey"]
	
		] relativeToURL:[self baseURL]];
	
		return returnedURL;
	
	}
	
	return nil;
	
}

@end

@implementation IRStreamingVideoViewController : CPViewController {
	
	IRWebAPIEngine engine;
	CPFlashView flashView;
	BOOL muted @accessors;
	
}

- (void) init {
	
	self = [super init];
	if (!self) return nil;
	
	engine = [[IRWebAPIEngine alloc] initWithContext:[IRStreamingVideoViewControllerAPIContext context]];
	
	return self;
	
}

- (void) loadView {
	
	[self setView:[[CPView alloc] initWithFrame:CGRectMake(0, 0, 512, 512)]];
	[[self view] setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];	
		
}

- (void) setupFlashViewWithChannelID:(CPString)anID {
	
	flashView = [[IRFlashView alloc] init];
	[flashView setParameters:[CPDictionary dictionaryWithObjectsAndKeys:
		@"true", @"allowfullscreen",
		@"transparent", @"wmode",
		@"always", @"allowscriptaccess",
		@"true", @"swLiveConnect"
	]];
	[flashView setFlashVars:[CPDictionary dictionaryWithObjectsAndKeys:
		@"bar", @"foo",
		@"IRUStreamViewDefaultCallback", @"callbackName",
		anID, @"channelID",
		[self muted], @"viewerMuted"
	]];
	
	[flashView setFlashMovie:[CPFlashMovie flashMovieWithFile:[[CPBundle bundleForClass:[self class]] pathForResource:@"IRUStreamView.swf"]]];
	[flashView setFrame:[[self view] bounds]];
	[flashView setBackgroundColor:[CPColor blackColor]];
	[flashView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[[self view] addSubview:flashView];
	
}

- (void) beginBroadcastingFromUStreamChannelNamed:(CPString)aChannelName withAPIKey:(CPString)anAPIKey {
	
	[engine fireAPIRequestNamed:@"getEmbedTag" withArguments:[CPDictionary dictionaryWithObjectsAndKeys:
	
		aChannelName, @"channelName",
		anAPIKey, @"apiKey"
	
	] onSuccess:function (response) {
		
		//	IRWebAPIKit and UStream API idiosyncrasy workaround
		var html = @"", enumerator = [response objectEnumerator], o;
		while (o = [enumerator nextObject]) html += o;
		
		var tempDiv = document.createElement('div');
		tempDiv.innerHTML = html;
		
		//	foo=bar&lorem=ipsum to CPDictionary
		var flashVars = [CPMutableDictionary dictionary];
		[((tempDiv.getElementsByTagName("embed")[0]).getAttribute("flashvars")).split("&") enumerateObjectsUsingBlock:function(object, index){ var splitObjs = object.split("="); [flashVars setObject:splitObjs[1] forKey:splitObjs[0]]; }];
		
		var channelID = [flashVars objectForKey:@"cid"];		
		[self setupFlashViewWithChannelID:channelID];		
		
	} failure:function () {
		
		CPLog(@"Fail!");
		
	}];
	
	
}

@end

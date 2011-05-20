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

- (void) beginBroadcastingFromUStreamChannelNamed:(CPString)aChannelName withAPIKey:(CPString)anAPIKey {
	
	[engine fireAPIRequestNamed:@"getEmbedTag" withArguments:[CPDictionary dictionaryWithObjectsAndKeys:
	
		aChannelName, @"channelName",
		anAPIKey, @"apiKey"
	
	] onSuccess:function (response) {
		
		var html = "", enumerator = [response objectEnumerator], o;
		while (o = [enumerator nextObject]) html += o;
		
		var tempDiv = document.createElement('div');
		tempDiv.innerHTML = html;
		
		var embedTag = tempDiv.getElementsByTagName("embed"), flashTag = embedTag[0];
		
		var actualView = [[IRFlashView alloc] initWithFrame:CGRectMake(0, 0, 512, 512)];
		[actualView setParameters:[CPDictionary dictionaryWithObjectsAndKeys:
		
			@"true", @"allowfullscreen",
			@"always", @"allowscriptaccess",
			flashTag.getAttribute("flashvars"), @"flashvars"
		
		]];
		
		[actualView setFlashMovie:[CPFlashMovie flashMovieWithFile:flashTag.getAttribute("src")]];
		[actualView setFrame:[[self view] bounds]];
		[actualView setBackgroundColor:[CPColor blackColor]];
		[actualView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
		
		[[self view] addSubview:actualView];
		
	} failure:function () {
		
		CPLog(@"Fail!");
		
	}];
	
	
}

@end

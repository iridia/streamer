//	IRTwitterSearch.j
	
@import <AppKit/AppKit.j>
@import <IRWebAPIKit/IRWebAPIKit.j>
	
@implementation IRTwitterSearch : CPObject {
	
	id lastIdentifier @accessors; // id_str, using compare: or so
	BOOL busy @accessors(getter=isBusy);
	CPDate lastFinishedDate @accessors;
	
	IRWebAPIEngine engine @accessors;
	
}

+ (id) search {
	
	return [[self alloc] init];
	
}

- (id) init {
	
	self = [super init]; if (!self) return nil;
	
	engine = [[IRWebAPIEngine alloc] initWithContext:[IRWebAPIContext contextWithBaseURL:[CPURL URLWithString:@"http://search.twitter.com/#{methodName}.json?#{methodArguments}"]]];
	lastIdentifier = @"0";
	
	return self;
	
}

- (void) fireSearchUsingTerms:(CPString)terms callback:(Function)aCallback {
		
	[[self engine] fireAPIRequestNamed:@"search" withArguments:[CPDictionary dictionaryWithObjectsAndKeys:
	
		terms, @"q",
		[self lastIdentifier], @"since_id"
	
	] onSuccess:function(resp) {
		
		var results = [[resp valueForKeyPath:@"results"] sortedArrayUsingFunction:function(lhs, rhs){
			return [[lhs valueForKeyPath:@"id_str"] compare:[rhs valueForKeyPath:@"id_str"]];
		}];
		
		if (![results count]) return;
		
		var bounced = [CPMutableArray array];
		
		[results enumerateObjectsUsingBlock:function(object,index) {
			
			var tweetID = [object valueForKeyPath:@"id_str"];
			var validTweet = ([[self lastIdentifier] compare:tweetID] == CPOrderedAscending);
			if (!validTweet) return;
			
			[self setLastIdentifier:tweetID];
			[bounced addObject:object];
			
		}];
		
		aCallback(bounced);
		
	} failure:function (resp) {
		
		CPLog(@"duh %@", resp);
	
	}];

}

@end
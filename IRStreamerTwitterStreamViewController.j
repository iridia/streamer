//	IRStreamerTwitterStreamViewController.j
	
@import "IRTableViewController.j"
@import "IRTwitterStreamDataView.j"
@import "IRTwitterSearch.j"

@implementation IRStreamerTwitterStreamViewController : IRTableViewController {
	
	IRTwitterSearch twitterSearch @accessors;
	CPTimer timer @accessors;
	
}

- (id) irConfigure {
	
	[super irConfigure];
	[self setDataViewPrototype:[[IRTwitterStreamDataView alloc] init]];
	[self setTwitterSearch:[IRTwitterSearch search]];
	
	[[self arrayController] setSortDescriptors:[CPArray arrayWithObject:[CPSortDescriptor sortDescriptorWithKey:@"id_str" ascending:NO]]];
	[[self tableView] setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
	
}

- (void) beginStreamingWithTerms:(CPString)terms {
	
	if (timer) 
	return;
	
	var timerCallback = function(){
		
		[[self twitterSearch] fireSearchUsingTerms:terms callback:function(resp) {
			
			if (![resp count])
			return;
			
			[[self arrayController] addObjects:resp];
			[[self tableView] reloadData]; // TBD handle this gracefully memorizing offset et al in the future
			
		}];
				
	};
	
	[self setTimer:[CPTimer scheduledTimerWithTimeInterval:30.0 callback:timerCallback repeats:YES]];
	timerCallback();
	
}

@end

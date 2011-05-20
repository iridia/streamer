//	IRStreamerTwitterStreamViewController.j
	
@import "IRTableViewController.j"
@import "IRTwitterStreamDataView.j"
@import "IRTwitterSearch.j"

@implementation IRStreamerTwitterStreamViewController : IRTableViewController {
	
	IRTwitterSearch twitterSearch @accessors;
	
}

- (id) irConfigure {
	
	[super irConfigure];
	[self setDataViewPrototype:[[IRTwitterStreamDataView alloc] init]];
	[self setTwitterSearch:[IRTwitterSearch search]];
	
	[[self arrayController] setSortDescriptors:[CPArray arrayWithObject:[CPSortDescriptor sortDescriptorWithKey:@"id_str" ascending:NO]]];
	
}

- (void) beginStreamingWithTerms:(CPString)terms {
	
	[[self twitterSearch] fireSearchUsingTerms:terms callback:function(resp){
		[[self arrayController] addObjects:resp];
		[[self tableView] reloadData]; // TBD handle this gracefully memorizing offset et al in the future
	}];
	
}

@end

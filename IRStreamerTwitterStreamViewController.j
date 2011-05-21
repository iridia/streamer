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
	
}

- (void) loadView {
	
	[super loadView];
	
	[[self tableView] setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
	[[self tableView] setGridStyleMask:CPTableViewGridNone];
	[[self tableView] setUsesAlternatingRowBackgroundColors:YES];
	
}

- (void) beginStreamingWithTerms:(CPString)terms {
	
	if (timer) 
	return;
	
	var timerCallback = function(){
		
		[[self twitterSearch] fireSearchUsingTerms:terms callback:function(resp) {
			
			if (![resp count])
			return;
			
			var keepsOffset = [[[self arrayController] arrangedObjects] count] && ([[[self scrollView] contentView] boundsOrigin].y > 8);
			var reload = function () {
				[[self arrayController] addObjects:resp];
				[[self tableView] reloadData]; // TBD handle this gracefully memorizing offset et al in the future
			}
			
			if (!keepsOffset) {
				
				reload();
				
			} else {
			
				var oldOffset = [[[self scrollView] contentView] boundsOrigin];
				var oldRowIndex = [[self tableView] rowAtPoint:oldOffset];
				var oldRowFrame = [[self tableView] frameOfDataViewAtColumn:0 row:oldRowIndex];
				var representedObject = [[[self arrayController] arrangedObjects] objectAtIndex:oldRowIndex];
				reload();
				var newRepresentedObjectIndex = [[[self arrayController] arrangedObjects] indexOfObject:representedObject];
				var newRowFrame = [[self tableView] frameOfDataViewAtColumn:0 row:newRepresentedObjectIndex];
				
				[[self scrollView] moveByOffset:CGSizeMake(0, newRowFrame.origin.y - oldRowFrame.origin.y)];
			
			}		
			
		}];
				
	};
	
	[self setTimer:[CPTimer scheduledTimerWithTimeInterval:10.0 callback:timerCallback repeats:YES]];
	timerCallback();
	
}

@end

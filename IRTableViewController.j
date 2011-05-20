//	IRTableViewController.j
	
@implementation IRTableViewController : CPViewController {
	
	CPTableView tableView;
	CPArrayController arrayController;
	
}

- (void) loadView {
	
	[self setView:[[CPTableView alloc] init]];
	
}

- (void) refresh {
	
	//	IRWebAPIKit connections here
	
}

- (void) scheduleRefresh {
	
	
	
}

@end

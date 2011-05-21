//	IRTableViewController.j
	
@import <AppKit/AppKit.j>

@implementation IRTableViewController : CPViewController {
	
	CPArrayController arrayController @accessors;
	CPScrollView scrollView @accessors;
	CPTableView tableView @accessors;
	CPView dataViewPrototype @accessors;
	
}

- (id) initWithCibName:(CPString)aCibNameOrNil bundle:(CPBundle)aCibBundleOrNil {

	self = [super initWithCibName:aCibNameOrNil bundle:aCibBundleOrNil];
	if (!self) return nil;
	
	[self irConfigure];
	
	return self;

}

- (id) initWithCoder:(CPCoder)aCoder {
	
	self = [super initWithCoder:aCoder];
	if (!self) return nil;
	
	[self irConfigure];	
	
	return self;
	
}

- (void) irConfigure {
	
	[self setArrayController:[[CPArrayController alloc] init]];
	
}

- (CPScrollView) view {
	
	return [super view];
	
}

- (void) loadView {
	
	scrollView = [[CPScrollView alloc] init];
	tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];

	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setRowHeight:32];
	[tableView setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];
	[tableView setGridStyleMask:CPTableViewSolidHorizontalGridLineMask];
	[tableView setHeaderView:nil];
	[tableView setCornerView:nil];
	
	[scrollView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[scrollView setDocumentView:tableView];
	[scrollView setHasHorizontalScroller:NO];
	[self setView:scrollView];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:@"column"];
	[column setDataView:[self dataViewPrototype]];
	[tableView addTableColumn:column];
	
}

- (void) viewDidLoad {
	
	[super viewDidLoad];
	
	[[self view] setPostsFrameChangedNotifications:YES];
	[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewFrameDidChange:) name:CPViewFrameDidChangeNotification object:[self view]];
	
}

- (int) numberOfRowsInTableView:(CPTableView)inTableView {
		
	return [[arrayController arrangedObjects] count] || 0;
	
}

- (id) tableView:(CPTableView)inTableView objectValueForTableColumn:(CPTableColumn)inTableColumn row:(int)inRow {
	
	return [[arrayController arrangedObjects] objectAtIndex:inRow];

}

- (void) handleViewFrameDidChange:(CPNotification)aNotification {
	
	[[self tableView] noteHeightOfRowsWithIndexesChanged:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, [[self tableView] numberOfRows])]];
	
}

- (CGFloat) tableView:(CPTableView)aTableView heightOfRow:(int)row {
	
	//	This is flaky and seem very filmsy, but at least it delegates work to the right thing
	
	var column = [aTableView tableColumnWithIdentifier:@"column"];
	return [[[column dataView] class] preferredRowHeightForObject:[self tableView:aTableView objectValueForTableColumn:column row:row] width:[aTableView bounds].size.width];
	
}

@end

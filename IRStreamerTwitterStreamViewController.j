//	IRStreamerTwitterStreamViewController.j
	
@import "IRTableViewController.j"
@import "IRTwitterStreamDataView.j"

@implementation IRStreamerTwitterStreamViewController : IRTableViewController

- (id) irConfigure {
	
	[super irConfigure];
	[self setDataViewPrototype:[[IRTwitterStreamDataView alloc] init]];
	
}

@end

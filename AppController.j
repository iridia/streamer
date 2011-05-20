/*
 * AppController.j
 * app
 *
 * Created by Evadne Wu on May 19, 2011.
 * Copyright 2011, Monoceros All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "IRStreamerBaseViewController.j"

@implementation AppController : CPObject {
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

	var rootVC = [[IRStreamerBaseViewController alloc] init];
	[[rootVC view] setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
	[[rootVC view] setFrame:[contentView bounds]];
    [contentView addSubview:[rootVC view]];

    [theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end

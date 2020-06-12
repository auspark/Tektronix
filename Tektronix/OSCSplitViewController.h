//
//  OSCSplitViewController.h
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/12.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OSCSetttingViewController.h"
#import "OSCCaptureViewController.h"
#import "TekDevice.h"
@interface OSCSplitViewController : NSSplitViewController<OSCSetttingViewControllerDelegate,OSCCaptureViewControllerDelegate>

@property (strong) OSCSetttingViewController *setViewController;
@property (strong) OSCCaptureViewController *captureViewController;

- (IBAction)expandSidebar:(id)sender;

- (IBAction)collapseSidebar:(id)sender;


@end

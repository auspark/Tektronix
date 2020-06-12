//
//  AppDelegate.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/10.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}
@end

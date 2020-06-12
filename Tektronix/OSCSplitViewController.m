//
//  OSCSplitViewController.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/12.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "OSCSplitViewController.h"

@interface OSCSplitViewController ()
{
    TekDevice *scopeManager;
}
@end

@implementation OSCSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *childViews = [self childViewControllers];
    for (id obj in childViews) {
        if ([obj isMemberOfClass:[OSCSetttingViewController class]]) {
            self.setViewController = obj;
            self.setViewController.delegate=self;
        }
        if ([obj isMemberOfClass:[OSCCaptureViewController class]]) {
            self.captureViewController = obj;
            self.captureViewController.delegate=self;
        }
    }
    // Do view setup here.
}

-(void)viewDidAppear{
    [self connectToScope];
}

-(void)connectToScope{
    scopeManager=nil;
    scopeManager = [[TekDevice alloc]init];
    [scopeManager getDeviceLists];
    if (scopeManager.firstDeviceName!=nil) {
        [scopeManager connnect];
    }
}


-(IBAction)showOrHideSettingView:(id)sender{
    NSToolbarItem *settingToolbarItem = (NSToolbarItem *)sender;
    if (settingToolbarItem.tag==0) {
        [self removeChildViewControllerAtIndex:0];
        settingToolbarItem.tag=1;
    }
    else{
        settingToolbarItem.tag=0;
        [self insertChildViewController:self.setViewController atIndex:0];
    }
}


-(void)runScopeCommand:(NSString *)command{
    NSLog(@"%@",command);
    NSError *error = [scopeManager sendCommand:command];
    if (error!=nil){
        [self showAlertView:[error description]];
    }
}

-(void)buildUSBPort{
    [scopeManager disconnect];
    [self connectToScope];
}

-(void)showAlertView:(NSString *)information{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Error:";
    [alert setShowsHelp:NO];
    NSString* name = [NSString stringWithFormat:@"%@",information];
    alert.informativeText = name;
    alert.alertStyle = NSAlertStyleWarning;
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
}

-(NSData *)getNewScreenshotData{
    if (scopeManager==nil || scopeManager.firstDeviceName==nil) {
        [self connectToScope];
    }
    NSError *error;
    NSString *cmd = NSLocalizedString(@"SaveImage", @"");
    error = [scopeManager sendCommand:cmd];
    if (error!=nil){
        [self showAlertView:[error description]];
        return nil;
    }
    NSString *cmd1 =NSLocalizedString(@"Hardcopy", @"");
    error = [scopeManager sendCommand:cmd1];
    if (error!=nil){
        [self showAlertView:[error description]];
        return nil;
    }
    NSData *data = [scopeManager readData:&error];
    if (error!=nil){
        [self showAlertView:[error description]];
        return nil;
    }
    return data;
}

-(NSString *)getFirstInstrumentDevice{
    return scopeManager.firstDeviceName;
}

@end

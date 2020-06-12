//
//  OSCCaptureViewController.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/12.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "OSCCaptureViewController.h"

@interface OSCCaptureViewController ()

@end

@implementation OSCCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.spanel = [self createSavePanel];
}

-(void)viewDidAppear{
    [self updateDeviceName];
}

-(void)updateDeviceName{
    if ([self.delegate respondsToSelector:@selector(getFirstInstrumentDevice)]) {
        NSString *name = [self.delegate getFirstInstrumentDevice];
        if (name==nil) {
            self.deviceName.stringValue=@"";
        }else{
            self.deviceName.stringValue=[self.delegate getFirstInstrumentDevice];
        }
    }
}

-(NSSavePanel *)createSavePanel{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"Save Picture";
    [panel setMessage:@"Please select saved directory"];
        //    [panel setNameFieldStringValue:@"123"];
    [panel setAllowedFileTypes:@[@"png"]];
    [panel setExtensionHidden:NO];
    [panel setCanCreateDirectories:YES];
    return panel;
}

- (IBAction)researchUSBPort:(id)sender {
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(buildUSBPort)]){
        [self.delegate buildUSBPort];
    }
    [self updateDeviceName];
}

- (IBAction)refresh:(id)sender {
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getNewScreenshotData)]){
        self.imageView.image=[[NSImage alloc]initWithData:[self.delegate getNewScreenshotData]];
    }
}

- (IBAction)save:(id)sender {
    NSData *data = [self.imageView.image TIFFRepresentation];
    if (data==nil || data.length==0) {
        [self showAlertView:@"No Image need to save!"];
        return;
    }
    [self.spanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result){
        NSString *path = [[self.spanel URL]path];
        [data writeToFile:path atomically:YES];
    }];
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

@end

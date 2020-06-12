//
//  OSCCaptureViewController.h
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/12.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol OSCCaptureViewControllerDelegate <NSObject>
-(NSData *)getNewScreenshotData;
-(NSString *)getFirstInstrumentDevice;
-(void)buildUSBPort;
@end

@interface OSCCaptureViewController : NSViewController
@property (weak) IBOutlet NSImageView *imageView;
@property(nonatomic)NSSavePanel *spanel;
@property (weak) IBOutlet NSTextField *deviceName;

@property(nonatomic)id<OSCCaptureViewControllerDelegate> delegate;

@end

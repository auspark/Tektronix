//
//  OSCSetttingViewController.h
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/12.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol OSCSetttingViewControllerDelegate <NSObject>

-(void)runScopeCommand:(NSString *)command;

@end

@interface OSCSetttingViewController : NSViewController

@property(nonatomic)id<OSCSetttingViewControllerDelegate> delegate;


@end



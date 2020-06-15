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

@property (readwrite) NSArray *TRIGger_A_EDGE_SLOpe;
@property (readwrite) NSArray *SELECT_CH;
@property (readwrite) NSArray *HARDCOPY_INKSAVER;

@property (readwrite) NSArray *ACQuire_STOPAfter;
@property (readwrite) NSArray *TRIGger_A_EDGE_SOUrce;
@property (readwrite) NSArray *TRIGger_A_TYPe;

@property (readwrite) NSArray *TRIGGER_A_EDGE_COUPLING;
@property (readwrite) NSArray *TRIGGER_A_MODE;
@end



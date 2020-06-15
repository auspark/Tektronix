//
//  OSCSetttingViewController.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/12.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "OSCSetttingViewController.h"

@interface OSCSetttingViewController ()
{
    NSMutableDictionary *TfBtnMutDict;
}
@end

@implementation OSCSetttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.TRIGger_A_EDGE_SLOpe=@[@"RISe",@"FALL",@"EITHer"];
    self.SELECT_CH=@[@"ON",@"OFF"];
    self.HARDCOPY_INKSAVER=@[@"OFF",@"ON"];
    self.ACQuire_STOPAfter=@[@"SEQuence",@"RUNSTop"];
    self.TRIGger_A_EDGE_SOUrce=@[@"CH1",@"CH2",@"CH3",@"CH4"];
    self.TRIGger_A_TYPe=@[@"EDGe",@"LOGIc",@"PULSe",@"BUS",@"VIDeo"];
    self.TRIGGER_A_EDGE_COUPLING=@[@"DC",@"AC",@"HFRej",@"LFRej",@"NOISErej"];
    self.TRIGGER_A_MODE=@[@"NORMal",@"AUTO"];
}

-(void)viewDidAppear{
    if (TfBtnMutDict==nil)
        TfBtnMutDict=[NSMutableDictionary dictionary];
    else
        [TfBtnMutDict removeAllObjects];
    NSTabView *tabview = [[self.view subviews] firstObject];
    NSArray *tArr = [tabview tabViewItems];
    for (NSTabViewItem *item in tArr) {
        for (id obj in item.view.subviews) {
            if ([obj isMemberOfClass:[NSButton class]]) {
                [(NSButton *)obj setTarget:self];
                [(NSButton *)obj setAction:@selector(clickButton:)];
            }
            else {
                NSString *identifier = [(NSButton *)obj identifier];
                [TfBtnMutDict setObject:obj forKey:identifier];
            }
        }
    }
}

-(void)clickButton:(NSButton *)sender{
    NSArray *m = [sender.identifier componentsSeparatedByString:@"."];
    NSString *tfIndex = [NSString stringWithFormat:@"%@.%@.2",m[0],m[1]];
    id tf = [TfBtnMutDict objectForKey:tfIndex];
    NSString *strtmp = NSLocalizedString(tfIndex,comment=@"");
    NSString *cmd = nil;
    if ([tfIndex isEqualToString:@"6.5.2"]) {
        id tf1 = [TfBtnMutDict objectForKey:@"6.1.2"];
        cmd = [NSString stringWithFormat:strtmp,[self textField_popupField_value:tf1],[self textField_popupField_value:tf]];
    }else{
        cmd = [NSString stringWithFormat:strtmp,[self textField_popupField_value:tf]];
    }
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(runScopeCommand:)] ) {
        [self.delegate runScopeCommand:cmd];
    }
}

-(NSString *)textField_popupField_value:(id)obj{
    if ([obj isMemberOfClass:[NSTextField class]]) {
        return [(NSTextField *)obj stringValue];
    }
    else if ([obj isMemberOfClass:[NSPopUpButton class]]){
        return [(NSPopUpButton *)obj titleOfSelectedItem];
    }else{
        return  nil;
    }
}


@end

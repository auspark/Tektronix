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
            else if ([obj isMemberOfClass:[NSTextField class]]){
                NSString *identifier = [(NSButton *)obj identifier];
                [TfBtnMutDict setObject:obj forKey:identifier];
            }
        }
    }
}

-(void)clickButton:(NSButton *)sender{
    NSArray *m = [sender.identifier componentsSeparatedByString:@"."];
    NSString *tfIndex = [NSString stringWithFormat:@"%@.%@.2",m[0],m[1]];
    NSTextField *tf = [TfBtnMutDict objectForKey:tfIndex];
    NSString *strtmp = NSLocalizedString(tfIndex,comment=@"");
    NSString *cmd = nil;
    if ([tfIndex isEqualToString:@"6.5.2"]) {
        NSTextField *tf1 = [TfBtnMutDict objectForKey:@"6.1.2"];
        cmd = [NSString stringWithFormat:strtmp,tf1.stringValue,tf.stringValue];
    }else{
        cmd = [NSString stringWithFormat:strtmp,tf.stringValue];
    }
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(runScopeCommand:)] ) {
        [self.delegate runScopeCommand:cmd];
    }
}

@end

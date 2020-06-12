//
//  TekDeviceManager.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/11.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "TekDeviceManager.h"

@interface TekDeviceManager ()

@end

static TekDeviceManager *sharedInstance = nil;

@implementation TekDeviceManager
{
    NSMutableArray <TekDevice *> *tekdevices;
    
}


+ (TekDeviceManager *)sharedManager;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) sharedInstance = [(TekDeviceManager *)[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)scan{
    if (tekdevices!=nil) {
        [tekdevices removeAllObjects];
    }
    else{
        tekdevices = [NSMutableArray array];
    }
    
    
}


@end

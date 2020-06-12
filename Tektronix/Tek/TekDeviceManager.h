//
//  TekDeviceManager.h
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/11.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//
//主要任务:
//1. 寻找设备, 并将找到的设备建立object对象
//2. 注册并监听设备的插拔事件, 并及时更新device list
//3. 设置代理或通知, 以方便其它程序在设备在线状态改变时, 及时响应状态

#import "TekDevice.h"
#import <Foundation/Foundation.h>

@interface TekDeviceManager : NSObject

@end


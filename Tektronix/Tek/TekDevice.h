//
//  TekDevice.h
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/11.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//
//主要任务:
//1. 打开/关闭连接
//2. 设置通信参数
//3. 发送/读取command
//4. 侦测状态变化
//5. 数据处理
#import <Foundation/Foundation.h>
#import "visa.h"
@interface TekDevice : NSObject
//-(id)initWithDescriptor:(NSString *)descriptor;
+(instancetype) shareInstance;
-(NSError *)getDeviceLists;
-(NSString *)firstDeviceName;
-(BOOL)connnect;
-(BOOL)disconnect;
-(NSError *)sendCommand:(NSString *)command;
-(NSData *)readData:(NSError **)error;
@end


@interface NSData (DataOtherType)
-(int)toInt;
-(NSString *)toString;
-(float)toFloat;
@end


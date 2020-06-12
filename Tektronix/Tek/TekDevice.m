//
//  TekDevice.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/11.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "TekDevice.h"
NSError *tekErrorStatus(NSString *description, ViStatus theStatus){
    return [NSError errorWithDomain:NSCocoaErrorDomain code:theStatus userInfo:@{NSLocalizedDescriptionKey:description}];
}
static TekDevice* _instance = nil;
@implementation TekDevice
{
    ViUInt32 numInstrs;
    ViFindList findList;
    ViSession defaultRM, instr;
    ViStatus status;
    char instrDescriptor[VI_FIND_BUFLEN];
    NSMutableArray *rsrcMArr;
    BOOL rmIsOpen,instrIsOpen;
    unsigned char readbuffer[VI_FIND_BUFLEN];
};

+(instancetype) shareInstance
{
    if (_instance==nil) {
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            _instance = [[TekDevice alloc] init];
        }) ;
    }
    return _instance ;
}

-(id)init{
    if (self=[super init]) {
        rsrcMArr = [[NSMutableArray alloc]initWithCapacity:0];
        rmIsOpen=NO;
        instrIsOpen=NO;
    }
    return self;
}

//-(id)initWithDescriptor:(NSString *)descriptor{
//    if (self=[super init]) {
//        rsrcMArr = [[NSMutableArray alloc]initWithCapacity:0];
//        rmIsOpen=NO;
//        instrIsOpen=NO;
//    }
//    [rsrcMArr addObject:descriptor];
//    return self;
//}

-(NSError *)getDeviceLists{
    rmIsOpen=instrIsOpen=NO;
    [self closeRmSession];
    [self closeInstrSession];
    if (rsrcMArr!=nil) {
        [rsrcMArr removeAllObjects];
    }else{
        rsrcMArr = [NSMutableArray array];
    }
    status = viOpenDefaultRM (&defaultRM);
    rmIsOpen=YES;
    if (status < VI_SUCCESS){
        [self closeRmSession];
        return tekErrorStatus(@"Could not open a session to the VISA Resource Manager!", status);
    }
    status = viFindRsrc (defaultRM, "?*INSTR", &findList, &numInstrs, instrDescriptor);
    if (status < VI_SUCCESS){
        [self closeRmSession];
        return tekErrorStatus(@"An error occurred while finding resources.", status);
    }
    [rsrcMArr addObject:[NSString stringWithUTF8String:instrDescriptor]];
    while (--numInstrs){
        status = viFindNext (findList, instrDescriptor);
        if (status < VI_SUCCESS){
            [self closeRmSession];
            return tekErrorStatus(@"An error occurred finding the next resource.", status);
       }
       [rsrcMArr addObject:[NSString stringWithUTF8String:instrDescriptor]];
    }
    NSLog(@"device list:%@",rsrcMArr);
    return nil;
}


-(NSString *)firstDeviceName{
    if (rsrcMArr==nil || rsrcMArr.count==0) {
        return nil;
    }
    return rsrcMArr[0];
}

-(void)closeRmSession{
    rmIsOpen=NO;
    viClose(defaultRM);
}

-(void)closeInstrSession{
    instrIsOpen=NO;
    viClose(instr);
}

-(BOOL)disconnect{
    [self closeRmSession];
    [self closeInstrSession];
    return YES;
}

-(BOOL)connnect{
    if (rsrcMArr!=0 && rsrcMArr.count>0) {
        NSError *error = [self openDevice:rsrcMArr[0]];
        if (error!=nil) {
            NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

-(NSError *)openDevice:(NSString *)deviceInstrDescriptor{
    status = viOpen (defaultRM, (ViRsrc)deviceInstrDescriptor.UTF8String, VI_NULL, VI_NULL, &instr);
    instrIsOpen=YES;
    if (status < VI_SUCCESS){
        [self closeInstrSession];
        return tekErrorStatus([NSString stringWithFormat:@"An error occurred opening a session to %@\n",deviceInstrDescriptor], status);
    }
    return nil;
}

-(NSError *)sendCommand:(NSString *)command{
    if (instrIsOpen) {
        ViPUInt32 retCnt = 0;
        status = viWrite(instr, (ViBuf)command.UTF8String, (ViUInt32)command.length, retCnt);
        if (status < VI_SUCCESS) {
            [self closeInstrSession];
            return tekErrorStatus([@"An error occurred sending a command:" stringByAppendingString:command], status);
        }
        return nil;
    }
    return tekErrorStatus(@"rsrc manager or instr don't open!", 0);
}

//ViStatus viRead(ViSession vi, ViPBuf buf, ViUInt32 count, ViPUInt32 retCount)
-(NSData *)readData:(NSError **)error{
    if (!instrIsOpen) {
        *error = tekErrorStatus(@"rsrc manager or instr don't open!", 0);
    }else{
        NSMutableData *retData = [NSMutableData data];
        ViPUInt32 retCount=0;
        do{
            memset(readbuffer, '\0', VI_FIND_BUFLEN);
            status = viRead(instr, readbuffer, VI_FIND_BUFLEN, retCount);
            if (status < VI_SUCCESS) {
                [self closeInstrSession];
                *error = tekErrorStatus([@"An error occurred reading data:" stringByAppendingFormat:@"%d(%s)",(unsigned int)retCount,readbuffer], status);
                break;
            }
            if (retCount>=0) {
                [retData appendData: [NSData dataWithBytes:readbuffer length:sizeof(readbuffer)]];
            }
        }while (status>VI_SUCCESS);
        return retData;
    }
    return nil;
}

-(int)data2int:(NSData *)data{
    return CFSwapInt32BigToHost(*(int*)([data bytes]));
}


@end

@implementation NSData (DataOtherType)
union intToFloat
{
    uint32_t i;
    float fp;
};

-(float)floatAtOffset:(NSUInteger)offset
               inData:(NSData*)data
{
    assert([data length] >= offset + sizeof(float));
    union intToFloat convert;

    const uint32_t* bytes = [data bytes] + offset;
    convert.i = CFSwapInt32BigToHost(*bytes);

    const float value = convert.fp;

    return value;
}
-(int)toInt{
    return CFSwapInt32BigToHost(*(int*)([self bytes]));
}
-(NSString *)toString{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
-(float)toFloat{
    double MDD_times;
    [self getBytes: &MDD_times length:sizeof(double)];
    return MDD_times;
}
@end







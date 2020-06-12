//
//  VisaDriver.m
//  Tektronix
//
//  Created by Jerry.Yang on 2020/6/10.
//  Copyright © 2020 Jerry.Yang. All rights reserved.
//

#import "VisaDriver.h"

@implementation VisaDriver

-(short)searchDevice{
    ViSession defaultRM,instr;
    ViStatus status;
    ViFindList findList;
    ViUInt32 numInstrs;
    char instrDescriptor[VI_FIND_BUFLEN];
    status = viOpenDefaultRM(&defaultRM);
    if (status<VI_SUCCESS) {
        NSLog(@"Could not open a session to the VISA Resource Manager!\n");
        return status;
    }
    status = viFindRsrc(defaultRM, "?*INSTR", &findList, &numInstrs, instrDescriptor);
    if (status<VI_SUCCESS) {
        NSLog(@"An error occurred while finding resources.\nHit enter to continue.");
        fflush(stdin);
//        getchar();
        viClose (defaultRM);
        return status;
    }
    //print the first device
    NSLog(@"%d instruments, serial ports, and other resources found:\n\n",numInstrs);
    
    NSLog(@"%s \n",instrDescriptor);
    status = viOpen (defaultRM, instrDescriptor, VI_NULL, VI_NULL, &instr);
    if (status < VI_SUCCESS)
    {
        printf ("An error occurred opening a session to %s\n",instrDescriptor);
    }
    else
    {
    ViBuf buf = "CH1:SCAle 5.00";
    viWrite(defaultRM, buf, 15, 0);
       /* Now close the session we just opened.                            */
       /* In actuality, we would probably use an attribute to determine    */
       /* if this is the instrument we are looking for.                    */
       viClose (instr);
    }
//    do{
//        status = viFindNext(findList, instrDescriptor);
//    }while (status>=VI_SUCCESS);
    status = viClose(findList);
    status = viClose (defaultRM);
    printf ("\nHit enter to continue.");
    fflush(stdin);
//    getchar();
    return 0;
}


@end

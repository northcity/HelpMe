//
//  ViewController.m
//  Help
//
//  Created by chenxi on 2018/5/14.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ViewController.h"
 #import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getCurrentBatteryLevel];
}

- (int)getCurrentBatteryLevel
{
    
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
                {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar)
                    {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
                        NSLog(@"电池电量:%d",batteryLevel);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                            
                        } else {
                            return 0;
                        }
                    }
                    
                }
                
            }
        }
    }
    
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

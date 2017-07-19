//
//  UncaughtExceptionHandler.h
//  living
//
//  Created by hxm on 2017/7/5.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include <sys/signal.h>


@interface UncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}
@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);

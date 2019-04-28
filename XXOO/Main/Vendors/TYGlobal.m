//
//  TYGlobal.m
//  XXOO
//
//  Created by wbb on 2019/4/28.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGlobal.h"
#import "HDeviceIdentifier.h"

@implementation TYGlobal
+ (NSString *)getDeviceIdentifier {
    NSString *deviceIdentifier = [USER_DEFAULTS objectForKey:@"deviceIdentifier"];
    if (!deviceIdentifier) {
        NSString *identifier = [HDeviceIdentifier deviceIdentifier];
        [USER_DEFAULTS setObject:identifier forKey:@"deviceIdentifier"];
        [USER_DEFAULTS synchronize];
    }
    return deviceIdentifier?:@"";
}
@end

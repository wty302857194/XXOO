//
//  TestItem.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TestItem.h"

@implementation TestItem
- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if ( !self ) return nil;
    _title = title;
    return self;
}
@end

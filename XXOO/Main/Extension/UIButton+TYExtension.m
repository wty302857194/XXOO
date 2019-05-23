//
//  UIButton+TYExtension.m
//  XXOO
//
//  Created by wbb on 2019/4/26.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "UIButton+TYExtension.h"

static const char *key = "index";
static const char *myKey = "index1";

@implementation UIButton (TYExtension)

//NSInteger的类型为什么不行？
//- (void)setMyIndex:(NSInteger)myIndex {
//    objc_setAssociatedObject(self, myKey, myIndex, OBJC_ASSOCIATION_ASSIGN);
//}
//- (NSInteger)myIndex {
//    return objc_getAssociatedObject(self, myKey);
//}



- (void)setIndex:(NSNumber *)index {
    objc_setAssociatedObject(self, key, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)index {
    return objc_getAssociatedObject(self, key);
}
@end

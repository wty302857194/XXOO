//
//  UIButton+TYExtension.m
//  XXOO
//
//  Created by wbb on 2019/4/26.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "UIButton+TYExtension.h"

static const char *key = "index";

@implementation UIButton (TYExtension)

//NSInteger的类型为什么不行？
//- (void)setIndex:(NSInteger)index {
//     objc_setAssociatedObject(self, key, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (int)index {
//    return objc_getAssociatedObject(self, key);
//}

- (void)setIndex:(NSNumber *)index {
    objc_setAssociatedObject(self, key, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)index {
    return objc_getAssociatedObject(self, key);
}

-(void)setHighlighted:(BOOL)highlighted {
    
}
@end

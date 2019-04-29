//
//  UINavigationController+TYExtension.h
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (TYExtension)
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

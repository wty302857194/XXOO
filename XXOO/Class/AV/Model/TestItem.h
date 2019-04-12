//
//  TestItem.h
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestItem : NSObject

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END

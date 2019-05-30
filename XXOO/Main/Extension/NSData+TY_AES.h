//
//  NSData+TY_AES.h
//  XXOO
//
//  Created by wbb on 2019/5/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (TY_AES)
- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密
@end

NS_ASSUME_NONNULL_END

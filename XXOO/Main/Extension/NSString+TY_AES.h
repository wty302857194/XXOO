//
//  NSString+TY_AES.h
//  XXOO
//
//  Created by wbb on 2019/5/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TY_AES)
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;
@end

NS_ASSUME_NONNULL_END

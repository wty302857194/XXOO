//
//  TYTGHistoryModel.h
//  XXOO
//
//  Created by wbb on 2019/5/5.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 account: "2",                         //提现账号
 bankName: "2",                        //银行名称
 createTime: "2019-04-20 12:03:26",    //提现申请时间
 id: 1,                                //ID
 modifyTime:"2019-04-20 12:03:26",     //成功提现时间
 money: 2,                            //提现金额
 payee: "2",                          //收款人
 state: 2,                            //提现状态（1申请 2申请通过 3已打款 4申请不通过）
 type: 2,                             //提现方式（1支付宝 2银行卡）
 uid: 2                               //用户id
 }
 */
@interface TYTGHistoryModel : TYBaseModel

@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * bankName;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * modifyTime;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * payee;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * uid;

@end

NS_ASSUME_NONNULL_END

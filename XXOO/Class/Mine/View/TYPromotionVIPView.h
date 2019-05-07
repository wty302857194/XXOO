//
//  TYPromotionVIPView.h
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^PromotionVIPBlock)(NSString *type);
@interface TYPromotionVIPView : TYBaseView
@property (weak, nonatomic) IBOutlet UIImageView *topBackImg;
@property (weak, nonatomic) IBOutlet UIButton *renMinBIBnt;
@property (weak, nonatomic) IBOutlet UIButton *taiBiBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) PromotionVIPBlock promotionVIPBlock;

@end

NS_ASSUME_NONNULL_END

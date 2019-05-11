//
//  TYMyPaySelectView.h
//  XXOO
//
//  Created by wbb on 2019/5/9.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectBlock)(NSInteger index);
@interface TYMyPaySelectView : TYBaseView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *airPlayView;
@property (weak, nonatomic) IBOutlet UIView *weiChaView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIImageView *weiChaImg;
@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END

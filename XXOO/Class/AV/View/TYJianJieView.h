//
//  TYJianJieView.h
//  XXOO
//
//  Created by wbb on 2019/4/23.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CancelBtnBlock)(void);
@interface TYJianJieView : TYBaseView
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy) CancelBtnBlock cancelBtnBlock;
@end

NS_ASSUME_NONNULL_END

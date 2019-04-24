//
//  TYAVDetailCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JianJieBlock)(void);
@interface TYAVDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UIView *jianJieView;


@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIButton *currentBtn;//当前选择线路
@property (weak, nonatomic) IBOutlet UIButton *problemBtn;//问题汇报
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;//收藏影片
@property (nonatomic, copy) JianJieBlock jianJieBlock;
@end

NS_ASSUME_NONNULL_END

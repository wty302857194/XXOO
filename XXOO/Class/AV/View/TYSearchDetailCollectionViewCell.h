//
//  TYSearchDetailCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHomeModel.h"



NS_ASSUME_NONNULL_BEGIN

typedef void(^ItemShouCangBlock)(void);

@interface TYSearchDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic, strong) TYHomeItemModel * itemModel;
@property (nonatomic, copy) ItemShouCangBlock itemShouCangBlock;
@end

NS_ASSUME_NONNULL_END

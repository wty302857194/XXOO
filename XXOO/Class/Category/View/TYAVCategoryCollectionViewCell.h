//
//  TYAVCategoryCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/5/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAVCategaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAVCategoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) TYAVCategaryModel * model;
@end

NS_ASSUME_NONNULL_END

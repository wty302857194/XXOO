//
//  TYAVDetailContentCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAVDetailContentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


@property (nonatomic, strong) TYHomeItemModel * itemModel;
@end

NS_ASSUME_NONNULL_END

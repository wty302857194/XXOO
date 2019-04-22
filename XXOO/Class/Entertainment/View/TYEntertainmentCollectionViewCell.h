//
//  TYEntertainmentCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYEntertainmentItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface TYEntertainmentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, strong) TYEntertainmentItemModel * itemModel;
@end

NS_ASSUME_NONNULL_END

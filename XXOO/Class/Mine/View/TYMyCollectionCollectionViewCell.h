//
//  TYMyCollectionCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAVHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYMyCollectionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) TYAVHistoryModel * collectionModel;
@end

NS_ASSUME_NONNULL_END

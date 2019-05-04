//
//  TYGoddessCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYActorModel.h"
#import "TYAVHistoryModel.h"

typedef void(^ShouCangBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TYGoddessCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (nonatomic, copy) ShouCangBlock  shouCangBlock;
@property (nonatomic, strong) TYActorListModel * listModel;

@property (nonatomic, strong) TYAVHistoryModel * goddessModel;
@end

NS_ASSUME_NONNULL_END

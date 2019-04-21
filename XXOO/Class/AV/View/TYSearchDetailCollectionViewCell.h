//
//  TYSearchDetailCollectionViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSearchDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@end

NS_ASSUME_NONNULL_END

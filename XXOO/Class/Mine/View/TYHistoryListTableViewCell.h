//
//  TYHistoryListTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAVHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYHistoryListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *longTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (nonatomic, strong) TYAVHistoryModel * model;
@end

NS_ASSUME_NONNULL_END

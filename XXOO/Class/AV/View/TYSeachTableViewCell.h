//
//  TYSeachTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHotSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYSeachTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) TYHotSearchModel * hotModel;
- (void)cellWithModel:(TYHotSearchModel *)model andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END

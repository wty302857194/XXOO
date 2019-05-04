//
//  TYTuiGuangTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYLevelAgentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYTuiGuangTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *idlab;
@property (weak, nonatomic) IBOutlet UILabel *fanLiLab;
@property (weak, nonatomic) IBOutlet UILabel *xiaJILab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *yejiLab;

- (void)getMessage:(id)dataSource indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END

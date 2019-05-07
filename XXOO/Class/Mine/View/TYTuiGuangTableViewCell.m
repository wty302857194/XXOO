//
//  TYTuiGuangTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTuiGuangTableViewCell.h"

@implementation TYTuiGuangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.idlab.text = @"";
    self.fanLiLab.text = @"";
    self.timeLab.text = @"";
    self.yejiLab.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)getMessage:(id)dataSource indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.idlab.text = @"id";
        self.fanLiLab.text = @"返利比例";
        self.timeLab.text = @"加入时间";
        self.yejiLab.text = @"累计业绩";
    }else {
        TYLevelAgentModel *model = (TYLevelAgentModel *)dataSource;
        self.idlab.text = model.ID;
        self.fanLiLab.text = model.agentRatio;
        
        NSArray *arr = [model.createTime componentsSeparatedByString:@" "];
        self.timeLab.text = arr[0]?:@"";
        self.yejiLab.text = model.spreadNum;
    }
}
@end

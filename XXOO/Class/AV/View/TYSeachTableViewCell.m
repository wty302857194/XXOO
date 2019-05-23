//
//  TYSeachTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSeachTableViewCell.h"

@implementation TYSeachTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rankLab.text = @"";
    self.titleLab.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellWithModel:(TYHotSearchModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2) {
        self.rankLab.backgroundColor = indexPath.row == 0?hexColor(da374c):(indexPath.row == 2?hexColor(e76d48):hexColor(e76d48));
        self.rankLab.textColor = [UIColor whiteColor];

    }else {
        self.rankLab.backgroundColor = [UIColor clearColor];
        self.rankLab.textColor = main_light_text_color;
    }
    self.rankLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    self.titleLab.text = model.title;
}

@end

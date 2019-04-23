//
//  TYHomeTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYHomeTableViewCell.h"

@implementation TYHomeTableViewCell

- (IBAction)saveClick:(UIButton *)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItemModel:(TYHomeItemModel *)itemModel {
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:itemModel.cover] placeholderImage:[UIImage imageNamed:@"image_ready"]];
    self.nameLab.text = itemModel.title;
    self.timeLab.text = itemModel.timeLong;
    
}

@end

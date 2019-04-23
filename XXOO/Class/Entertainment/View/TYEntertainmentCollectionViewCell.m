//
//  TYEntertainmentCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYEntertainmentCollectionViewCell.h"
#import "TYEntertainmentModel.h"

@implementation TYEntertainmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setItemModel:(TYEntertainmentItemModel *)itemModel {

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.picUrl] placeholderImage:[UIImage imageNamed:@"image_ready"]];
    self.titleLab.text = itemModel.title;
}
@end

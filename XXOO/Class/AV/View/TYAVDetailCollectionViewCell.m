//
//  TYAVDetailCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVDetailCollectionViewCell.h"

@implementation TYAVDetailCollectionViewCell

- (IBAction)problemClick:(UIButton *)sender {
    
}

- (IBAction)collectionClick:(UIButton *)sender {
    
}

- (IBAction)selectClick:(UIButton *)sender {
    
}
- (void)setDetailModel:(TYAVDetailModel *)detailModel {
    self.titleLab.text = detailModel.title;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.jianJieView addTarget:self action:@selector(jianJieClick)];
}
- (void)jianJieClick {
    if (self.jianJieBlock) {
        self.jianJieBlock();
    }
}
@end

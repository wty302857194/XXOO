//
//  TYJianJieView.m
//  XXOO
//
//  Created by wbb on 2019/4/23.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYJianJieView.h"

@implementation TYJianJieView
- (IBAction)cancelBtn:(UIButton *)sender {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLab.text = @"";
}

@end

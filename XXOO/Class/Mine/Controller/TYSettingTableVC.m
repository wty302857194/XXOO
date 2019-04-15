//
//  TYSettingTableVC.m
//  XXOO
//
//  Created by wbb on 2019/4/15.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSettingTableVC.h"
@interface TYSettingTableVC ()

@end
@implementation TYSettingTableVC
- (IBAction)isOpenSwitch:(UISwitch *)sender {
    sender.on = !sender.on;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
}

@end

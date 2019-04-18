//
//  TYUserTableViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYUserTableViewController.h"
#import "TYSettingTableVC.h"
#import "TYMyTuiGunagViewController.h"

@interface TYUserTableViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayout;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *vipLogoImg;
@property (weak, nonatomic) IBOutlet UIButton *buyVIPBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgLayout;
@property (weak, nonatomic) IBOutlet UILabel *myJiFen_lab;

@end

@implementation TYUserTableViewController
- (IBAction)settingClick:(UIButton *)sender {
    
}
- (IBAction)buyVIPClick:(UIButton *)sender {
}
- (IBAction)featureBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
        case 103:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topViewLayout.constant = kStatusBarHeight;
    self.backImgLayout.constant = -kStatusBarHeight;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}



#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        TYMyTuiGunagViewController *vc = [[TYMyTuiGunagViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end

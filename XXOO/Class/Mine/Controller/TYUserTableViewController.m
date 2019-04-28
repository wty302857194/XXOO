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
#import "TYMyCollectionViewController.h"

@interface TYUserTableViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayout;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *vipLogoImg;
@property (weak, nonatomic) IBOutlet UIButton *buyVIPBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgLayout;
@property (weak, nonatomic) IBOutlet UILabel *myJiFen_lab;

@property (nonatomic, copy) NSDictionary * dataDic;

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
/*
 {
 avatar: "1.png",               //用户头像
 gestureBtn: 2,                 //手势密码是否开启（1开启 2关闭）
 id: 1,                         //主键id
 level: 1,                      //用户等级（1普通用户 2会员）
 levelAgent: 3,                 //代理级别（1一级代理 2二级代理 3普通代理）
 name: "",                      //用户昵称
 playTimes: 3,                  //'播放次数',
 score: 0,                      // 积分
 spreadNum: 0,                  //推广数量
 viewTimes: 0                   //观看次数
 }
 */
- (void)getUserRequestData {
    NSDictionary * dic = @{
                           @"imei":[TYGlobal getDeviceIdentifier]
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/login" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            weakSelf.dataDic = [NSDictionary dictionaryWithDictionary:data];
            [weakSelf initWithData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)initWithData {
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL_main,self.dataDic[@"avatar"]]] placeholderImage:PLACEHOLEDERIMAGE];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 3:
        {
            
        }
            break;
        case 4:
        {
            TYMyCollectionViewController *vc = [[TYMyCollectionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            TYMyTuiGunagViewController *vc = [[TYMyTuiGunagViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end

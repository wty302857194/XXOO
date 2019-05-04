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
#import "TYDuiHuanViewController.h"
#import "TYHistoryListViewController.h"

@interface TYUserTableViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayout;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *vipLogoImg;
@property (weak, nonatomic) IBOutlet UIButton *buyVIPBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgLayout;
@property (weak, nonatomic) IBOutlet UILabel *myJiFen_lab;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (nonatomic, copy) NSDictionary * dataDic;

@property (nonatomic, copy) NSDictionary * adDic;
@end

@implementation TYUserTableViewController
- (IBAction)settingClick:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mine" bundle:nil];
    TYSettingTableVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"TYSettingTableVC"];
    [self.navigationController pushVC:vc animated:YES];

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
            TYBaseTabBarViewController *tabbar = [[TYBaseTabBarViewController alloc] init];
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            keyWindow.rootViewController = tabbar;
            tabbar.selectedIndex = 3;
        }
            break;
        case 102:
        {
            TYDuiHuanViewController *vc = [[TYDuiHuanViewController alloc] init];
            TYWEAK_SELF;
            vc.refreshBlock = ^{
                [weakSelf getUserRequestData];
            };
            [self.navigationController pushViewController:vc animated:YES];
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
    [self getCenterAdRequestData];
    [self getUserRequestData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
#pragma mark -  广告
// /sysAd/api/getCenterAd
- (void)getCenterAdRequestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/sysAd/api/getCenterAd" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            self.adDic = [NSDictionary dictionaryWithDictionary:data];
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:data[@"picUrl"]] placeholderImage:PLACEHOLEDERIMAGE];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
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
                           @"imei":[TYGlobal getDeviceIdentifier],
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/login" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSDictionary *dic = [NSDictionary nullDic:data];
            [USER_DEFAULTS setObject:dic forKey:USERMESSAGE];
            [USER_DEFAULTS synchronize];
            
            if ([TYGlobal userMessage]) {
                self.dataDic = [NSDictionary nullDic:[TYGlobal userMessage]];
                [self initWithData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)initWithData {
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL_main,self.dataDic[@"avatar"]]] placeholderImage:PLACEHOLEDERIMAGE];
    self.userNameLab.text = [NSString stringWithFormat:@"代理用户（%@）",self.dataDic[@"name"]];
    self.myJiFen_lab.text = [NSString stringWithFormat:@"%@",self.dataDic[@"score"]];
    NSString *level = [NSString stringWithFormat:@"%@",self.dataDic[@"level"]];
    if ([level isEqualToString:@"1"]) {
        self.buyVIPBtn.hidden = NO;
    }else {
        self.buyVIPBtn.hidden = YES;
    }
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 2:
        {
            [TYGlobal openScheme:self.adDic[@"linkUrl"]];
        }
            break;
        case 3:
        {
            
            TYHistoryListViewController *vc = [[TYHistoryListViewController alloc] init];
            [self.navigationController pushVC:vc animated:YES];
        }
            break;
        case 4:
        {
            TYMyCollectionViewController *vc = [[TYMyCollectionViewController alloc] init];
            [self.navigationController pushVC:vc animated:YES];
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

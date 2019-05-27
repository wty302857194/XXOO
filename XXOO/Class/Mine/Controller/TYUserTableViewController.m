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
#import "TYPromotionVIPViewController.h"
#import "TYSaveCodeViewController.h"
#import "TYShengJiVIPViewController.h"
#import "TYUserHeaderView.h"

@interface TYUserTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *myJiFen_lab;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (nonatomic, copy) NSDictionary * dataDic;
@property (nonatomic, copy) NSDictionary * adDic;

@property (nonatomic, strong) TYUserHeaderView * userHeaderView;
@end

@implementation TYUserTableViewController

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
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103:
        {
            TYSaveCodeViewController *vc = [[TYSaveCodeViewController alloc] init];
            vc.ID = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fenLiTaleViewAndView];
    [self getCenterAdRequestData];

    NSDictionary *dic = [USER_DEFAULTS objectForKey:USERMESSAGE];
    NSString *str = [NSString stringWithFormat:@"%@",dic[@"level"]];
    if ([str isEqualToString:@"1"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"shengjiVIPImage"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goVIP)];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.right.offset(0);
            make.width.height.offset(100);
        }];
    }
    

}
- (void)fenLiTaleViewAndView {
    UITableView *tableView = (UITableView *)self.view;
    self.view = [[UIView alloc] init] ;
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
}
- (void)setTableView:(UITableView *)tableView {
    [self.tableView removeFromSuperview];
    [self.view addSubview:tableView];
}
- (UITableView *) tableView {
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITableView class]]) {
            return (UITableView *)v;
        }
    }
    return nil;
}
- (void)goVIP {
    TYShengJiVIPViewController *vc = [[TYShengJiVIPViewController alloc] init];
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self getUserRequestData];

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
        if (success) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                self.adDic = [NSDictionary dictionaryWithDictionary:data];
                [self.adImageView sd_setImageWithURL:[NSURL URLWithString:data[@"picUrl"]] placeholderImage:PLACEHOLEDERIMAGE];
            }
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
    NSDictionary *userMessage = [USER_DEFAULTS objectForKey:YAOQING_MESSAGE];

    NSDictionary * dic = @{
                           @"imei":[TYGlobal getDeviceIdentifier],
                           @"id":userMessage[@"id"]?:@"",
                           @"code":userMessage[@"code"]?:@""
                           };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/login" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSDictionary *dic = [NSDictionary nullDic:data];
            [USER_DEFAULTS setObject:dic forKey:USERMESSAGE];
            [USER_DEFAULTS synchronize];
            
            if ([TYGlobal userMessage]) {
                self.dataDic = [TYGlobal userMessage];
                self.userHeaderView.dataDic = self.dataDic;
                self.myJiFen_lab.text = [NSString stringWithFormat:@"%@",self.dataDic[@"score"]];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 91;
            break;
        case 1:
        {
            if (self.adDic) {
                return 91;
            }else {
                return 0;
            }
        }
            break;
        
        default:
            return 47;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 1:
        {
            NSString *str = self.adDic[@"linkUrl"];
            if(str&&str.length>0) {
                [TYGlobal openScheme:self.adDic[@"linkUrl"]];
            }
        }
            break;
        case 2:
        {
            
            TYHistoryListViewController *vc = [[TYHistoryListViewController alloc] init];
            [self.navigationController pushVC:vc animated:YES];
        }
            break;
        case 3:
        {
            TYMyCollectionViewController *vc = [[TYMyCollectionViewController alloc] init];
            [self.navigationController pushVC:vc animated:YES];
        }
            break;
        case 4:
        {
            [TYGlobal openScheme:self.dataDic[@"joinUrl"]];
        }
            break;
        case 5:
        {
            TYMyTuiGunagViewController *vc = [[TYMyTuiGunagViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        float totalOffset = 176 + fabsf(offsetY);

        float f = totalOffset / 176.f;
        self.userHeaderView.backImgView.frame = CGRectMake(-KSCREEN_WIDTH * (f - 1) * 0.5, offsetY, KSCREEN_WIDTH * f, totalOffset);
        [self.userHeaderView.backImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(offsetY);
        }];
    }
}
- (TYUserHeaderView *)userHeaderView {
    if (!_userHeaderView) {
        _userHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TYUserHeaderView" owner:nil options:nil] lastObject];
        _userHeaderView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, 176);
        self.tableView.tableHeaderView = _userHeaderView;

        TYWEAK_SELF;
        _userHeaderView.userSettingBlock = ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mine" bundle:nil];
            TYSettingTableVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"TYSettingTableVC"];
            [weakSelf.navigationController pushVC:vc animated:YES];
        };
        _userHeaderView.buyVIPBlock = ^{
            TYShengJiVIPViewController *vc = [[TYShengJiVIPViewController alloc] init];
            TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        };
    }
    return _userHeaderView;
}
@end

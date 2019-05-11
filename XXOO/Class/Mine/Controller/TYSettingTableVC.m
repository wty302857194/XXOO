//
//  TYSettingTableVC.m
//  XXOO
//
//  Created by wbb on 2019/4/15.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSettingTableVC.h"
#import "TYEmailTableViewController.h"
#import "TYGesturePasswordViewController.h"
#import "TYChangePasswordViewController.h"

@interface TYSettingTableVC ()
@property (weak, nonatomic) IBOutlet UILabel *zhangHaoLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UILabel *statePasswordLab;
@property (nonatomic, copy) NSDictionary * dataDic;
@end
@implementation TYSettingTableVC
- (IBAction)isOpenSwitch:(UISwitch *)sender {
    sender.on = !sender.on;
    BOOL isOpen = sender.on;
    [USER_DEFAULTS setBool:isOpen forKey:GESTURE_OPIN];
    [USER_DEFAULTS synchronize];
    
    [self gestureBtnRequestData:isOpen?@"1":@"2"];
}
// /user/api/gestureBtn
- (void)gestureBtnRequestData:(NSString *)type {
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"gestureBtn":type
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:msg inView:self.view];
        
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.zhangHaoLab.text = @"";
    self.emailLab.text = @"";
    
    self.mySwitch.on = [USER_DEFAULTS boolForKey:GESTURE_OPIN];
    
    if ([[TYGlobal userEmail] length]>0) {
        NSString *str = [TYGlobal userEmail];
        self.emailLab.text = str;
        self.emailCell.accessoryType = UITableViewCellAccessoryNone;
        self.emailCell.userInteractionEnabled = NO;
    }
    
    if ([TYGlobal userMessage]) {
        self.dataDic = [NSDictionary nullDic:[TYGlobal userMessage]];
        self.zhangHaoLab.text = self.dataDic[@"name"];
    }
    
    if ([TYGlobal gesturePassword].length>0) {
        self.statePasswordLab.text = @"清除手势密码";
    }else {
        self.statePasswordLab.text = @"设置个人锁（下次启动时生效）";
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:main_text_color}];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return ([[TYGlobal userEmail] length]>0)?50:0;
    }
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mine" bundle:nil];
            TYEmailTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TYEmailTableViewController"];
            TYWEAK_SELF;
            vc.emailBlock = ^(NSString *email) {
                weakSelf.emailLab.text = email;
                weakSelf.emailCell.accessoryType = UITableViewCellAccessoryNone;
                weakSelf.emailCell.userInteractionEnabled = NO;
            };
            [self.navigationController pushVC:vc animated:YES];
        }
            break;
        case 2:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mine" bundle:nil];
            TYChangePasswordViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TYChangePasswordViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3://手势密码
        {
            if ([TYGlobal gesturePassword].length>0) {
                self.statePasswordLab.text = @"设置个人锁（下次启动时生效）";
                [USER_DEFAULTS setObject:@"" forKey:GESTURE_PASSWORD];
                [USER_DEFAULTS synchronize];
                [MBProgressHUD promptMessage:@"清除成功" inView:self.view];
            }else {
                if ([USER_DEFAULTS boolForKey:GESTURE_OPIN]) {
                    TYGesturePasswordViewController *vc = [[TYGesturePasswordViewController alloc] init];
                    vc.title = @"设置手势密码";
                    TYWEAK_SELF;
                    vc.passwordBlock = ^{
                        weakSelf.statePasswordLab.text = @"清除手势密码";
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    [MBProgressHUD promptMessage:@"请开启手势密码" inView:self.view];
                }
            }
        }
            break;
        default:
            break;
    }
}
@end

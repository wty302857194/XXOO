//
//  TYChangePasswordViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYChangePasswordViewController.h"

@interface TYChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *xinPwTF;
@property (weak, nonatomic) IBOutlet UITextField *youNewTF;

@property (nonatomic, copy) NSString * oldPasswordStr;
@property (nonatomic, copy) NSString * xinPasswordStr;
@property (nonatomic, copy) NSString * youPasswordStr;

@end

@implementation TYChangePasswordViewController
- (IBAction)passwordTF:(UITextField *)sender {
    if (sender == _oldPasswordTF) {
        _oldPasswordStr = sender.text;
    }else if (sender == _xinPwTF) {
        _xinPasswordStr = sender.text;
    }else if (sender == _youNewTF) {
        _youPasswordStr = sender.text;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码变更";
    self.view.backgroundColor = hexColor(f5f5f5);
    _oldPasswordStr = @"";
    _xinPasswordStr = @"";
    _youPasswordStr = @"";
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 导航栏不透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (IBAction)sureChange:(UIButton *)sender {
    if (_oldPasswordStr.length==0) {
        [MBProgressHUD promptMessage:@"请输入旧密码" inView:self.view];
        return;
    }
    if (_xinPasswordStr.length==0) {
        [MBProgressHUD promptMessage:@"请输入新密码" inView:self.view];
        return;
    }
    
    if (_youPasswordStr.length==10) {
        [MBProgressHUD promptMessage:@"请重新输入新密码" inView:self.view];
        return;
    }
    if (![_xinPasswordStr isEqualToString:_youPasswordStr]) {
        [MBProgressHUD promptMessage:@"两次输入密码不一致" inView:self.view];
        return;
    }
    [self updatePwdRequestData];
}
//  /user/api/updatePwd   修改密码
- (void)updatePwdRequestData {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"newPwd":_xinPasswordStr,
                           @"oldPwd":_oldPasswordStr
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/updatePwd" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success&&data) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    }];
}
@end

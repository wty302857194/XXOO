//
//  TYEmailTableViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYEmailTableViewController.h"

@interface TYEmailTableViewController () {
    NSString *_emailStr,*_firstPasswordStr,*_secondPasswordStr;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *firstPassword;
@property (weak, nonatomic) IBOutlet UITextField *secondPassword;

@end

@implementation TYEmailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电子邮箱绑定";
    self.view.backgroundColor = hexColor(f0eff5);
    self.tableView.tableFooterView = [UIView new];

    _emailStr = @"";
    _firstPasswordStr = @"";
    _secondPasswordStr = @"";
}

- (IBAction)textChange:(UITextField *)sender {
    NSLog(@"现在的%@",sender.text);
    if (sender == _emailTF) {
        _emailStr = sender.text;
    }else if(sender == _firstPassword){
        _firstPasswordStr = sender.text;
    }else if(sender == _secondPassword){
        _secondPasswordStr = sender.text;
    }
}
- (IBAction)tieClick:(UIButton *)sender {
    [self bindEmailRequestData];
}

// /user/api/bindEmail

- (void)bindEmailRequestData {
    if (_emailStr.length==0) {
        [MBProgressHUD promptMessage:@"请输入您的邮箱" inView:self.view];
        return;
    }
    if (![TYGlobal isValidateEmail:_emailStr]) {
        [MBProgressHUD promptMessage:@"邮箱格式不对" inView:self.view];
        return;
    }
    if (_firstPasswordStr.length==0) {
        [MBProgressHUD promptMessage:@"请输入您的密码" inView:self.view];
        return;
    }
    if (_firstPasswordStr.length<6) {
        [MBProgressHUD promptMessage:@"最少6位密码" inView:self.view];
        return;
    }

    if (_secondPasswordStr.length==0) {
        [MBProgressHUD promptMessage:@"请再次输入您的密码" inView:self.view];
        return;
    }
    if(![_firstPasswordStr isEqualToString:_secondPasswordStr]) {
        [MBProgressHUD promptMessage:@"两次密码输入不一致" inView:self.view];
        return;
    }
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"email":_emailStr,
                           @"password":_firstPasswordStr
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/bindEmail" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success&&data) {
            [USER_DEFAULTS setObject:self->_emailStr forKey:USER_EMAIL];
            [USER_DEFAULTS synchronize];
            
            if (weakSelf.emailBlock) {
                weakSelf.emailBlock(self->_emailStr);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD promptMessage:msg inView:weakSelf.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    }];
}




@end

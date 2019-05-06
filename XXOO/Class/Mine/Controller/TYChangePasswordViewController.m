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
- (IBAction)sureChange:(UIButton *)sender {
    if (_oldPasswordStr.length>0) {
        [MBProgressHUD promptMessage:@"请输入旧密码" inView:self.view];
        return;
    }
    if (_xinPasswordStr.length>0) {
        [MBProgressHUD promptMessage:@"请输入新密码" inView:self.view];
        return;
    }
    
    if (_youPasswordStr.length>0) {
        [MBProgressHUD promptMessage:@"请重新输入新密码" inView:self.view];
        return;
    }
    if (![_xinPasswordStr isEqualToString:_oldPasswordStr]) {
        [MBProgressHUD promptMessage:@"两次输入密码不一致" inView:self.view];
        return;
    }
    
}


@end

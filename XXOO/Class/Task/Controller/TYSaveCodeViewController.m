//
//  TYSaveCodeViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/27.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSaveCodeViewController.h"

@interface TYSaveCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *codeBackView;
@property (weak, nonatomic) IBOutlet UILabel *myInvitationLab;

@end

@implementation TYSaveCodeViewController
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveCode:(UIButton *)sender {
    if(sender.tag == 10) {
        [self saveCodeRequestData];
    }else {
        
    }
}
- (void)saveCodeRequestData {
    NSDictionary * dic = @{
                           @"id":USERID,
                           @"tid":@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/saveQr" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:msg inView:self.view];
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
@end

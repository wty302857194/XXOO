//
//  TYGesturePasswordViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGesturePasswordViewController.h"
#import "ZSBntview.h"
#import "AppDelegate.h"

@interface TYGesturePasswordViewController ()<ZSBntviewDelegate> {
    NSString *_firstPassword,*_secondPassword;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet ZSBntview *bntview;
@end

@implementation TYGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"设置手势密码";
    self.edgesForExtendedLayout =  UIRectEdgeAll;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gesture_backImage"]];
    self.bntview.delegate = self;
    
    _firstPassword = @"";
    _secondPassword = @"";
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TYBaseNavigationController *rootViewController1 = (TYBaseNavigationController *)appdelegate.window.rootViewController;
    if ([rootViewController1.viewControllers[0] isEqual:self]) {
        
    }else {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(settingPassward)];
        self.navigationItem.rightBarButtonItem = item;
    }
}
- (void)settingPassward {
    _firstPassword = @"";
    _secondPassword = @"";
    self.imageview.image = nil;
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    // 导航栏透明
//    [self.navigationController.navigationBar setTranslucent:true];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //处理导航栏有条线的问题
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//}
//
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 导航栏不透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}
//实现代理方法
-(void)zsbntview:(ZSBntview *)bntview :(NSString *)strM{
    //开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(bntview.frame.size, NO, 0.0);
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //截图
    [self.bntview.layer renderInContext:ctx];
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //把获取的图片保存到 imageview 中
    self.imageview.image = image;
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TYBaseNavigationController *rootViewController1 = (TYBaseNavigationController *)appdelegate.window.rootViewController;
    
    if ([rootViewController1.viewControllers[0] isEqual:self]) {
        
        //本地验证（看需求怎么说，可以改为接口验证）
        if ([strM isEqualToString:[TYGlobal gesturePassword]]) {
            [appdelegate rootVC];
            
        }else {
            [MBProgressHUD promptMessage:@"密码输入错误" inView:self.view];
        }
        return;
    }
    
    if (_firstPassword.length > 0) {
        _secondPassword = strM;
        if ([_secondPassword isEqualToString:_firstPassword]) {
            //跳出，并存储密码
            // 接口存储
            [self gesturePwdRequestData:_secondPassword];
            
            //本地存储
            [USER_DEFAULTS setObject:_secondPassword forKey:GESTURE_PASSWORD];
            [USER_DEFAULTS synchronize];
            if (self.passwordBlock) {
                self.passwordBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD promptMessage:@"两次密码不一致" inView:self.view];
            return;
        }
    }else {
        _firstPassword = strM;
        [MBProgressHUD promptMessage:@"请再次输入密码" inView:self.view];
    }
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)gesturePwdRequestData:(NSString *)gesturePwd {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"gesturePwd":gesturePwd?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/gesturePwd" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:msg inView:self.view];

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)gestureLoginRequestData:(NSString *)gesturePwd {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"gesturePwd":gesturePwd?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/gestureLogin" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

@end

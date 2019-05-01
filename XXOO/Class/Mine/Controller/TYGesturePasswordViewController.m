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

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    self.bntview.delegate = self;
    
    _firstPassword = @"";
    _secondPassword = @"";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

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
        if ([strM isEqualToString:[TYGlobal gesturePassword]]) {
            [appdelegate rootVC];
            return;
        }
    }else {
        [MBProgressHUD promptMessage:@"密码输入错误" inView:self.view];
    }
    
    
//    if ([TYGlobal gesturePassword].length>0) {
//        
//    }
    if (_firstPassword.length > 0) {
        _secondPassword = strM;
        if ([_secondPassword isEqualToString:_firstPassword]) {
            //跳出，并存储密码
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


@end

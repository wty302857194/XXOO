//
//  AppDelegate.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "AppDelegate.h"
#import "TYBaseTabBarViewController.h"
#import "OpenInstallSDK.h"
#import "TYGesturePasswordViewController.h"
#import "XHLaunchAd.h"

@interface AppDelegate ()<OpenInstallDelegate>
@property (nonatomic, strong) NSMutableDictionary * adDic;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [OpenInstallSDK initWithDelegate:self];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT)];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self getInstallParms];
    
    [self adView];

    return YES;
}
- (void)rootVC {
    self.window.rootViewController = [[TYBaseTabBarViewController alloc] init];
}
- (void)rootPasswordVC {
    TYGesturePasswordViewController *passwordvVC = [[TYGesturePasswordViewController alloc] init];
    passwordvVC.title = @"验证手势密码";
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:passwordvVC];
    self.window.rootViewController = nav;
}
- (void)adView {
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    
    
    //  /sysAd/api/getStartAd   广告业接口
    /*
     {
     createTime: "2019-04-20 16:36:27",     //创建时间
     id: 1,                                 //主键id
     linkUrl: "1",                          //链接地址
     picUrl: "1",                           //图片地址
     position: 1,                           //放置位置（1启动页 2视频 3个人中心 4娱乐）
     showTime: "5",                         //启动页展示时长（s）
     }
     */
    [TYNetWorkTool postRequest:@"/sysAd/api/getStartAd" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success&&data) {
            self.adDic = [NSMutableDictionary dictionaryWithDictionary:data];
            //配置广告数据
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
            //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
            imageAdconfiguration.imageNameOrURLString = self.adDic[@"picUrl"]?:@"";
            //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
            imageAdconfiguration.openModel = self.adDic[@"linkUrl"]?:@"";
            imageAdconfiguration.duration = [self.adDic[@"showTime"]?:@"" integerValue];
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
            
        }
    } failureBlock:^(NSString * _Nonnull description) {
        
    }];
}


/**
 广告点击事件代理方法
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
    NSLog(@"广告点击事件");
    
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    
    if(openModel==nil) return;
    
    NSString *urlString = (NSString *)openModel;
    
    [TYGlobal openScheme:urlString];
    
}


- (void)getInstallParms {
    TYWEAK_SELF;
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        //在主线程中回调
        if (appData.data) {//(动态安装参数)
            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
            [USER_DEFAULTS setObject:appData.data forKey:YAOQING_MESSAGE];
            [USER_DEFAULTS synchronize];
            
            [weakSelf getUserRequestData];
        }else {
            [weakSelf getUserRequestData];
        }
        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
            //e.g.可自己统计渠道相关数据等
        }
        
        //弹出提示框(便于调试，调试完成后删除此代码)
        NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n1、新应用是否上传安装包(是否集成完毕)  2、是否正确配置appKey  3、是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"安装参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
    //做一个延时处理
    
    //    [[OpenInstallSDK defaultManager] getInstallParmsWithTimeoutInterval:1 completed:^(OpeninstallData * _Nullable appData) {
    //        //在主线程中回调
    //        if (appData.data) {//(动态安装参数)
    //            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    //            [USER_DEFAULTS setObject:appData.data forKey:YAOQING_MESSAGE];
    //            [USER_DEFAULTS synchronize];
    //
    //            [weakSelf getUserRequestData];
    //        }
    //        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
    //            //e.g.可自己统计渠道相关数据等
    //        }
    //
    //        //弹出提示框(便于调试，调试完成后删除此代码)
    //        NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n1、新应用是否上传安装包(是否集成完毕)  2、是否正确配置appKey  3、是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"安装参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }];
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler NS_AVAILABLE_IOS(8_0) {
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]){//如果使用了Universal link ，此方法必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}
//iOS9以上，会优先走这个方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options{
    //判断是否通过OpenInstall URL Scheme 唤起App
    if  ([OpenInstallSDK handLinkURL:url]){//必写
        return YES;
    }
    //其他第三方回调；
    return YES;
    
}
//通过OpenInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
-(void)getWakeUpParams:(OpeninstallData *)appData {
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(通过渠道链接或二维码唤醒会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
    //弹出提示框(便于调试，调试完成后删除此代码)
    //    NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
    //    NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n是否通过含有动态参数的分享链接(或二维码)唤醒的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"唤醒参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    [TYNetWorkTool postRequest:@"/user/api/login" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success&&data) {
            NSDictionary *dic = [NSDictionary nullDic:data];
            [USER_DEFAULTS setObject:dic forKey:USERMESSAGE];
            [USER_DEFAULTS synchronize];
            
            if ([TYGlobal gesturePassword].length>0&&[TYGlobal gestureIsOpen]) {
                [self rootPasswordVC];
            }else {
                [self rootVC];
            }
            
            [self.window makeKeyAndVisible];
        }else {
            [MBProgressHUD promptMessage:msg inView:kWindow];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        
    }];
}
@end

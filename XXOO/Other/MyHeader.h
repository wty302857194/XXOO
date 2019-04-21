//
//  MyHeader.h
//  MyViewController
//
//  Created by 杨飞 on 16/7/18.
//  Copyright © 2016年 cjh. All rights reserved.
//

#ifndef MyHeader_h
#define MyHeader_h



// 判断设备类型
#define iPhone4_Vertical ([UIScreen mainScreen].bounds.size.height==480.0f)
#define iPhoneX   (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))

#define kSafeAreaMaiginTop         (iPhoneX?44:0)
#define kSafeAreaMaiginBottom      (iPhoneX?34:0)
#define kStatusBarHeight           (iPhoneX?44:20)    // 状态栏高度
#define kNavigationBarHeight       44     // NavBar高度
#define kTabBarHeight              (iPhoneX?83:49)

// 状态栏＋导航栏高度(兼容iPhoneX)
#define kLayoutViewMarginTop  ((kStatusBarHeight) + (kNavigationBarHeight))
#define kTableBarHeight            (iPhoneX?83:49)  // 底部tablebar的高度



// 颜色 统一用16进制
#define hexColor(colorV)        [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a];

#define main_text_color         hexColor(333333)
#define main_light_text_color   hexColor(676767)
#define line_color              hexColor(f4f5f6)
#define main_select_text_color  hexColor(8a4edc)

// 一些系统单例的简写
#define USER_DEFAULTS       [NSUserDefaults standardUserDefaults]

//获取通知中心
#define TYNotificationCenter [NSNotificationCenter defaultCenter]

//3.设置随机颜色

#define TYRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//4.设置RGB颜色/设置RGBA颜色

#define TYRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TYRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
// clear背景颜色
#define TYClearColor [UIColor clearColor]

//7.设置 view 圆角和边框

#define TYViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//8.由角度转换弧度 由弧度转换角度
#define TYDegreesToRadian(x) (M_PI * (x) / 180.0)
#define TYRadianToDegrees(radian) (radian*180.0)/(M_PI)

// 加载
#define kShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

#define kWindow [UIApplication sharedApplication].keyWindow

//11.获取view的frame/图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//12.获取当前语言
#define TYCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


//16.沙盒目录文件

//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);



#endif /* MyHeader_h */

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define KSCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define KSCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define KSCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KSCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

#ifdef DEBUG
#define TYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define TYLog(...)
#endif

#define TYWeakSelf(type)  __weak typeof(type) weak##type = type;



#define HistoryDataSource @"historyDataSource"

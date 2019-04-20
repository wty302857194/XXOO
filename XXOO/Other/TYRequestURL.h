//
//  TYRequestURL.h
//  XXOO
//
//  Created by wbb on 2019/4/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#ifndef TYRequestURL_h
#define TYRequestURL_h

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    0
#define TestSever       0
#define ProductSever    1

#if DevelopSever

/**开发服务器*/
#define URL_main       @"http://192.168.1.36:8080/"
/** H5 */
#define WEBURL_main    @""
/** 图片 */
#define IMAGE_URL_main @""
/** 视频 */
#define VIDEO_URL_main @""


#elif TestSever

/**测试服务器**/

#define URL_main       @"http://192.168.1.199:8080/monitor/"
#define WEBURL_main    @""

#elif ProductSever

/**生产服务器*/

#define URL_main       @"http://47.95.207.185:8080/"

/** H5 */
#define WEBURL_main    @""
/** 图片 */
#define IMAGE_URL_main @""
/** 视频 */
#define VIDEO_URL_main @""

#endif

#endif /* TYRequestURL_h */

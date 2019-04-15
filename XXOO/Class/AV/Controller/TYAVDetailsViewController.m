//
//  TYAVDetailsViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVDetailsViewController.h"
#import "SJVideoPlayer.h"
#import <SJUIKit/SJAttributeWorker.h>
#import "SJCommonProgressSlider.h"

static SJEdgeControlButtonItemTag SJEdgeControlButtonItemTag_Share = 10;        // 分享

@interface TYAVDetailsViewController ()<SJEdgeControlButtonItemDelegate>
@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation TYAVDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // create a player of the default type
    _player = [SJVideoPlayer player];
    
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        else make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_player.view.mas_width).multipliedBy(9 / 16.0f);
    }];
    
    _player.pausedToKeepAppearState = YES;
    NSString *STR = @"https://dco4urblvsasc.cloudfront.net/811/81095_ywfZjAuP/game/1000kbps.m3u8";//@"https://xy2.v.netease.com/2018/0815/d08adab31cc9e6ce36111afc8a92c937qt.mp4"
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:STR]];
    _player.URLAsset.title = @"十五年前, 一见钟情";
    
    _player.placeholderImageView.image = [UIImage imageNamed:@"av_tabbar_normal"];
//    NSTimeInterval secs = 20.0;
//    _player.URLAsset.specifyStartTime = secs;
    
//    [_player showTitle:@"当前Demo为: 更多 item 的创建示例" duration:-1];
    TYWeakSelf(self);
    [weakself.player setPlayTimeDidChangeExeBlok:^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        NSTimeInterval time = videoPlayer.currentTime;
        NSLog(@"%f",time);
        if (time>10) {
            [weakself.player pause];
            [weakself.player showTitle:@"当前Demo为: 更多 item 的创建示例" duration:-1];
        }
    }];
    
     SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
         commonSettings.more_trackColor = [UIColor whiteColor];
         commonSettings.progress_trackColor = [UIColor colorWithWhite:0.4 alpha:1];
         commonSettings.progress_bufferColor = [UIColor whiteColor];
         commonSettings.progress_thumbSize = 10;
     });
    
    // 1. 49 * 49 大小的图片item
    SJEdgeControlButtonItem *imageItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] target:self action:@selector(test:) tag:SJEdgeControlButtonItemTag_Share];
    /// 是否隐藏
    /// 有些时候, 我们需要某个按钮, 在小屏时隐藏, 大屏后显示.
    /// 可以通过下面这个属性, 来控制item是否隐藏
    /// 注意: 将逻辑放到item的代理方法中`updatePropertiesIfNeeded:videoPlayer:`
    imageItem.delegate = self;
    //    imageItem.hidden = YES;
    [_player.defaultEdgeControlLayer.topAdapter addItem:imageItem];
    
    
    // 2. 49 * title.size.width
    SJEdgeControlButtonItem *titleItem = [[SJEdgeControlButtonItem alloc] initWithTitle:sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
        make.append(@"Share").font([UIFont systemFontOfSize:14]).textColor([UIColor whiteColor]).alignment(NSTextAlignmentCenter);
    }) target:self action:@selector(test:) tag:SJEdgeControlButtonItemTag_Share];
    
    // 调整 item 前后间隔
    titleItem.insets = SJEdgeInsetsMake(8, 8);
    [_player.defaultEdgeControlLayer.topAdapter addItem:titleItem];
    
    
    
    [_player.defaultEdgeControlLayer.topAdapter reload];
    
    
    
}

- (void)test:(SJEdgeControlButtonItem *)item {
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end

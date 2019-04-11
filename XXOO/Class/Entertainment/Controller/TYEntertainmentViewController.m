//
//  TYEntertainmentViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYEntertainmentViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#define url_str @"https://xy2.v.netease.com/2018/0815/d08adab31cc9e6ce36111afc8a92c937qt.mp4"
@interface TYEntertainmentViewController ()
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) AVPlayer * myPlayer;
@property (nonatomic, strong) AVPlayerItem * item;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@end

@implementation TYEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
}

-(void)avPlayerMethod{
    //构建播放网址
    NSURL *mediaURL = [NSURL URLWithString:url_str];
    //构建播放单元
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    //构建播放器对象
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    //构建播放器的layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = CGRectMake(0, 66, self.view.bounds.size.width, 300);
    [self.view.layer addSublayer:self.playerLayer];
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
//    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
/****************avplayer********************/
#pragma mark - Private Methods
- (void)setUI
{
    
    //初始化视频播放地址
    NSURL *mediaUrl = [NSURL URLWithString:url_str];
    
    // 初始化播放单元
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:mediaUrl];
    
    //初始化播放器对象
    self.myPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
    
    
    //显示画面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    //视频填充模式
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    //设置画布frame
    layer.frame = CGRectMake(0, KSCREENH_HEIGHT/2-250/2, KSCREEN_WIDTH, 250);
    
    
    //添加到当前视图
    [self.view.layer addSublayer:layer];
    
    [self.myPlayer play];
    
    //设置播放暂停按钮
    NSArray *titles = @[@"播放",@"暂停"];
    CGFloat gap = (KSCREEN_WIDTH-120)/3.0f;
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        btn.tag = 555+i;
        btn.frame = CGRectMake(gap+i*(gap+60), KSCREENH_HEIGHT-200, 60, 40);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [btn addTarget:self action:@selector(targetAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        
    }
    
    
}//绘制UI
#pragma mark - Action Methods
- (void)targetAction:(UIButton*)sender
{
    switch (sender.tag) {
            
        case 555:  //播放
            
            [self play];
            break;
            
        case 556:  //暂停
            
            [self pause];
            break;
            
        default:
            break;
    }
}


- (void)play
{
    
    if (self.myPlayer.rate == 0) {
        
        [self.myPlayer play];
    }
    
}// 播放


- (void)pause
{
    if (self.myPlayer.rate != 0)
    {
        [self.myPlayer pause];
    }
    
}//暂停
/************end**************/


/******AVPlayerViewController******/
- (void)setAVPlayerViewControllerUI {
    NSURL *remoteURL = [NSURL URLWithString:url_str];
    AVPlayer *player = [AVPlayer playerWithURL:remoteURL];
    _playerVC = [[AVPlayerViewController alloc] init];
    _playerVC.player = player;
    // 设置播放视图的frame
    self.playerVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 9 / 16);
    
    // 添加播放视图到要显示的视图
    [self.view addSubview:self.playerVC.view];
//    [self presentViewController:self.playerVC animated:YES completion:nil];
    [self.playerVC.player play];
}
@end

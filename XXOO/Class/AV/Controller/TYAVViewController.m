//
//  TYAVViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVViewController.h"
#import "VideoPlayer.h"
#import "PlayerConfiguration.h"

@interface TYAVViewController ()
@property (nonatomic, strong) VideoPlayer *playerView;
@property (nonatomic, strong) PlayerConfiguration *configuration;
@end

@implementation TYAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.playerView];
    
    self.configuration.imageUrl = @"https://www.baidu.com/s?wd=黑洞&sa=ire_dl_gh_logo&rsv_dl=igh_logo_pc";
    NSString *str = @"http://data.vod.itc.cn/?rb=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=fl......dynrybyS1E.mp4 ";//@"http://www.crowncake.cn:18080/wav/no.9.mp4"
    self.configuration.sourceUrl = [NSURL URLWithString:str] ;
//    self.configuration.title = @"标题";
    [self.playerView setPlayerConfiguration:self.configuration];
}
- (UIView *)playerView
{
    if (!_playerView) {
        _playerView = [[VideoPlayer alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 180)];
    }
    return _playerView;
}
- (PlayerConfiguration *)configuration
{
    if (!_configuration) {
        _configuration = [[PlayerConfiguration alloc]init];
        _configuration.shouldAutoPlay = NO;
        _configuration.supportedDoubleTap = YES;
        _configuration.shouldAutorotate = YES;
        _configuration.repeatPlay = NO;
        _configuration.videoGravity = VideoGravityResizeAspect;
    }
    return _configuration;
}

-(void)dealloc
{
    [self.playerView _pauseVideo];
    [self.playerView _deallocPlayer];
    [self.playerView removeFromSuperview];
}
@end

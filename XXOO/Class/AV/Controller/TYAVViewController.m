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
    NSString *str = @"http://183.146.19.12/sohu/v1/TmPdTmwGoEIGh2btfFdvg8EveAkb8OWOy2C7T8yv5m47fFoGRMNiNw.mp4?k=gIPvVp&p=XWldzHqu4ZkWXZxIWhoBoJ2svm1BqVPcNmsdytP&r=TmI20LscWOo3NMAcgSwgqK8lqps7g6eR5ey3T2x6DhdFqSKM089RPmN60SXSqTPGRDNOWhoioMycY&q=OpC7hW7IWhodRDbXWY6SotE7ZDNslG6OWJX4WOXOfYWS0F2OfDAsWD1ORYoURD64fOoUZD6SotocWhCsRTT&cip=61.132.53.203";//@"http://www.crowncake.cn:18080/wav/no.9.mp4"
    self.configuration.sourceUrl = [NSURL URLWithString:str] ;
    self.configuration.title = @"标题";
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

//
//  TYAVDetailsViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVDetailsViewController.h"
#import "TYAVDetailContentCollectionViewCell.h"
#import "TYAVDetailCollectionViewCell.h"

#import "SJVideoPlayer.h"
#import <SJUIKit/SJAttributeWorker.h>
#import "SJCommonProgressSlider.h"

static SJEdgeControlButtonItemTag SJEdgeControlButtonItemTag_Share = 10;        // 分享
#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f

@interface TYAVDetailsViewController ()<SJEdgeControlButtonItemDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) UICollectionView *collectionView;

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

    TYWeakSelf(self);
    [weakself.player setPlayTimeDidChangeExeBlok:^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        NSTimeInterval time = videoPlayer.currentTime;
        NSLog(@"%f",time);
        if (time>10) {
            [weakself.player stop];
            [weakself.player showTitle:@"当前Demo为: 更多 item 的创建示例" duration:-1];
            weakself.player.disabledGestures = SJPlayerGestureType_SingleTap | SJPlayerGestureType_DoubleTap | SJPlayerGestureType_Pan | SJPlayerGestureType_Pinch;
            
            
            UIView *view = [[UIView alloc] initWithFrame:weakself.player.view.bounds];
            view.backgroundColor = [UIColor redColor];
            [weakself.player.view addSubview:view];
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
    [_player.defaultEdgeControlLayer.topAdapter addItem:imageItem];
    
    
    // 2. 49 * title.size.width
    SJEdgeControlButtonItem *titleItem = [[SJEdgeControlButtonItem alloc] initWithTitle:sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
        make.append(@"Share").font([UIFont systemFontOfSize:14]).textColor([UIColor whiteColor]).alignment(NSTextAlignmentCenter);
    }) target:self action:@selector(test:) tag:SJEdgeControlButtonItemTag_Share];
    
    // 调整 item 前后间隔
    titleItem.insets = SJEdgeInsetsMake(8, 8);
    [_player.defaultEdgeControlLayer.topAdapter addItem:titleItem];

    [_player.defaultEdgeControlLayer.topAdapter reload];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailCollectionViewCell"];
    
}

- (void)test:(SJEdgeControlButtonItem *)item {
    
}



#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? 1 : 6;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TYAVDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    TYAVDetailContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGSizeMake(KSCREEN_WIDTH, 120);
    }
    return CGSizeMake(collectionWidth, collectionWidth*(160/211.f));
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return section == 0 ? UIEdgeInsetsZero : UIEdgeInsetsMake(5, 10, 5, 10);
    
} //每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 懒加载

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
        TYWeakSelf(self);
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.player.view.mas_bottom);
            make.leading.trailing.bottom.offset(0);
        }];
    }
    return _collectionView;
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

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
#import "TYAVDetailModel.h"
#import "SJVideoPlayer.h"
#import <SJUIKit/SJAttributeWorker.h>
#import "SJCommonProgressSlider.h"
#import "TYHomeModel.h"
#import "TYJianJieView.h"
#import "TYSearchDetailViewController.h"
#import "TYAVOverView.h"
#import "TYDuiHuanViewController.h"

static SJControlLayerIdentifier const myLayer = 588588588;

static SJEdgeControlButtonItemTag SJEdgeControlButtonItemTag_Share = 10;        // 分享
#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f

@interface TYAVDetailsViewController ()<SJEdgeControlButtonItemDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TYAVDetailModel * detailModel;
@property (nonatomic, strong) TYHomeModel * homeModel;

@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TYJianJieView * jianJieView;
@property (nonatomic, strong) TYAVOverView * overView;

@end

@implementation TYAVDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    
    _player = [SJVideoPlayer player];
    _player.pausedToKeepAppearState = YES;
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        else make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_player.view.mas_width).multipliedBy(9 / 16.0f);
    }];
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailCollectionViewCell"];
    
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithFooter:self.collectionView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getVideoListRequestData];
    }];
    
    [self avDetailRequestData];
}
- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getVideoListRequestData];
}
- (void)avDetailRequestData {
    NSDictionary *dic = @{
                          @"id":self.avID?:@"",
                          @"uid":[TYGlobal userId]
                          };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/video/api/getVideoById" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            self.detailModel = [TYAVDetailModel mj_objectWithKeyValues:data];
            [self initUI];
            [self getVideoListRequestData];
//            [self addHistoryRequestData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}
- (void)initUI {

    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.detailModel.vUrl]];
    _player.URLAsset.title = self.detailModel.title;
    [_player.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.cover]];    
    
    // 2. 49 * title.size.width
    if([self.detailModel.level isEqualToString:@"1"]) {//非会员
        SJEdgeControlButtonItem *titleItem = [[SJEdgeControlButtonItem alloc] initWithTitle:sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
            make.append([self.detailModel.free isEqualToString:@"2"]?@"限时免费中！开通无线看！>>": @"试看中！开通无线看！>>").font([UIFont systemFontOfSize:14]).textColor([UIColor whiteColor]).alignment(NSTextAlignmentCenter);
        }) target:self action:@selector(test) tag:SJEdgeControlButtonItemTag_Share];
        
        [_player.defaultEdgeControlLayer.topAdapter addItem:titleItem];
        
        
        if ([self.detailModel.free isEqualToString:@"1"]) {//  限免设置限免时间
            _player.totalTime = [self.detailModel.times floatValue]*60;
        }
    }

    TYWeakSelf(self);
    [weakself.player setPlayTimeDidChangeExeBlok:^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        
        if ([weakself.detailModel.free isEqualToString:@"1"]) {
            NSTimeInterval time = videoPlayer.currentTime;
            if (weakself.detailModel.limitTime == YES) {
                if (time>([weakself.detailModel.times floatValue]*60)) {
                    [weakself.player pause];
                    
                    [weakself.player.switcher addControlLayerForIdentifier:myLayer lazyLoading:^id<SJControlLayer> _Nonnull(SJControlLayerIdentifier identifier) {
                        return weakself.overView;
                    }];
                    [weakself.player.switcher switchControlLayerForIdentitfier:myLayer];
                }
            }
        }
    }];
    
    // 视频加载出来后 把视频时长传给k后台
    [self updateVideoTimeRequestData];
}
- (void)test {
    [self.player.rotationManager rotate:SJOrientation_Portrait animated:YES completionHandler:^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
        
        TYDuiHuanViewController *vc = [[TYDuiHuanViewController alloc] init];
        TYWEAK_SELF;
        vc.refreshBlock = ^{
            [weakSelf getVideoListRequestData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
}
//  /video/api/updateTime  视频-视频时长确定
- (void)updateVideoTimeRequestData {
    NSDictionary * dic = @{
                           @"id":self.avID?:@"",
                           @"times":_player.totalTimeStr?:@""
                           };
    [TYNetWorkTool postRequest:@"/video/api/updateTime" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
    } failureBlock:^(NSString * _Nonnull description) {
        
    }];
}
// /userHistory/api/addHistory  添加到播放记录
- (void)addHistoryRequestData {
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":self.avID?:@"",
                           @"viewTime":self.detailModel.timeLong?:@""
                           };
    [TYNetWorkTool postRequest:@"/userHistory/api/addHistory" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
    } failureBlock:^(NSString * _Nonnull description) {
        
    }];
}
//初始化接口
- (void)getVideoListRequestData {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"orderBy":@"",
                           @"vCode":@"",
                           @"vClass":@"",
                           @"vActor":@"",
                           @"vLabel":self.detailModel.vLabel?:@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getVideoList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self addHistoryRequestData];
        if (success&&data) {
            weakSelf.homeModel = [TYHomeModel mj_objectWithKeyValues:data];
            NSArray *arr = [NSArray arrayWithArray:weakSelf.homeModel.data];
            
            if (weakSelf.isFresh) {
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    [weakSelf.collectionView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else {
                [weakSelf.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    
                }else {
                    NSLog(@"加载空视图");
                }
                [weakSelf.collectionView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.dataArr.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TYAVDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailCollectionViewCell" forIndexPath:indexPath];
        cell.detailModel  = self.detailModel;
        cell.jianJieBlock = ^{
            NSLog(@"%@",self.detailModel.vLabel);
            NSArray *arr = [self.detailModel.vLabel componentsSeparatedByString:@","];
            
            
            CGFloat marginX = 10;  //按钮距离左边和右边的距离
            CGFloat marginY = 10;  //按钮距离布局顶部的距离
            CGFloat gap = 10;    //按钮与按钮之间的距离
            
            
            UIButton *selectBtn = nil;
            for (int i =0; i<arr.count; i++) {
                UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",arr[i]] titleColor:main_select_text_color font:[UIFont systemFontOfSize:14] target:self action:@selector(chooseStation:)];
                btn.tag = 10+i;
                btn.cornerRadius = 15;
                btn.layer.borderColor = main_select_text_color.CGColor;
                btn.layer.borderWidth = 1;
                [self.jianJieView.scrollView addSubview:btn];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (selectBtn) {
                        make.top.equalTo(selectBtn.mas_top);
                        make.left.equalTo(selectBtn.mas_right).offset(gap);
                        if (i == arr.count-1) {
                            make.bottom.offset(-marginX);
                        }
                    }
                    else {
                        make.top.offset(marginY);
                        make.left.offset(marginX);
                    }
                    
                    make.height.offset(30);
                }];
                
                [self.jianJieView.scrollView layoutIfNeeded];
                
                if ((btn.right+marginX)>KSCREEN_WIDTH) {
                    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(marginX);
                        make.top.equalTo(selectBtn.mas_bottom).offset(10);
                        make.height.offset(30);
                    }];
                }
                
                selectBtn = btn;
            }
            
            
            
            self.jianJieView.contentLab.text = self.detailModel.content;
            
            
        };
        return cell;
    }
    
    TYAVDetailContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell" forIndexPath:indexPath];
    TYHomeItemModel *model = self.dataArr[indexPath.row];
    cell.itemModel = model;
    __block TYAVDetailContentCollectionViewCell *blockCell = cell;
    TYWEAK_SELF;
    cell.itemShouCangBlock = ^() {
        if ([model.cstate isEqualToString:@"0"]) {
            [weakSelf shouCangRequestData:model ContentCell:blockCell];
        }else {
            [weakSelf cancelShouCangRequestData:model ContentCell:blockCell];
        }
    };
    return cell;
    
}
- (void)chooseStation:(UIButton *)btn {
     NSArray *arr = [self.detailModel.vLabel componentsSeparatedByString:@","];
    NSString *wordStr = arr[btn.tag -10];
    TYSearchDetailViewController *vc = [[TYSearchDetailViewController alloc] init];
    vc.vLabel = wordStr;
    [self.navigationController pushViewController:vc animated:YES];
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGSizeMake(KSCREEN_WIDTH, 80);
    }
    return CGSizeMake(collectionWidth, collectionWidth*(170/211.f));
    
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
    
    TYHomeItemModel *model = self.dataArr[indexPath.row];
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    vc.avID = model.ID;
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
-(TYJianJieView *)jianJieView {
    if (!_jianJieView) {
        _jianJieView = [[[NSBundle mainBundle] loadNibNamed:@"TYJianJieView" owner:nil options:nil] lastObject];
        TYWEAK_SELF;
        _jianJieView.cancelBtnBlock = ^{
            [weakSelf.jianJieView removeFromSuperview];
            weakSelf.jianJieView = nil;
        };
        [self.view addSubview:_jianJieView];
        TYWeakSelf(self);
        [_jianJieView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.player.view.mas_bottom);
            make.leading.trailing.bottom.offset(0);
        }];
    }
    return _jianJieView;
}
-(TYAVOverView *)overView {
    if (!_overView) {
        _overView = [[[NSBundle mainBundle] loadNibNamed:@"TYAVOverView" owner:nil options:nil] lastObject];
        _overView.frame = self.player.view.bounds;
        TYWEAK_SELF;
        _overView.overBlcok = ^(NSInteger index) {
            if (index == 10) {
                [weakSelf.player.rotationManager rotate:SJOrientation_Portrait animated:YES completionHandler:^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }else if (index == 20) {
                /// 删除控制层
                [weakSelf.player.switcher switchControlLayerForIdentitfier:SJControlLayer_Edge];
                [weakSelf.player.switcher deleteControlLayerForIdentifier:myLayer];
                
                [weakSelf.player replay];
            }else {
                [weakSelf.player.rotationManager rotate:SJOrientation_Portrait animated:YES completionHandler:^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
                    TYDuiHuanViewController *vc = [[TYDuiHuanViewController alloc] init];
                    vc.refreshBlock = ^{
                        [weakSelf getVideoListRequestData];
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
            }
        };
    }
    return _overView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

//收藏请求
- (void)shouCangRequestData:(TYHomeItemModel *)model ContentCell:(TYAVDetailContentCollectionViewCell *)cell {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":model.ID,
                           @"type":@"1"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/addCollection" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
//            [self headerRefreshRequest];
            [cell.saveBtn setImage:[UIImage imageNamed:@"shoucang_image"] forState:UIControlStateNormal];
            model.cstate = @"1";
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//收藏请求
- (void)cancelShouCangRequestData:(TYHomeItemModel *)model ContentCell:(TYAVDetailContentCollectionViewCell *)cell {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"tid":model.ID
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/delete" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
//            [self headerRefreshRequest];
            [cell.saveBtn setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
            model.cstate = @"0";
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
@end

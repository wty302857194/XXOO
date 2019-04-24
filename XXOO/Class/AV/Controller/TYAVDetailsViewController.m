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

@end

@implementation TYAVDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
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
- (void)avDetailRequestData {
    NSDictionary *dic = @{
                          @"id":self.avID?:@"",
                          @"uid":@"2"
                          };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/video/api/getVideoById" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            self.detailModel = [TYAVDetailModel mj_objectWithKeyValues:data];
            [self initUI];
            [self getVideoListRequestData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}
- (void)initUI {
    // create a player of the default type
    
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.detailModel.vUrl]];
    _player.URLAsset.title = self.detailModel.title;
    [_player.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.cover]];
    
    TYWeakSelf(self);
    [weakself.player setPlayTimeDidChangeExeBlok:^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        NSTimeInterval time = videoPlayer.currentTime;
        NSLog(@"%f",time);
        if (weakself.detailModel.limitTime == true) {
            if (time>[weakself.detailModel.times floatValue]) {
                [weakself.player pause];                weakself.player.disabledGestures = SJPlayerGestureType_SingleTap | SJPlayerGestureType_DoubleTap | SJPlayerGestureType_Pan | SJPlayerGestureType_Pinch;
                
                //                UIView *view = [[UIView alloc] initWithFrame:weakself.player.view.bounds];
                //                view.backgroundColor = [UIColor redColor];
                //                [weakself.player.view addSubview:view];
            }
        }
    }];
}
//初始化接口
- (void)getVideoListRequestData {
    NSDictionary * dic = @{
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
    return cell;
    
}
- (void)chooseStation:(UIButton *)btn {
    TYSearchDetailViewController *vc = [[TYSearchDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGSizeMake(KSCREEN_WIDTH, 80);
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

@end

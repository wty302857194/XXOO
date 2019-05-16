//
//  TYLongVideoViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYLongVideoViewController.h"
#import "TYAVDetailsViewController.h"
#import "TYAVDetailContentCollectionViewCell.h"
#import "TYVideoTypeListModel.h"
#import "TYHomeModel.h"
#import "TYCategroyListModel.h"

#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f

@interface TYLongVideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UIButton *_zuixinBtn,*_allVideoKindBtn,*_allVideoBtn; //选中的btn
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIView * topBackView;

@property (nonatomic, copy) NSArray * zuiDuoArr;//最新
@property (nonatomic, copy) NSArray * allVideoKindArr;//全部片种
@property (nonatomic, copy) NSArray * allVideoArr;//全部

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载

@property (nonatomic, strong) TYHomeModel * homeModel;

@property (nonatomic, copy) NSString * vClass;//类型
@property (nonatomic, copy) NSString * vCode;//片种（有码 无码）
@property (nonatomic, copy) NSString * orderBy;//排序方式（1时间 2点击量）
@end

@implementation TYLongVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderBy = @"2";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell"];
    
//    [self headerRefreshRequest];
    
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithHeader:self.collectionView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshCollectionWithFooter:self.collectionView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getVideoListRequestData];
    }];
}
- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getVideoTypeListRequestData];
}
- (void)getVideoTypeListRequestData {
    
    NSDictionary * dic = @{
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/sysTem/api/getVideoTypeList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSArray *arr = [TYVideoTypeListModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                weakSelf.allVideoKindArr = [NSArray arrayWithArray:arr];
                TYVideoTypeListModel *model = arr[0];
                self.vCode = model.content;
                
                [self getCategroyListRequestData];
            }else {
                NSLog(@"加载空视图");
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//全部vClass
- (void)getCategroyListRequestData {
    NSDictionary * dic = @{
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoCategroy/api/getCategroyList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSArray *arr = [TYCategroyListModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                weakSelf.allVideoArr = [NSArray arrayWithArray:arr];
                
                self.topBackView.backgroundColor = [UIColor whiteColor];
                
                TYCategroyListModel *model = arr[0];
                self.vClass = model.name;
                
                [self getVideoListRequestData];
            }else {
                NSLog(@"加载空视图");
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//初始化接口
- (void)getVideoListRequestData {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"orderBy":self.orderBy,
                           @"vCode":self.vCode,
                           @"vClass":self.vClass,
                           @"vActor":@"",
                           @"vLabel":@"",
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
    return self.dataArr.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TYAVDetailContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell" forIndexPath:indexPath];
    if (self.dataArr&&self.dataArr.count>indexPath.row) {
        TYHomeItemModel *model = self.dataArr[indexPath.row];
        cell.itemModel = model;

    }
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionWidth, collectionWidth*(160/211.f));
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
    
} //每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TYHomeItemModel *model = self.dataArr[indexPath.row];
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    vc.avID = model.ID;
    [self.navigationController pushVC:vc animated:YES];
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
        [self.view addSubview:_topBackView];
        [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            else make.top.offset(0);
            make.left.right.offset(0);
            make.height.offset(110);
        }];
        UIButton *selectBtn = nil;
        for (int i =0; i<self.zuiDuoArr.count; i++) {
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",self.zuiDuoArr[i]] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(zuiduoClick:)];
            btn.tag = 10+i;
            if (i == 0) {
                _zuixinBtn = btn;
                btn.borderWidth = 1;
            }
            btn.borderColor = main_select_text_color;
            btn.cornerRadius = 13;
            [_topBackView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                if (selectBtn) {
                    make.left.equalTo(selectBtn.mas_right).offset(10);
                }else {
                    make.left.offset(10);
                }
                make.height.offset(26);
            }];
            selectBtn = btn;
        }
        
        
        UIScrollView *middleSV = [[UIScrollView alloc] init];
        [_topBackView addSubview:middleSV];
        [middleSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBtn.mas_bottom).offset(5);
            make.left.right.offset(0);
            make.height.offset(26);
        }];
        
        UIButton *selectSliceBtn = nil;
        for (int i =0; i<self.allVideoKindArr.count; i++) {
            TYVideoTypeListModel *model = self.allVideoKindArr[i];
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",model.content] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(videoTypeClick:)];
            btn.tag = 100+i;
            if (i == 0) {
                _allVideoKindBtn = btn;
                btn.borderWidth = 1;
            }
            btn.borderColor = main_select_text_color;
            btn.cornerRadius = 13;
            [middleSV addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                if (selectSliceBtn) {
                    make.left.equalTo(selectSliceBtn.mas_right).offset(10);
                }else {
                    make.left.offset(10);
                }
                make.height.offset(26);
            }];
            selectSliceBtn = btn;
        }
        [_topBackView layoutIfNeeded];
        
        middleSV.contentSize = CGSizeMake(selectSliceBtn.right+10, middleSV.height);
        
        
        UIScrollView *bottomSV = [[UIScrollView alloc] init];
        [_topBackView addSubview:bottomSV];
        [bottomSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleSV.mas_bottom).offset(5);
            make.left.right.offset(0);
            make.height.offset(26);
        }];
        
        UIButton *selectAllBtn = nil;
        for (int i =0; i<self.allVideoArr.count; i++) {
            TYCategroyListModel *model = self.allVideoArr[i];
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",model.name] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(allVideoClick:)];
            btn.tag = 1000+i;
            if (i == 0) {
                _allVideoBtn = btn;
                btn.borderWidth = 1;
            }
            btn.borderColor = main_select_text_color;
            btn.cornerRadius = 13;
            [bottomSV addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                if (selectAllBtn) {
                    make.left.equalTo(selectAllBtn.mas_right).offset(10);
                }else {
                    make.left.offset(10);
                }
                make.height.offset(26);
            }];
            selectAllBtn = btn;
        }
        [_topBackView layoutIfNeeded];
        
        bottomSV.contentSize = CGSizeMake(selectAllBtn.right+10, bottomSV.height);
    }
    return _topBackView;
}

- (NSArray *)zuiDuoArr {
    if (!_zuiDuoArr) {
        _zuiDuoArr = @[@"最多播放",@"最近更新"];
    }
    return _zuiDuoArr;
}
- (void)zuiduoClick:(UIButton *)btn {
    btn.borderWidth = 1;
    _zuixinBtn.borderWidth = 0;
    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_zuixinBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    self.orderBy = btn.tag == 10?@"2":@"1";
    
    _zuixinBtn = btn;
    [self getVideoListRequestData];
}

- (void)videoTypeClick:(UIButton *)btn {
    btn.borderWidth = 1;
    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    _allVideoKindBtn.borderWidth = 0;
    [_allVideoKindBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    TYVideoTypeListModel *model = self.allVideoKindArr[btn.tag-100];
    self.vCode = model.content;
    
     _allVideoKindBtn = btn;
    [self getVideoListRequestData];
}

- (void)allVideoClick:(UIButton *)btn {
    btn.borderWidth = 1;
    _allVideoBtn.borderWidth = 0;
    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_allVideoBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    TYCategroyListModel *model = self.allVideoArr[btn.tag-1000];
    self.vClass = model.name;
    
     _allVideoBtn = btn;
    [self getVideoListRequestData];
}
@end

//
//  TYGoddessViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGoddessViewController.h"
#import "TYAVDetailsViewController.h"
#import "TYGoddessCollectionViewCell.h"
#import "TYGoddessModel.h"
#import "TYActorModel.h"

#define collectionWidth (KSCREEN_WIDTH-50)/4.0f

@interface TYGoddessViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIButton *_zuixinBtn,*_allCupBtn; //选中的btn
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIView * topBackView;

@property (nonatomic, strong) NSMutableArray * allCupArr;
@property (nonatomic, copy) NSArray * zuiDuoArr;


@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, copy) NSString * orderBy;
@property (nonatomic, copy) NSString * cupID;
@property (nonatomic, strong) TYActorModel *actorModel;
@end

@implementation TYGoddessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _selectBtn1 = _moreBtn;
//    _selectBtn2 = _allBtn;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYGoddessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYGoddessCollectionViewCell"];
    
    [self getActorTypeListRequestData];
}
//
- (void)getActorTypeListRequestData {
    NSDictionary * dic = @{
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/sysTem/api/getActorTypeList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSArray *arr = [TYGoddessModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                weakSelf.allCupArr = [NSMutableArray arrayWithArray:arr];
                
                self.topBackView.backgroundColor = [UIColor whiteColor];
                
                TYGoddessModel *model = arr[0];
                self.cupID = model.ID;
                
                [self getActorListRequestData];
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
///videoActor/api/getActorList
//初始化接口
- (void)getActorListRequestData {
    NSDictionary * dic = @{
                           @"cupId":self.cupID,
                           @"orderBy":@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoActor/api/getActorList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success&&data) {
            weakSelf.actorModel = [TYActorModel mj_objectWithKeyValues:data];
            NSArray *arr = [NSArray arrayWithArray:weakSelf.actorModel.data];
            
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

//收藏请求
- (void)shouCangRequestData:(TYActorListModel *)model {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":model.ID,
                           @"type":@"1"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/addCollection" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:msg inView:self.view];
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
    
    TYGoddessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYGoddessCollectionViewCell" forIndexPath:indexPath];
    if (self.dataArr&&self.dataArr.count>indexPath.row) {
        TYActorListModel *model = self.dataArr[indexPath.row];
        cell.listModel = model;
        TYWEAK_SELF;
        cell.shouCangBlock = ^{
            [weakSelf shouCangRequestData:model];
        };
    }
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionWidth, collectionWidth*(278/144.f));
    
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
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
        [self.view addSubview:_topBackView];
        [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            else make.top.offset(0);
            make.left.right.offset(0);
            make.height.offset(80);
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
        for (int i =0; i<self.allCupArr.count; i++) {
            TYGoddessModel *model = self.allCupArr[i];
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",model.content] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(actorTypeClick:)];
            btn.tag = 100+i;
            if (i == 0) {
                _allCupBtn = btn;
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
    if(_zuixinBtn == btn) return;
    btn.borderWidth = 1;
    _zuixinBtn.borderWidth = 0;
    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_zuixinBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    self.orderBy = btn.tag == 10?@"2":@"1";
    
    _zuixinBtn = btn;
    [self getActorListRequestData];
}

- (void)actorTypeClick:(UIButton *)btn {
    if(_allCupBtn == btn) return;
    btn.borderWidth = 1;
    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    _allCupBtn.borderWidth = 0;
    [_allCupBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    TYGoddessModel *model = self.allCupArr[btn.tag-100];
    self.cupID = model.ID;
    
    _allCupBtn = btn;
    [self getActorListRequestData];
}
@end

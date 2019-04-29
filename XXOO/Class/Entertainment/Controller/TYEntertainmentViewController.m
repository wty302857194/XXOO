//
//  TYEntertainmentViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYEntertainmentViewController.h"
#import "TYEntertainmentCollectionViewCell.h"
#import "TYAVDetailsViewController.h"
#import "TYEntertainmentModel.h"

#define collectionWidth (KSCREEN_WIDTH-40)/3.0f

@interface TYEntertainmentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TYEntertainmentModel * entertainmentModel;
@end

@implementation TYEntertainmentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"娱乐";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYEntertainmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYEntertainmentCollectionViewCell"];
    
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithHeader:self.collectionView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshCollectionWithFooter:self.collectionView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getAdListRequestData];
    }];
    
    
//    [self headerRefreshRequest];
}
- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getAdListRequestData];
}
///sysAd/api/getAdList
- (void)getAdListRequestData {
    NSDictionary *dic = @{
                          @"pageNum":@(self.page),
                          @"limit":@"20"
                          };
    TYWEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/sysAd/api/getAdList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success&&data) {
            weakSelf.entertainmentModel = [TYEntertainmentModel mj_objectWithKeyValues:data];
            NSArray *arr = [NSArray arrayWithArray:weakSelf.entertainmentModel.data];
            
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
                    [weakSelf.collectionView reloadData];
                }else {
                    NSLog(@"加载空视图");
                }
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:description inView:weakSelf.view];
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
    TYEntertainmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYEntertainmentCollectionViewCell" forIndexPath:indexPath];
    TYEntertainmentItemModel *model = self.entertainmentModel.data[indexPath.row];
    cell.itemModel = model;
    return cell;
    
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionWidth, collectionWidth*(235/181.f));
    
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
    
    TYEntertainmentItemModel *model = self.entertainmentModel.data[indexPath.row];
    [TYGlobal openScheme:model.linkUrl];
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
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.offset(0);
        }];
    }
    return _collectionView;
}


@end

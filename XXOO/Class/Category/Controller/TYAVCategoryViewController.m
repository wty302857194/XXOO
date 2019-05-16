//
//  TYAVCategoryViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVCategoryViewController.h"
#import "TYAVCategoryCollectionViewCell.h"
#import "TYAVCategaryModel.h"
#import "TYSearchDetailViewController.h"

#define collectionWidth (KSCREEN_WIDTH-80)/3.0f

@interface TYAVCategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
//@property (nonatomic, assign) NSInteger page;//页数
//@property (nonatomic, assign) BOOL isFresh;//是否加载
@end

@implementation TYAVCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [NSMutableArray arrayWithCapacity:0];

    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVCategoryCollectionViewCell"];
    
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithHeader:self.collectionView refreshingBlock:^{
        [weakSelf getAVVideoListRequestData];
    }];

}
//初始化接口
- (void)getAVVideoListRequestData {
    NSDictionary * dic = @{};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoCategroy/api/getCategroyList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success&&data) {
            NSArray *arr = [TYAVCategaryModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                [weakSelf.dataArr addObjectsFromArray:arr];
                
            }else {
                NSLog(@"加载空视图");
            }
            [weakSelf.collectionView reloadData];
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
    
    TYAVCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVCategoryCollectionViewCell" forIndexPath:indexPath];
    if (self.dataArr&&self.dataArr.count>0) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionWidth, collectionWidth*(265/150.f));
    
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
    
    TYAVCategaryModel *model = self.dataArr[indexPath.row];
    TYSearchDetailViewController *vc = [[TYSearchDetailViewController alloc] init];
    vc.vLabel = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

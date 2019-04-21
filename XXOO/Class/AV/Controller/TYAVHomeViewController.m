//
//  TYAVHomeViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVHomeViewController.h"
#import "TYEntertainmentCollectionViewCell.h"
#import "TYHomeTableViewCell.h"
#import "TYAVDetailsViewController.h"
#import "PYSearch.h"
#import "TYSearchViewController.h"
#import "TYBaseNavigationController.h"

#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f

@interface TYAVHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TYAVHomeViewController

- (IBAction)selectBtnClick:(UIButton *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSInteger index =  [self.tabBarController selectedIndex];
    self.tableView.hidden = index == 0?NO:YES;
    self.collectionView.hidden = index == 0?YES:NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYEntertainmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYEntertainmentCollectionViewCell"];
    
    [self.searchBackView addTarget:self action:@selector(goSearch)];
}

- (void)goSearch {
    TYSearchViewController *vc = [[TYSearchViewController alloc] init];
    
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
    
//    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"输入关键字查找片源" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        
//        [searchViewController.navigationController pushViewController:[[TYSearchViewController alloc] init] animated:YES];
//    }];
//    
//    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:searchViewController];
//    [self presentViewController:nav  animated:YES completion:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 5;//_dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 245;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"TYHomeTableViewCell";
    TYHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TYHomeTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}




#pragma mark -- UICollectionDataSource
#pragma mark -- UICollectionViewDataSource //定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYEntertainmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYEntertainmentCollectionViewCell" forIndexPath:indexPath];
//    [cell sizeToFit];
    
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionWidth, collectionWidth*(118/165.f));
    
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

@end

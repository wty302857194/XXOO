//
//  TYSearchDetailViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSearchDetailViewController.h"
#import "TYSearchDetailCollectionViewCell.h"

#define collectionWidth (KSCREEN_WIDTH-26 -18)/2.0f

@interface TYSearchDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *longAVBtn;
@property (weak, nonatomic) IBOutlet UIButton *shortBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (nonatomic, strong) UIButton * selectBtn;


@end

@implementation TYSearchDetailViewController
- (IBAction)tabTouch:(UIButton *)sender {
    if (sender == _selectBtn) return;
    
    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_selectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    self.lineLab.center = CGPointMake(sender.center.x, self.lineLab.centerY);

    if (sender == _longAVBtn) {
        
    }else {
        
    }
    
    _selectBtn = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"搜索结果";
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYSearchDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYSearchDetailCollectionViewCell"];
}
#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYSearchDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYSearchDetailCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
    
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionWidth, collectionWidth*(540/328.f));
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 13, 10, 13);
    
} //每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

@end

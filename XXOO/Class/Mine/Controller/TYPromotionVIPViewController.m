//
//  TYPromotionVIPViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYPromotionVIPViewController.h"
#import "TYPromotionVIPTableViewCell.h"
#import "TYPromotionVIPView.h"

@interface TYPromotionVIPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TYPromotionVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"升级VIP会员";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_payType_img"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"listviewid";
    TYPromotionVIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TYPromotionVIPTableViewCell" owner:nil options:nil] lastObject];
    }
//    cell.historyModel = self.dataArr[indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    TYPromotionVIPView *promotionVIPView = [[[NSBundle mainBundle] loadNibNamed:@"TYPromotionVIPView" owner:nil options:nil] lastObject];
    
    return promotionVIPView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        // 同时也要设置tableView的顶部约束
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0,*)) {
                make.top.equalTo(self.view.mas_top);
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            } else {
                make.edges.equalTo(self.view);
            }
        }];
    }
    return _tableView;
}

@end

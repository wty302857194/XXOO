//
//  TYTaskViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTaskViewController.h"
#import "TYTaskTableViewCell.h"
#import "TYTaskModel.h"

@interface TYTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeghtLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackViewLayout;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLab;//推荐
@property (weak, nonatomic) IBOutlet UILabel *integralLab;//积分
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray * dataArr;

@end

@implementation TYTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBackViewLayout.constant = -kStatusBarHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TYTaskTableViewCell"];
    
    [self getTaskListRequestData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - requestData
// /sysTask/api/getTaskList

- (void)getTaskListRequestData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"sysTask/api/getTaskList" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.dataArr = [TYTaskModel mj_objectArrayWithKeyValuesArray:data];
            NSLog(@"dataArr === %@",self.dataArr);
//            [self.tableView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
        
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYTaskTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"暂无数据";
//
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
//                                 NSParagraphStyleAttributeName:paragraph
//                                 };
//
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}
//
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    // 设置按钮标题
//    NSString *buttonTitle = @"立即推广";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],
//                                 NSForegroundColorAttributeName:[UIColor whiteColor],
//                                 };
//    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
//}
//
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return [UIImage imageNamed:@"short_btn_backImg"];
//}
@end

//
//  TYTuiGuangHistoryViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/5.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTuiGuangHistoryViewController.h"
#import "TYTGHistoryModel.h"
@interface TYTuiGuangHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel * leftLab;
@property (nonatomic, strong) UILabel * middleLab;
@property (nonatomic, strong) UILabel * rightLab;

@property (nonatomic, strong) TYTGHistoryModel * historyModel;
@end
@implementation TYTuiGuangHistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *selectLab = nil;
        for (int i = 0; i<3; i++) {
            UILabel *lab = [[UILabel alloc] init];
            lab.text = @"";
            lab.textColor = main_light_text_color;
            lab.font = [UIFont systemFontOfSize:15];
            lab.numberOfLines = 2;
            lab.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lab];
            if (i == 0) {
                _leftLab = lab;
            }else if (i == 1) {
                _middleLab = lab;
            }else {
                _rightLab = lab;
            }
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                if (!selectLab) {
                    make.left.offset(0);
                }else {
                    make.left.equalTo(selectLab.mas_right);
                    make.width.equalTo(selectLab.mas_width);
                }
                if (i == 2) {
                    make.right.offset(0);
                }
            }];
            selectLab = lab;
        }
    }
    return self;
}
- (void)setHistoryModel:(TYTGHistoryModel *)historyModel {
    _leftLab.text = [NSString stringWithFormat:@"%@",historyModel.ID];
    _middleLab.text = [NSString stringWithFormat:@"%@",historyModel.money];
    _rightLab.text = [NSString stringWithFormat:@"%@",historyModel.createTime];
}
@end

@interface TYTuiGuangHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@end

@implementation TYTuiGuangHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现记录";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    TYWEAK_SELF;
    [TYRefershClass refreshWithHeader:self.tableView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getUserWithdrawListRequestData];
    }];
}
- (void)headerRefreshRequest{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    self.isFresh = NO;
    [self getUserWithdrawListRequestData];
}
//   /userWithdraw/api/getUserWithdrawList
- (void)getUserWithdrawListRequestData {
    
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/userWithdraw/api/getUserWithdrawList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success&&data) {
            NSArray *arr = [TYTGHistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"]];

            
            if (weakSelf.isFresh) {
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    [weakSelf.tableView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else {
                [weakSelf.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    
                }else {
                    [MBProgressHUD promptMessage:@"暂无数据" inView:self.view];

                    NSLog(@"加载空视图");
                }
                [weakSelf.tableView reloadData];
            }
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
    TYTuiGuangHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[TYTuiGuangHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.historyModel = self.dataArr[indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *selectLab = nil;
    for (int i = 0; i<3; i++) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = i==0?@"id":(i==1?@"金额":@"时间");
        lab.textColor = main_light_text_color;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            if (!selectLab) {
                make.left.offset(0);
            }else {
                make.left.equalTo(selectLab.mas_right);
                make.width.equalTo(selectLab.mas_width);
            }
            if (i == 2) {
                make.right.offset(0);
            }
        }];
        selectLab = lab;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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

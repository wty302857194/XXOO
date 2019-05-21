//
//  TYDuiHuanViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYDuiHuanViewController.h"
#import "TYDuiHuanFirstTableViewCell.h"
#import "TYDuiHuanSecondTableViewCell.h"
#import "TYDuiHuanModel.h"
#import "TYShengJiVIPViewController.h"

@interface TYDuiHuanHeaderView : TYBaseView
@property (nonatomic, strong) UIImageView * headerImgView;
@property (nonatomic, strong) UILabel * jiFenLab;
@end

@implementation TYDuiHuanHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    self.headerImgView = [[UIImageView alloc] init];
    self.headerImgView.image = [UIImage imageNamed:@"mine_topBackImg"];
    [self addSubview:self.headerImgView];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"我的积分";
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = [UIColor whiteColor];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    self.jiFenLab = [UILabel new];
    self.jiFenLab.text = @"200";
    self.jiFenLab.font = [UIFont systemFontOfSize:35];
    self.jiFenLab.textColor = [UIColor whiteColor];
    [self addSubview:self.jiFenLab];
    [self.jiFenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(titleLab.mas_top).offset(-15);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}
@end


@interface TYDuiHuanViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TYDuiHuanHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, copy) NSString * userJiFen;
@end

@implementation TYDuiHuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"兑换中心";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.edgesForExtendedLayout =  UIRectEdgeAll;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYDuiHuanSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"TYDuiHuanSecondTableViewCell"];
    
    [self addTableVieHeaderView];
    [self getExchangeListRequestData];
}
- (void)back {
    NSLog(@"back");
}
//  /sysExchange/api/getExchangeList
- (void)getExchangeListRequestData {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/sysExchange/api/getExchangeList" parameters:@{@"id":[TYGlobal userId]} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            weakSelf.userJiFen = [NSString stringWithFormat:@"%@",data[@"score"]];
            self.headerView.jiFenLab.text = weakSelf.userJiFen;
            NSArray *arr = [TYDuiHuanModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            if (arr&&arr.count>0) {
                [weakSelf.dataArr addObjectsFromArray:arr];
            }else {
                NSLog(@"加载空视图");
            }
            [weakSelf.tableView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

// /user/api/exchangeVip
- (void)exchangeVipRequestData:(NSString *)tid {
    NSDictionary *dic = @{
                          @"id":[TYGlobal userId],
                          @"tid":tid?:@""
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/exchangeVip" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)addTableVieHeaderView {
    self.headerView = [[TYDuiHuanHeaderView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 180)];
    self.tableView.tableHeaderView = self.headerView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 导航栏不透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYWEAK_SELF;
    if (indexPath.row == 0) {
        TYDuiHuanFirstTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TYDuiHuanFirstTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellBackBlock = ^(NSInteger index) {
            if (index == 0) {//购买VIP
                TYShengJiVIPViewController *vc = [[TYShengJiVIPViewController alloc] init];
                TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }else {
                TYBaseTabBarViewController *tabbar = [[TYBaseTabBarViewController alloc] init];
                UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                keyWindow.rootViewController = tabbar;
                tabbar.selectedIndex = 3;
            }
        };
        return cell;
    }else {
        TYDuiHuanSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYDuiHuanSecondTableViewCell" forIndexPath:indexPath];
            TYDuiHuanModel *model = self.dataArr[indexPath.row -1];
            cell.model = model;
            cell.duiHuanBlock = ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"兑换VIP" message:[NSString stringWithFormat:@"你确定要兑换%@天的VIP吗？\n(有效期从成功兑换日期起计算)",model.membershipDuration] preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSLog(@"点击取消");
                    
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSLog(@"点击确认");
                    [weakSelf exchangeVipRequestData:model.ID];

                }]];
                 [weakSelf presentViewController:alertController animated:YES completion:nil];;
                
            };
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        float totalOffset = 155 + fabsf(offsetY);
        
        float f = totalOffset / 155.f;
        self.headerView.headerImgView.frame = CGRectMake(-KSCREEN_WIDTH * (f - 1) * 0.5, offsetY, KSCREEN_WIDTH * f, totalOffset);
        [self.headerView.headerImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(offsetY);
        }];
    }
}
@end

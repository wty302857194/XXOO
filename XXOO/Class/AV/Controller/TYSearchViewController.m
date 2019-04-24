//
//  TYSearchViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSearchViewController.h"
#import "TYSeachTableViewCell.h"
#import "TYAVDetailsViewController.h"
#import "TYSearchDetailViewController.h"
#import "TYHotSearchModel.h"

@interface TYSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSArray * historyDataArr;
@property (nonatomic, strong) UIView * searchBackView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self searchView];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self hotSearchRequestData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
///video/api/getHotSearchVideo
- (void)hotSearchRequestData {
    
    NSDictionary * dic = @{
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getHotSearchVideo" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success&&data) {
            NSArray *arr = [TYHotSearchModel mj_objectArrayWithKeyValuesArray:data];
            if (arr&&arr.count>0) {
                weakSelf.dataArr =  [NSMutableArray arrayWithArray:arr];
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
- (void)searchView {
    UIView *searchBackView = [[UIView alloc] init];
    [self.view addSubview:searchBackView];
    _searchBackView = searchBackView;
    [searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.offset(0);
        make.height.offset(60);
    }];
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:main_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(cancelClick)];
    [searchBackView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(searchBackView.mas_centerY);
        make.width.offset(50);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = line_color;
    leftView.layer.cornerRadius = 20;
    [searchBackView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.equalTo(cancelBtn.mas_left).offset(-10);
        make.centerY.equalTo(searchBackView.mas_centerY);
        make.height.offset(40);
    }];
    
    UIImageView *searchImg = [[UIImageView alloc] init];
    searchImg.image = [UIImage imageNamed:@"home_sarch"];
    [searchImg setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//抗拉伸
    [leftView addSubview:searchImg];
    [searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(leftView.mas_centerY);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = main_text_color;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = @"输入关键词查找片源";
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [leftView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImg.mas_right).offset(10);
        make.right.offset(-10);
        make.centerY.equalTo(leftView.mas_centerY);
    }];
    
    
}
- (void)cancelClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
   
    if (section == 0) return 1;
    
    return self.dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.historyDataArr&&self.historyDataArr.count>0) {
            [self addLable:self.historyDataArr withContentView:cell.contentView];
        }else {
            cell.textLabel.text = @"暂无历史记录";
            cell.textLabel.textColor = main_light_text_color;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        return cell;
    }else {
        static NSString *cellid=@"listviewid";
        TYSeachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TYSeachTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataArr&&self.dataArr.count>indexPath.row) {
            [cell cellWithModel:self.dataArr[indexPath.row] andIndexPath:indexPath];
        }
       
        return cell;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        UILabel *lab  = [[UILabel alloc] init];
        lab.text = @"历史搜索";
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        UIButton *btn = [UIButton buttonWithTitle:@"清空" titleColor:main_light_text_color font:[UIFont systemFontOfSize:15] imageName:@"history_delete_img" target:self action:@selector(emptyDataSource)];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
    }else {
        UILabel *lab  = [[UILabel alloc] init];
        lab.text = @"热搜AV";
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
    }

    return view;
}
//清空历史记录
- (void)emptyDataSource {
    self.historyDataArr = @[];
    [USER_DEFAULTS setObject:self.historyDataArr forKey:HistoryDataSource];
    [USER_DEFAULTS synchronize];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        TYHotSearchModel *mode = self.dataArr[indexPath.row];
        TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
        vc.avID = mode.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - textfield delegata
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"textField == %@",textField.text);
//    NSMutableArray *searchArr = [[NSMutableArray alloc] initWithCapacity:0];
//    if (self.historyDataArr&&self.historyDataArr.count>0) {
//        [searchArr addObjectsFromArray:self.historyDataArr];
//    }
//    [searchArr addObject:textField.text];
//
//    self.historyDataArr = [NSArray arrayWithArray:searchArr];
//
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    NSLog(@"textField == %@",textField.text);
    NSMutableArray *searchArr = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.historyDataArr&&self.historyDataArr.count>0) {
        [searchArr addObjectsFromArray:self.historyDataArr];
    }
    [searchArr addObject:textField.text];
    
    self.historyDataArr = [NSArray arrayWithArray:searchArr];
    
    [USER_DEFAULTS setObject:self.historyDataArr forKey:HistoryDataSource];
    [USER_DEFAULTS synchronize];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    
    TYSearchDetailViewController *vc = [[TYSearchDetailViewController alloc] init];
    vc.keyWord = textField.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}
- (void)addLable:(NSArray *)labArr withContentView:(UIView *)view{
    
    UIView *topLabView = [UIView new];
    [view addSubview:topLabView];
    [topLabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    CGFloat marginX = 10;  //按钮距离左边和右边的距离
    CGFloat marginY = 10;  //按钮距离布局顶部的距离
    CGFloat gap = 10;    //按钮与按钮之间的距离
    
    
    UIButton *selectBtn = nil;
    for (int i =0; i<labArr.count; i++) {
        UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",labArr[i]] titleColor:main_select_text_color font:[UIFont systemFontOfSize:14] target:self action:@selector(chooseStation:)];
        btn.tag = 10+i;
        btn.cornerRadius = 15;
        btn.layer.borderColor = main_select_text_color.CGColor;
        btn.layer.borderWidth = 1;
        [topLabView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (selectBtn) {
                make.top.equalTo(selectBtn.mas_top);
                make.left.equalTo(selectBtn.mas_right).offset(gap);
                if (i == labArr.count-1) {
                    make.bottom.offset(-marginX);
                }
            }
            else {
                make.top.offset(marginY);
                make.left.offset(marginX);
            }
            
            make.height.offset(30);
        }];
        
        [topLabView layoutIfNeeded];
        
        if ((btn.right+marginX)>KSCREEN_WIDTH) {
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(marginX);
                make.top.equalTo(selectBtn.mas_bottom).offset(10);
                make.height.offset(30);
                if (i == labArr.count-1) {
                    make.bottom.offset(-marginX);
                }
            }];
        }
        
        selectBtn = btn;
    }
}
- (void)chooseStation:(UIButton *)btn {
    //TYSearchDetailViewController
    TYSearchDetailViewController *vc = [[TYSearchDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ==懒加载==
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBackView.mas_bottom);
            make.left.bottom.right.offset(0);
        }];
    }
    return _tableView;
}
- (NSArray *)historyDataArr {
    if (!_historyDataArr) {
        NSLog(@"%@", [USER_DEFAULTS objectForKey:HistoryDataSource]);
        if ([USER_DEFAULTS objectForKey:HistoryDataSource]) {
            _historyDataArr = [NSArray arrayWithArray:[USER_DEFAULTS objectForKey:HistoryDataSource]];
        }else {
            _historyDataArr = @[];
        }
    }
    return _historyDataArr;
}
@end

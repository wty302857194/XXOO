//
//  TYVideoLableViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYVideoLableViewController.h"
#import "TYVideoLabelModel.h"
#import "TYSearchDetailViewController.h"

@interface TYVideoLableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_topSelectBtn,*_bottomSelectBtn;
    BOOL _isSelect;// 是否点击btn，点击后不刷表，只刷行
    NSInteger _num;//所选标签数量
}
//@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSArray * topLabArr;
@property (nonatomic, copy) NSArray * bottomLabArr;
@property (weak, nonatomic) IBOutlet UILabel *num_lab;
@property (nonatomic, strong) NSMutableDictionary * labDic;//存储所选标签

@end

@implementation TYVideoLableViewController
- (IBAction)chooseBTN:(UIButton *)sender {
    NSString *labStr = @"";
    for (id obj in self.labDic) {
        labStr = [NSString stringWithFormat:@"%@,%@",labStr,self.labDic[obj]];
    }
    if (labStr.length==0) {
        [MBProgressHUD promptMessage:@"你未选择影片标签" inView:self.view];
        return;
    }
    TYSearchDetailViewController *vc = [[TYSearchDetailViewController alloc] init];
    vc.vLabel = labStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.labDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tableView.tableFooterView = [UIView new];
    [self getVideoLabelRequestData];
}
#pragma mark - requestData
///videoLabel/api/getVideoLabel
- (void)getVideoLabelRequestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoLabel/api/getVideoLabel" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            
            NSArray *arr = [TYVideoLabelModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                weakSelf.topLabArr = [NSArray arrayWithArray:arr];
                TYVideoLabelModel *model = arr[0];
                [weakSelf getVideoLabelByLevelRequestData:model.ID];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
// /videoLabel/api/getVideoLabelByLevel
- (void)getVideoLabelByLevelRequestData:(NSString *)ID {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoLabel/api/getVideoLabelByLevel" parameters:@{@"id":ID?:@""} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            
            NSArray *arr = [TYVideoLabelModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                weakSelf.bottomLabArr = [NSArray arrayWithArray:arr];
                if (self->_isSelect) {
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }else {
                    [weakSelf.tableView reloadData];
                }
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
    return 2;//_dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listviewid"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [self addLable:self.topLabArr withView:cell.contentView withIndex:indexPath.row ];
    }else {
        [self addLable:self.bottomLabArr withView:cell.contentView withIndex:indexPath.row ];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.mas_equalTo(-80);
        }];
    }
    return _tableView;
}

- (void)addLable:(NSArray *)labArr withView:(UIView *)view withIndex:(NSInteger)index {
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
        
        UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:main_light_text_color font:[UIFont systemFontOfSize:14] target:self action:@selector(chooseStation:)];
        TYVideoLabelModel *model = labArr[i];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",model.label] forState:UIControlStateNormal];
        
        if (index == 0) {
            if (i == 0) {
                _topSelectBtn = btn;
                btn.layer.borderWidth = 1;
                [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
            }
            
            btn.layer.borderColor = main_select_text_color.CGColor;
        }else {
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = main_light_text_color.CGColor;
        }
        btn.tag = 10+i;
        btn.index = @(index);
        btn.cornerRadius = 15;
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
            }];
        }
        
        selectBtn = btn;
    }
}
- (void)chooseStation:(UIButton *)btn {
    _isSelect = YES;
    
    if ([btn.index isEqual:@(0)]) {
        if(_topSelectBtn == btn) return;
        _num =0;
        btn.layer.borderWidth = 1;
        [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
        _topSelectBtn.layer.borderWidth = 0;
        [_topSelectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];

        TYVideoLabelModel *model = self.topLabArr[btn.tag-10];
        [self getVideoLabelByLevelRequestData:model.ID];
        self.num_lab.text = [NSString stringWithFormat:@"%ld",(long)_num];

        [self.labDic removeAllObjects];
        
        _topSelectBtn = btn;
    }else {
        if (btn.selected) {
            btn.layer.borderColor = main_light_text_color.CGColor;
            [btn setTitleColor:main_light_text_color forState:UIControlStateNormal];
            [self.labDic removeObjectForKey:@(btn.tag)];
            _num--;
        }else {
            btn.layer.borderColor = main_select_text_color.CGColor;
            [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
            TYVideoLabelModel *model = self.bottomLabArr[btn.tag-10];
            
            [self.labDic setObject:model.label forKey:@(btn.tag)];
            _num++;
        }
        self.num_lab.text = [NSString stringWithFormat:@"%ld",(long)_num];
        btn.selected = !btn.selected;
    }
}
@end

//
//  TYMyTuiGunagViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYMyTuiGunagViewController.h"
#import "TYTuiGuangView.h"

@interface TYMyTuiGunagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TYTuiGuangView * tuiGuangView;
@end

@implementation TYMyTuiGunagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.tableHeaderView = self.tuiGuangView;
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
    return 50;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"listviewid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - delegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger offsetY = scrollView.contentOffset.y;
//    if (offsetY < 0) {
//        float totalOffset = 263 + labs(offsetY);
//        
//        float f = totalOffset / 263.f;
//        self.tuiGuangView.tuiGuangBackImg.frame = CGRectMake(-KSCREEN_WIDTH * (f - 1) * 0.5, offsetY, KSCREEN_WIDTH * f, totalOffset);
//    }
//}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.bottom.right.offset(0);
        }];
    }
    return _tableView;
}
- (TYTuiGuangView *)tuiGuangView {
    if (!_tuiGuangView) {
        _tuiGuangView = [[[NSBundle mainBundle] loadNibNamed:@"TYTuiGuangView" owner:nil options:nil] lastObject];
        _tuiGuangView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, 130);
    }
    return _tuiGuangView;
}
@end

//
//  TYEntertainmentViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYEntertainmentViewController.h"
#import "TYAVHomeViewController.h"
#import <SJScrollEntriesView/SJScrollEntriesView.h>
#import "TestItem.h"

@interface TYEntertainmentViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, SJScrollEntriesViewDelegate>

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, strong, readonly) SJScrollEntriesView *titlesView;
@property (nonatomic, copy) NSArray * titleArr;

@end

@implementation TYEntertainmentViewController

@synthesize titlesView = _titlesView;
@synthesize pageViewController = _pageViewController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.titlesView];
    [self.titlesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.offset(44);
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlesView.mas_bottom).offset(1);
        make.leading.bottom.trailing.offset(0);
    }];
    
    [self.pageViewController setViewControllers:@[[self _viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
- (BOOL)prefersStatusBarHidden {
    return self.pageViewController.viewControllers.firstObject.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.pageViewController.viewControllers.firstObject.preferredStatusBarStyle;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark - lazy

- (SJScrollEntriesView *)titlesView {
    if ( _titlesView ) return _titlesView;
    SJScrollEntriesViewSettings *settins = [SJScrollEntriesViewSettings defaultSettings];
    settins.selectedColor = TYRGBColor(138, 78, 220);
    settins.lineColor = TYRGBColor(138, 78, 220);
    settins.fontSize = 16.0;
    settins.itemSpacing = 0;
    settins.lineScale = 1;
    _titlesView = [[SJScrollEntriesView alloc] initWithSettings:settins];
    _titlesView.backgroundColor = [UIColor whiteColor];
    NSMutableArray<TestItem *> *arrM = [NSMutableArray array];
    for ( int i = 0 ; i < self.titleArr.count ; ++ i ) {
        [arrM addObject:[[TestItem alloc] initWithTitle:self.titleArr[i]]];
    }
    [_titlesView setValue:arrM forKey:@"items"];
    _titlesView.delegate = self;
    return _titlesView;
}

- (UIPageViewController *)pageViewController {
    if ( _pageViewController ) return _pageViewController;
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(2)}];
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    return _pageViewController;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"最新",@"限免",@"无码",@"独家",@"中文"];
    }
    return _titleArr;
}

#pragma mark - delegate

- (void)scrollEntriesView:(SJScrollEntriesView *)view currentIndex:(NSInteger)currentIndex beforeIndex:(NSInteger)beforeIndex {
    NSInteger vcIndex = self.pageViewController.viewControllers.firstObject.index;
    if ( currentIndex == vcIndex ) return;
    UIPageViewControllerNavigationDirection direction = (vcIndex > currentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    [self.pageViewController setViewControllers:@[[self _viewControllerAtIndex:currentIndex]] direction:direction animated:YES completion:nil];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self _viewControllerAtIndex:viewController.index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self _viewControllerAtIndex:viewController.index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *vc = pageViewController.viewControllers.firstObject;
    [self.titlesView changeIndex:[vc index]];
}
- (UIViewController *)_viewControllerAtIndex:(NSInteger)index {
    if ( index >= self.titleArr.count) return nil;
    if ( index < 0 ) return nil;
    
    UIViewController *vc = self.dataViewControllersDictM[@(index)];
    if ( vc ) return vc;
    vc = [TYAVHomeViewController new];
    vc.index = index;
    self.dataViewControllersDictM[@(index)] = vc;
    return vc;
}
- (NSMutableDictionary< NSNumber *, UIViewController *> *)dataViewControllersDictM {
    NSMutableDictionary< NSNumber *, UIViewController *> *dataViewControllersDictM = objc_getAssociatedObject(self, _cmd);
    if ( dataViewControllersDictM ) return dataViewControllersDictM;
    dataViewControllersDictM = [NSMutableDictionary new];
    objc_setAssociatedObject(self, _cmd, dataViewControllersDictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dataViewControllersDictM;
}


@end

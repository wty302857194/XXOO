//
//  TYBaseViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYBaseViewController ()

@end

@implementation TYBaseViewController

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - -[%@ dealloc]", (int)__LINE__, NSStringFromClass([self class]));
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end

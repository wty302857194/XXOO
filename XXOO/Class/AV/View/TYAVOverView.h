//
//  TYAVOverView.h
//  XXOO
//
//  Created by wbb on 2019/5/8.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"
#import "SJControlLayerDefines.h"
#import "SJEdgeControlLayerAdapters.h"
#import "SJBaseVideoPlayer.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^OverBlcok)(NSInteger index);
@interface TYAVOverView : SJEdgeControlLayerAdapters<SJControlLayer>
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *renewBnt;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (nonatomic, copy) OverBlcok overBlcok;

@property (nonatomic, weak, nullable) SJBaseVideoPlayer *player; // need weak ref

@end

NS_ASSUME_NONNULL_END

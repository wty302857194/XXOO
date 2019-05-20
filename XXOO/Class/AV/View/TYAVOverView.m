//
//  TYAVOverView.m
//  XXOO
//
//  Created by wbb on 2019/5/8.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVOverView.h"
#import "UIView+SJAnimationAdded.h"

@implementation TYAVOverView
- (IBAction)goback:(UIButton *)sender {
    if (self.overBlcok) {
        self.overBlcok(10);
    }
}
- (IBAction)renewClick:(UIButton *)sender {
    if (self.overBlcok) {
        self.overBlcok(20);
    }
}
- (IBAction)vipClick:(UIButton *)sender {
    if (self.overBlcok) {
        self.overBlcok(30);
    }
}

@synthesize restarted = _restarted;



- (UIView *)controlView {
    return self;
}

- (BOOL)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer gestureRecognizerShouldTrigger:(SJPlayerGestureType)type location:(CGPoint)location {
    if ( CGRectContainsPoint( _topContainerView.frame, location) ||
        CGRectContainsPoint( _bottomContainerView.frame, location) ) return NO;
    return YES;
}

- (void)installedControlViewToVideoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer {
    _player = videoPlayer;

    [_player.view layoutIfNeeded];
    sj_view_makeDisappear(_topContainerView, NO);
    sj_view_makeDisappear(_bottomContainerView, NO);
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    sj_view_makeAppear(_topContainerView, YES);
    sj_view_makeAppear(_bottomContainerView, YES);
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer {
    sj_view_makeDisappear(_topContainerView, YES);
    sj_view_makeDisappear(_bottomContainerView, YES);
}

- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer prepareToPlay:(SJVideoPlayerURLAsset *)asset {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

- (void)restartControlLayer {
    _restarted = YES;

    sj_view_makeAppear(self.controlView, YES);
    sj_view_makeAppear(_topContainerView, YES);
    sj_view_makeAppear(_bottomContainerView, YES);
    [_player controlLayerNeedAppear];
}

- (void)exitControlLayer {
    _restarted = NO;
    
    _player.controlLayerDataSource = nil;
    _player.controlLayerDelegate = nil;
    _player = nil;

    sj_view_makeDisappear(_topContainerView, YES);
    sj_view_makeDisappear(_bottomContainerView, YES);
    
//    sj_view_makeDisappear(self.controlView, YES);
    sj_view_makeDisappear(self.controlView, YES, ^{
        if ( !self -> _restarted ) [self.controlView removeFromSuperview];
    });
}

//- (BOOL)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer gestureRecognizerShouldTrigger:(SJPlayerGestureType)type location:(CGPoint)location {
//    
//    return NO;
//    
//}
@end

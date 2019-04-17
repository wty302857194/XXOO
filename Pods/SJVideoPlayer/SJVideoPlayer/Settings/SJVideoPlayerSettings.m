//
//  SJVideoPlayerSettings.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2017/9/25.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerSettings.h"
#import <UIKit/UIKit.h>
#import "SJFilmEditingSettings.h"
#import "SJEdgeControlLayerSettings.h"
#import <objc/message.h>

@interface _SJVideoPlayerNothingSettings : NSObject
- (instancetype)initWithSelector:(SEL)selector;
@end

@implementation _SJVideoPlayerNothingSettings
static void sj_nothing(id self, SEL _cmd) {
#ifdef DEBUG
    printf("\nSJVideoPlayerNothingSettings: %s\n", (const char *)(void *)_cmd);
#endif
}
- (instancetype)initWithSelector:(SEL)selector {
    self = [super init];
    if ( !self ) return nil;
    class_addMethod([self class], selector, (IMP)sj_nothing, "v16@0:8");
    return self;
}
@end

@implementation SJVideoPlayerSettings {
    dispatch_group_t _group;
}
+ (instancetype)commonSettings {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _group = dispatch_group_create();
    dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
        [SJEdgeControlLayerSettings commonSettings];
    });
    dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
        [SJFilmEditingSettings commonSettings];
    });
    return self;
}

+ (void (^)(void (^ _Nonnull)(SJVideoPlayerSettings * _Nonnull)))update {
    return ^(void(^block)(SJVideoPlayerSettings *settings)) {
        dispatch_group_notify(SJVideoPlayerSettings.commonSettings->_group, dispatch_get_global_queue(0, 0), ^{
            block(SJVideoPlayerSettings.commonSettings);
            [SJEdgeControlLayerSettings.commonSettings postUpdateNotify];
            [SJFilmEditingSettings.commonSettings postUpdateNotify];
        });
    };
}

- (void)reset {
    dispatch_group_notify(_group, dispatch_get_global_queue(0, 0), ^{
        [SJEdgeControlLayerSettings.commonSettings reset];
        [SJFilmEditingSettings.commonSettings reset];
        [SJEdgeControlLayerSettings.commonSettings postUpdateNotify];
        [SJFilmEditingSettings.commonSettings postUpdateNotify];
    });
} 

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ( [SJEdgeControlLayerSettings.commonSettings respondsToSelector:aSelector] )
        return SJEdgeControlLayerSettings.commonSettings;
    else if ( [SJFilmEditingSettings.commonSettings respondsToSelector:aSelector] )
        return SJFilmEditingSettings.commonSettings;
    return [[_SJVideoPlayerNothingSettings alloc] initWithSelector:aSelector];
}
@end

//
//  TYRefershClass.h
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYRefershClass : NSObject
/*
 下拉刷新
 */
+ (void)refreshWithHeader:(UITableView *)tableView
          refreshingBlock:(void (^)(void))headerWithRefreshingBlock;
/*
 上拉加载
 */
+ (void)refreshWithFooter:(UITableView *)collection
          refreshingBlock:(void (^)(void))footerWithRefreshingBlock;

/*
 collection下拉刷新
 */
+ (void)refreshCollectionWithHeader:(UICollectionView *)collection
                    refreshingBlock:(void (^)(void))headerWithRefreshingBlock;
/*
 collection上拉加载
 */
+ (void)refreshCollectionWithFooter:(UICollectionView *)collection
                    refreshingBlock:(void (^)(void))footerWithRefreshingBlock;

@end

NS_ASSUME_NONNULL_END

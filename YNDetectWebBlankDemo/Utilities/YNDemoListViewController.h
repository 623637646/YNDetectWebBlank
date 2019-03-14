//
//  YNDemoListViewController.h
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 22/2/19.
//  Copyright © 2019 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNDemoListDataSourceItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, nullable) id obj;

+(YNDemoListDataSourceItem*)itemWithTitle:(NSString *)title obj:(nullable id)obj;

@end

@interface YNDemoListViewController : UIViewController

@property (nonatomic, copy) NSArray<YNDemoListDataSourceItem *> *dataSource;

- (void)didSelectItem:(YNDemoListDataSourceItem *)item;

@end

NS_ASSUME_NONNULL_END

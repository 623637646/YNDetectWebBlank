//
//  YNDemoWebViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebViewController.h"
#import "YNDemoWebNormalViewController.h"
#import "YNDemoWebBlankViewController.h"
#import "YNDemoWebTimeOutViewController.h"
#import "YNDemoWebBlankWhenBackViewController.h"
#import "YNDemoWebCoveredViewController.h"
#import "YNDemoWebHasSubviewsViewController.h"
#import "YNDemoWebComplexViewController.h"

@interface YNDemoWebViewController ()

@end

@implementation YNDemoWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"WKWebView";
    self.dataSource = @[
                        [YNDemoListDataSourceItem itemWithTitle:@"Normal" obj:YNDemoWebNormalViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank" obj:YNDemoWebBlankViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"TimeOut" obj:YNDemoWebTimeOutViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank when back" obj:YNDemoWebBlankWhenBackViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank when Covered by other views" obj:YNDemoWebCoveredViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank when has subviews" obj:YNDemoWebHasSubviewsViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"A complex page" obj:YNDemoWebComplexViewController.class]
                        ];
}

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    UIViewController *vc = [[item.obj alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

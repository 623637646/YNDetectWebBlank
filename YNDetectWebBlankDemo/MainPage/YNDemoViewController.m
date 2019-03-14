//
//  YNDemoViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNDemoViewController.h"
#import "YNDemoUIWebViewController.h"
#import "YNDemoWKWebViewController.h"

@implementation YNDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"YNDetectWebBlank Demo";
    self.dataSource = @[
                        [YNDemoListDataSourceItem itemWithTitle:@"UIWebView Demos" obj:YNDemoUIWebViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"WKWebView Demos" obj:YNDemoWKWebViewController.class],
                        ];
}

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    UIViewController *vc = [[item.obj alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  YNDemoWKWebViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWKWebViewController.h"
#import "YNDemoWKWebNormalViewController.h"

@interface YNDemoWKWebViewController ()

@end

@implementation YNDemoWKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"WKWebView";
    self.dataSource = @[
                        [YNDemoListDataSourceItem itemWithTitle:@"Normal" obj:YNDemoWKWebNormalViewController.class]
                        ];
}

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    UIViewController *vc = [[item.obj alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

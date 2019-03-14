//
//  YNDemoUIWebViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoUIWebViewController.h"
#import "YNDemoUIWebNormalViewController.h"
#import "YNDemoUIWebBlankViewController.h"
#import "YNDemoUIWebTimeOutViewController.h"

@interface YNDemoUIWebViewController ()

@end

@implementation YNDemoUIWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"UIWebView";
    self.dataSource = @[
                        [YNDemoListDataSourceItem itemWithTitle:@"Normal" obj:YNDemoUIWebNormalViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank" obj:YNDemoUIWebBlankViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"TimeOut" obj:YNDemoUIWebTimeOutViewController.class]
                        ];
}

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    UIViewController *vc = [[item.obj alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

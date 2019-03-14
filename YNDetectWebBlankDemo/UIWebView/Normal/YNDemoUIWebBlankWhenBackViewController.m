//
//  YNDemoUIWebBlankWhenBackViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoUIWebBlankWhenBackViewController.h"
#import "YNDemoServerConfig.h"

@implementation YNDemoUIWebBlankWhenBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/normal", [YNDemoServerConfig sharedInstance].serverURL]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Next page" style:UIBarButtonItemStylePlain target:self action:@selector(didTapRightItem:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeAllSubviewsForWebView];
}

- (void)didTapRightItem:(id)sender
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

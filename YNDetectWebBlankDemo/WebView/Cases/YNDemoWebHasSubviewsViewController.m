//
//  YNDemoWebHasSubviewsViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 21/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebHasSubviewsViewController.h"
#import "YNDemoServerConfig.h"

@interface YNDemoWebHasSubviewsViewController ()

@end

@implementation YNDemoWebHasSubviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/blank", [YNDemoServerConfig sharedInstance].serverURL]];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    subView.backgroundColor = [UIColor redColor];
    subView.center = self.view.center;
    [self.webView addSubview:subView];
}

@end

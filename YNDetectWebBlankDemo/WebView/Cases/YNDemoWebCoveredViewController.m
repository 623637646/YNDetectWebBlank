//
//  YNDemoWebCoveredViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 21/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebCoveredViewController.h"
#import "YNDemoServerConfig.h"

@interface YNDemoWebCoveredViewController ()

@end

@implementation YNDemoWebCoveredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/blank", [YNDemoServerConfig sharedInstance].serverURL]];
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    coverView.backgroundColor = [UIColor blueColor];
    coverView.center = self.view.center;
    [self.view addSubview:coverView];
}

@end

//
//  YNDemoWKWebComplexViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 21/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWKWebComplexViewController.h"

@interface YNDemoWKWebComplexViewController ()

@end

@implementation YNDemoWKWebComplexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:@"https://www.google.com/search?q=%E7%BE%8E%E5%A5%B3&newwindow=1&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjHz5PZipPhAhVjk-AKHSxrA68Q_AUIDigB&biw=1680&bih=916&dpr=2"];
}

@end

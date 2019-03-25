//
//  YNDemoWebComplexViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 21/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebComplexViewController.h"

@interface YNDemoWebComplexViewController ()

@end

@implementation YNDemoWebComplexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:@"https://www.google.com/search?q=%E7%BE%8E%E5%A5%B3&newwindow=1&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjHz5PZipPhAhVjk-AKHSxrA68Q_AUIDigB&biw=1680&bih=916&dpr=2"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Next page" style:UIBarButtonItemStylePlain target:self action:@selector(didTapRightItem:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didTapRightItem:(id)sender
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

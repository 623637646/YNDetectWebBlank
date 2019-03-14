//
//  YNDemoListViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 22/2/19.
//  Copyright © 2019 Shopee. All rights reserved.
//

#import "YNDemoListViewController.h"
#import "YNDemoTitleCollectionViewCell.h"

@implementation YNDemoListDataSourceItem

+(YNDemoListDataSourceItem*)itemWithTitle:(NSString *)title obj:(id)obj
{
    YNDemoListDataSourceItem *item = [[YNDemoListDataSourceItem alloc] init];
    item.title = title;
    item.obj = obj;
    return item;
}

@end

@interface YNDemoListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation YNDemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 44);
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:YNDemoTitleCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoTitleCollectionViewCell description]];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNDemoListDataSourceItem *item = [self.dataSource objectAtIndex:indexPath.row];
    YNDemoTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoTitleCollectionViewCell description] forIndexPath:indexPath];
    cell.title = item.title;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNDemoListDataSourceItem *item = [self.dataSource objectAtIndex:indexPath.row];
    [self didSelectItem:item];
}

#pragma mark - public

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    
}

@end

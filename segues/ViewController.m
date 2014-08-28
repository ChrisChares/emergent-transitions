//
//  ViewController.m
//  segues
//
//  Created by Chris on 8/25/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "ViewController.h"
#import "CCTransitioningDelegate.h"
#import "SecondViewController.h"
#import "ImageCell.h"

@interface ViewController ()


@property CCTransitioningDelegate *transitioningDelegate;

@property NSArray *content;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _content = @[@"batman", @"archer", @"comic", @"puppies", @"lamp"];
    [self configureCollectionViewForTraitCollection:self.traitCollection];
    _transitioningDelegate = [CCTransitioningDelegate new];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.content.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.content[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    SecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
    
    vc.title = _content[indexPath.row];
    
    _transitioningDelegate.animatedView = cell.imageView;
    
    vc.transitioningDelegate = _transitioningDelegate;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];

}


- (IBAction)imageTapped:(UITapGestureRecognizer *)sender {
    
    SecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];

    _transitioningDelegate.animatedView = sender.view;

    vc.transitioningDelegate = _transitioningDelegate;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}


- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self configureCollectionViewForTraitCollection:newCollection];
    } completion:NULL];
}


- (void)configureCollectionViewForTraitCollection:(UITraitCollection *)newCollection
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    UICollectionViewScrollDirection newDirection;
    
    if ( newCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular ) {
        newDirection = UICollectionViewScrollDirectionVertical;
    } else {
        newDirection = UICollectionViewScrollDirectionHorizontal;
    }
    flowLayout.scrollDirection = newDirection;


}
@end

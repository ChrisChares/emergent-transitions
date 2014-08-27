//
//  MapViewController.m
//  segues
//
//  Created by Chris on 8/26/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "MapViewController.h"
#import "CCTransitioningDelegate.h"

@interface MapViewController()

@property CCTransitioningDelegate *transitioningDelegate;

@end


@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _transitioningDelegate = [[CCTransitioningDelegate alloc] init];
}


- (IBAction)zoom:(id)sender {
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;

    _transitioningDelegate.animatedView = self.mapViewController;
//    _transitioningDelegate.baseViewUserInteractionEnabled = YES;
    
    vc.transitioningDelegate = _transitioningDelegate;
    
    
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

@end

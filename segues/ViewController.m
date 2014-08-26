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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property CCTransitioningDelegate *transitioningDelegate;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _transitioningDelegate = [CCTransitioningDelegate new];
    
    self.view.backgroundColor = [UIColor redColor];
}


- (IBAction)imageTapped:(UITapGestureRecognizer *)sender {
    
    SecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];

    _transitioningDelegate.animatedView = self.imageView;

    vc.transitioningDelegate = _transitioningDelegate;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

@end

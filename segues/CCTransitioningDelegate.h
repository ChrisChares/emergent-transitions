//
//  CCTransitioningDelegate.h
//  segues
//
//  Created by Chris on 8/25/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

@import UIKit;

@interface CCTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) UIView *animatedView;

@property BOOL baseViewUserInteractionEnabled;

@property UIPercentDrivenInteractiveTransition *interactionController;

@end

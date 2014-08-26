//
//  CCTransitioningDelegate.m
//  segues
//
//  Created by Chris on 8/25/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "CCTransitioningDelegate.h"
#import "CCAnimator.h"
#import "CCPresentationController.h"
#import "CCInteractiveTransitioning.h"

@implementation CCTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    CCAnimator *animator = [CCAnimator new];
    animator.isPresenting = YES;
    return animator;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    CCAnimator *animator = [CCAnimator new];
    animator.isPresenting = NO;
    return animator;

}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactionController;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    CCPresentationController *presVC = [[CCPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presVC.animatedView = self.animatedView;
    
    return presVC;
    
}


@end

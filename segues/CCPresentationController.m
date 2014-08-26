//
//  CCPresentationController.m
//  segues
//
//  Created by Chris on 8/25/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "CCPresentationController.h"
#import <pop/POP.h>
#import "UIView+Explore.h"
#import "CCTransitioningDelegate.h"

#define logRect(z) NSLog(@"{%f, %f, %f, %f}", z.origin.x, z.origin.y, z.size.width, z.size.height)

#define TRANSLATION_THRESHOLD 100

@interface CCPresentationController()

@property UIView *snapshotView;

@property (weak, nonatomic) UIView *animatedViewSuperView;
@property CGRect animatedViewBaseFrame;

@property UITapGestureRecognizer *tapGestureRecognizer;
@property UIPanGestureRecognizer *panGestureRecognizer;

@end


@implementation CCPresentationController


- (void)presentationTransitionWillBegin
{
    
    self.presentedView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.presentedView];
    
    
    self.animatedViewBaseFrame = self.animatedView.frame;
    self.animatedViewSuperView = self.animatedView.superview;
    
    CGRect newFrame = [self.containerView convertRect:self.animatedViewBaseFrame fromView:self.animatedView.superview];
    
    [self.animatedView removeFromSuperview];
    self.animatedView.frame = newFrame;
    [self.containerView insertSubview:self.animatedView belowSubview:self.presentedView];

    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGRect contextBounds = [[context containerView] bounds];
        frameAnimation.toValue = [NSValue valueWithCGRect:contextBounds];
        frameAnimation.velocity = [NSValue valueWithCGRect:CGRectZero];
        [self.animatedView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];

}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if ( completed ) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewTapped:)];
        [self.presentedView addGestureRecognizer:_tapGestureRecognizer];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewPanned:)];
        [self.presentedView addGestureRecognizer:_panGestureRecognizer];
    }
}


- (void)dismissalTransitionWillBegin
{
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
            
            self.animatedView.frame = self.animatedViewBaseFrame;
            
        } completion:^(BOOL finished) {
            
        }];
//        POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//        frameAnimation.toValue = [NSValue valueWithCGRect:self.animatedViewBaseFrame];
//        frameAnimation.velocity = [NSValue valueWithCGRect:CGRectZero];
//        [frameAnimation setCompletionBlock:^(POPAnimation *animation, BOOL completed) {
//            
//        }];
//        [self.animatedView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];

 
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if ( completed ) {
        
        [self.animatedView removeFromSuperview];
        [self.animatedViewSuperView addSubview:self.animatedView];
        [self.animatedView setFrame:self.animatedViewBaseFrame];
        
        if ( self.presentedView ) {
            [self.presentedView removeGestureRecognizer:_tapGestureRecognizer];
            [self.presentedView removeGestureRecognizer:_panGestureRecognizer];
            [self.presentedView removeFromSuperview];
        }
    }
    
    


}


- (CGRect)frameOfPresentedViewInContainerView {
    return self.containerView.bounds;
}

- (void)containerViewDidLayoutSubviews
{
    self.animatedView.frame = self.animatedViewBaseFrame;
    
    [super containerViewDidLayoutSubviews];

}


- (void)presentedViewTapped:(UITapGestureRecognizer *)gesture
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)presentedViewPanned:(UIPanGestureRecognizer *)gesture
{
//    CGPoint location = [gesture locationInView:self.presentedView];
    CGPoint translation = [gesture translationInView:self.presentedView];
    
    CCTransitioningDelegate *transitioningDelegate = self.presentedViewController.transitioningDelegate;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
//        if (location.y >  CGRectGetMidY(self.presentedView.bounds)) {
            transitioningDelegate.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
//        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat d = ABS((translation.y / (CGRectGetHeight(self.presentedView.bounds) / 2) ));
        NSLog(@"%f", d);
        [transitioningDelegate.interactionController updateInteractiveTransition:d];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [transitioningDelegate.interactionController finishInteractiveTransition];

        
        if (ABS(translation.y) > TRANSLATION_THRESHOLD) {
            [transitioningDelegate.interactionController finishInteractiveTransition];
        } else {
            [transitioningDelegate.interactionController cancelInteractiveTransition];
        }
        transitioningDelegate.interactionController = nil;
    }
}

@end

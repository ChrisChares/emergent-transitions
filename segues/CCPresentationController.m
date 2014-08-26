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


#define logRect(z) NSLog(@"{%f, %f, %f, %f}", z.origin.x, z.origin.y, z.size.width, z.size.height)
@interface CCPresentationController()

@property UIView *snapshotView;

@property (weak, nonatomic) UIView *animatedViewSuperView;
@property CGRect animatedViewBaseFrame;

@property UIGestureRecognizer *tapGestureRecognizer;

@end


@implementation CCPresentationController


- (void)presentationTransitionWillBegin
{
//    self.snapshotView = [self.presentingViewController.view snapshotViewAfterScreenUpdates:YES];
//    self.snapshotView.frame = self.containerView.bounds;
//    [self.containerView insertSubview:self.snapshotView atIndex:0];
    
    self.animatedViewBaseFrame = self.animatedView.frame;
    self.animatedViewSuperView = self.animatedView.superview;
    
    CGRect newFrame = [self.containerView convertRect:self.animatedViewBaseFrame fromView:self.animatedView.superview];
    
    [self.animatedView removeFromSuperview];
    self.animatedView.frame = newFrame;
    [self.containerView addSubview:self.animatedView];

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
    }
}


- (void)dismissalTransitionWillBegin
{
    POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    CGRect contextBounds = [[context containerView] bounds];
    frameAnimation.toValue = [NSValue valueWithCGRect:self.animatedViewBaseFrame];
    frameAnimation.velocity = [NSValue valueWithCGRect:CGRectZero];
    [frameAnimation setCompletionBlock:^(POPAnimation *animation, BOOL completed) {

    }];
    [self.animatedView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    [self.animatedView removeFromSuperview];
    [self.animatedViewSuperView addSubview:self.animatedView];
    self.animatedView.frame = self.animatedViewBaseFrame;

}


- (CGRect)frameOfPresentedViewInContainerView {
    return self.containerView.bounds;
}

- (void)containerViewWillLayoutSubviews
{
//    self.animatedView.frame = self.animatedViewBaseFrame;
    self.animatedView.center = CGPointMake(100, 100);

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

@end

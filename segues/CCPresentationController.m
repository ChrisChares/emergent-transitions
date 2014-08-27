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
#import <Tweaks/FBTweakInline.h>

#define logRect(z) NSLog(@"{%f, %f, %f, %f}", z.origin.x, z.origin.y, z.size.width, z.size.height)

#define TRANSLATION_THRESHOLD .25

@interface CCPresentationController()

@property (weak, nonatomic) UIView *animatedViewSuperView;
@property CGRect animatedViewBaseFrame;
@property UIView *animatedView;
@property UITapGestureRecognizer *tapGestureRecognizer;
@property UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, readonly) CCTransitioningDelegate *transitioningDelegate;
@property UIView *dimmingView;

@end

@implementation CCPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if(self) {
        self.dimmingView = [UIView new];
        self.dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    }
    return self;
}

- (void)presentationTransitionWillBegin
{
    self.animatedView = self.transitioningDelegate.animatedView;
    
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0;
    [self.containerView addSubview:self.dimmingView];
    
    self.presentedView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.presentedView];
    
    [self.animatedView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.animatedViewBaseFrame = self.animatedView.frame;
    self.animatedViewSuperView = self.animatedView.superview;
    
    CGRect newFrame = [self.containerView convertRect:self.animatedViewBaseFrame fromView:self.animatedView.superview];
    
    [self.animatedView removeFromSuperview];
    self.animatedView.frame = newFrame;
    [self.containerView insertSubview:self.animatedView belowSubview:self.presentedView];

    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.dimmingView.alpha = 1.0;
        
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
    BOOL baseViewUserInteractionEnabled = self.transitioningDelegate.baseViewUserInteractionEnabled;
    
    if ( completed && ! baseViewUserInteractionEnabled ) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewTapped:)];
        [self.presentedView addGestureRecognizer:_tapGestureRecognizer];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewPanned:)];
        [self.presentedView addGestureRecognizer:_panGestureRecognizer];
    }
}


- (void)dismissalTransitionWillBegin
{
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.animatedView.frame = [self.containerView convertRect:self.animatedViewBaseFrame fromView:self.animatedViewSuperView];
        self.dimmingView.alpha = 0.0;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];

 
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if ( completed ) {
        
        [self.dimmingView removeFromSuperview];
        [self.animatedView removeFromSuperview];
        [self.animatedView setFrame:self.animatedViewBaseFrame];
        [self.animatedView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.animatedViewSuperView addSubview:self.animatedView];
        
        if ( self.presentedView ) {
            [self.presentedView removeGestureRecognizer:_tapGestureRecognizer];
            _tapGestureRecognizer = nil;
            
            [self.presentedView removeGestureRecognizer:_panGestureRecognizer];
            _tapGestureRecognizer = nil;
            
            [self.presentedView removeFromSuperview];
        }
    } else {
        
        NSLog(@"failed to complete yo");
    }
}


- (CGRect)frameOfPresentedViewInContainerView {
    return self.containerView.bounds;
}

- (void)containerViewDidLayoutSubviews
{
    self.animatedView.frame = [self.containerView convertRect:self.animatedViewBaseFrame fromView:self.animatedViewSuperView];
}


- (void)presentedViewTapped:(UITapGestureRecognizer *)gesture
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)presentedViewPanned:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.presentedView];
    
    CGFloat scale = FBTweakValue(@"Transition", @"Dismiss", @"Scale", 1, 0, 10);
    
    CGFloat percentage = ABS(translation.y / ( CGRectGetHeight(self.presentedView.bounds) / scale) );
    percentage = MIN(percentage, 1.0);

    if (gesture.state == UIGestureRecognizerStateBegan) {
            self.transitioningDelegate.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        

        NSLog(@"%f", percentage);
        [self.transitioningDelegate.interactionController updateInteractiveTransition:percentage];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self.transitioningDelegate.interactionController finishInteractiveTransition];
        self.transitioningDelegate.interactionController = nil;
    }
}



- (CCTransitioningDelegate *)transitioningDelegate
{
    return self.presentedViewController.transitioningDelegate;
}

@end

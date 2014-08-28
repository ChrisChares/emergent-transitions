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

#define TRANSLATION_THRESHOLD .10

@interface CCPresentationController()

@property (weak, nonatomic) UIView *animatedViewSuperView;
@property CGRect animatedViewBaseFrame;
@property UIView *animatedView;
@property UITapGestureRecognizer *tapGestureRecognizer;
@property UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, readonly) CCTransitioningDelegate *transitioningDelegate;
@property UIView *dimmingView;
@property BOOL presented;

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

#pragma mark - Presentation Lifecycle

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
        
//        Using POP until I can figure out how to take this out
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
    
    
    if ( completed ) {
        self.presented = YES;

        if ( ! baseViewUserInteractionEnabled ) {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewTapped:)];
            [self.presentedView addGestureRecognizer:_tapGestureRecognizer];
            
            _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewPanned:)];
            [self.presentedView addGestureRecognizer:_panGestureRecognizer];
        }

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
//  As far as I can tell, UIPresentationController is bugged,
//  completed is NEVER false.  Even when the interaction transition is cancelled,
//  which would seem to be the whole reason for the parameter.
//  Cancelling the interactive transition is disabled at the moment
    
    if ( completed ) {
        self.presented = NO;

        
        [self.dimmingView removeFromSuperview];
        [self.animatedView removeFromSuperview];
        [self.animatedView setFrame:self.animatedViewBaseFrame];
        [self.animatedView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.animatedViewSuperView addSubview:self.animatedView];
        self.animatedView = nil;
        
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


#pragma mark - Layout

- (CGRect)frameOfPresentedViewInContainerView {
    return self.containerView.bounds;
}

- (void)containerViewDidLayoutSubviews
{

    if ( ! self.presented ) {
        //    I'm not entirely sure why this is necessary.  Without this line the view will relocate to {0,0}
        //    when added to the containerView, before starting the presentation animation.  Possibly due to a lack of autolayout
        //    constraints?
        self.animatedView.frame = [self.containerView convertRect:self.animatedViewBaseFrame fromView:self.animatedViewSuperView];
    } else {
        self.animatedView.frame = [self frameOfPresentedViewInContainerView];
    }
}

#pragma mark - UIGestureRecognizers

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
        
//        Disabled for UIPresentationController bug
//        if ( percentage > TRANSLATION_THRESHOLD ) {
//            NSLog(@"Interaction completed transition");
//            [self.transitioningDelegate.interactionController finishInteractiveTransition];
//            self.transitioningDelegate.interactionController = nil;
//        } else {
//            [self.transitioningDelegate.interactionController cancelInteractiveTransition];
//            NSLog(@"Interaction failed to complete transition");
//
//        }
        
        

    }
}



#pragma mark - Properties

- (CCTransitioningDelegate *)transitioningDelegate
{
    return self.presentedViewController.transitioningDelegate;
}

- (BOOL)shouldPresentInFullscreen
{
    return YES;
}

- (BOOL)shouldRemovePresentersView
{
    return NO;
}

@end

//
//  CCAnimator.m
//  segues
//
//  Created by Chris on 8/25/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "CCAnimator.h"
#import <pop/POP.h>
#import "UIView+Explore.h"
#import <Tweaks/FBTweakInline.h>

@implementation CCAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if ( self.isPresenting ) {
        return 0.5;
    } else {
        return 0.5;
    }
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    if (self.isPresenting) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.alpha = 0.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.25
                            options:0
                         animations:^{
            
                             toView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
//        
//        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//        alphaAnimation.toValue = @(1.0);
//        alphaAnimation.duration = [self transitionDuration:transitionContext];
//        [alphaAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//            [transitionContext completeTransition:YES];
//        }];
//        [toView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    }
    else {
        
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
 
        CGFloat damping = FBTweakValue(@"Transition", @"Dismissal", @"Damping", 0.6, 0.0, 1.0);
        CGFloat velocity = FBTweakValue(@"Transition", @"Dismissal", @"Velocity", 0.8, 0.0, 1.0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            
                             presentedView.alpha = 0.0;

        }
                         completion:^(BOOL finished) {
            
                             [transitionContext completeTransition:YES];

        }];
        
    
//        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//        alphaAnimation.toValue = @(0.0);
//        alphaAnimation.duration = [self transitionDuration:transitionContext];
//        [alphaAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//            [transitionContext completeTransition:YES];
//            [presentedView removeFromSuperview];
//        }];
//        [presentedView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
        
    }
}

//- (void)animationEnded:(BOOL)transitionCompleted
//{
//    
//}

@end

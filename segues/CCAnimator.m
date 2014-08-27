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
 
        
        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        alphaAnimation.toValue = @(1.0);
        alphaAnimation.duration = [self transitionDuration:transitionContext];
        [alphaAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        [toView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    }
    else {
        
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
 
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.8
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

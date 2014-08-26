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
        return 0.0;
    }
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    if (self.isPresenting) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame = [[transitionContext containerView] bounds];
        toView.alpha = 0.0;
        [[transitionContext containerView] addSubview:toView];
        
        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        alphaAnimation.toValue = @(1.0);
        [alphaAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        [toView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    }
    else {
        
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        alphaAnimation.toValue = @(0.0);
        [alphaAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            [transitionContext completeTransition:YES];
            [presentedView removeFromSuperview];
        }];
        [presentedView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
        
    }
    
    

}

@end

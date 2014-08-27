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

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return FBTweakValue(@"Transition", @"Both", @"Duration", 0.5, 0.0, 3.0);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting)
    {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.alpha = 0.0;
        
        CGFloat delay = FBTweakValue(@"Transition", @"Presentation", @"Chrome Fade Delay", 0.2, 0.0, 1.0);
        [UIView animateWithDuration:0.4
                              delay:delay
                            options:0
                         animations:^{
            
                             toView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else
    {
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
    }
}

@end

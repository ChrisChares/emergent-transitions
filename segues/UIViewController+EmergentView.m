//
//  UIViewController+EmergentView.m
//  segues
//
//  Created by Chris Chares on 8/28/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "UIViewController+EmergentView.h"
#import "CCTransitioningDelegate.h"

@implementation UIViewController (EmergentView)

- (UIView *)emergentView
{
    CCTransitioningDelegate *delegate = (CCTransitioningDelegate *)self.transitioningDelegate;
    return delegate.animatedView;
}


@end
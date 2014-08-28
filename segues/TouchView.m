//
//  TouchView.m
//  segues
//
//  Created by Chris Chares on 8/28/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"I got touched bitch");
    return [super hitTest:point withEvent:event];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

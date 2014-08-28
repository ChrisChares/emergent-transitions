//
//  UIView+Explore.m
//  segues
//
//  Created by Chris on 8/26/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "UIView+Explore.h"

@implementation UIView (Explore)

- (void)logSubviews
{
    [self logSubviews:self indentLevel:0];
}

- (void)logSubviews:(UIView *)view indentLevel:(int)level
{
    NSLog(@"%@%@", [self indentStringForLevel:level], view);
    if ( view && view.subviews ) {
        for ( UIView *_view in view.subviews ) {
            [self logSubviews:_view indentLevel:level+1];
        }
    }
}

- (NSString *)indentStringForLevel:(int)level
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    for (int i=0; i<level; i++) {
        [string appendString:@"  "];
    }
    return string;
}

@end
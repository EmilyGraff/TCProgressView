//
//  TCProgressView.m
//  TCProgressViewExample
//
//  Created by Thibault Charbonnier on 25/04/13.
//  Copyright (c) 2013 thibaultCha. All rights reserved.
//

#define EPSILON 0.00001f

#import "TCProgressView.h"

@interface TCProgressView ()
@property (nonatomic, retain) CALayer *progressLayer;
@property (nonatomic, assign) CALayer *backgroundLayer;
@end

@implementation TCProgressView


#pragma mark - Init


- (id)initWithFrame:(CGRect)frame style:(TCProgressViewStyle)style
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self setBackgroundLayer:self.layer];
        
        _progressLayer = [CALayer layer];
        [self.progressLayer setFrame:self.backgroundLayer.bounds];
        [self.backgroundLayer addSublayer:self.progressLayer];
        
        [self setStyle:style];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
              style:(TCProgressViewStyle)style
    backgroundColor:(UIColor *)backgroundColor
      progressColor:(UIColor *)progressColor
{
    self = [self initWithFrame:frame style:style];
    if (self) {
        [self setBackgroundColor:backgroundColor];
        [self setProgressColor:progressColor];
    }
    return self;
}


#pragma mark- Setters



- (void)setRounded:(BOOL)rounded
{
    _rounded = rounded;
    
    if (rounded) {
        self.backgroundLayer.cornerRadius = self.cornersRadius;
        self.progressLayer.cornerRadius = self.cornersRadius;
        self.backgroundLayer.masksToBounds = YES;
        self.progressLayer.masksToBounds = YES;
    }
    else {
        self.backgroundLayer.cornerRadius = 0;
        self.progressLayer.cornerRadius = 0;
        self.backgroundLayer.masksToBounds = NO;
        self.progressLayer.masksToBounds = NO;
    }
}

- (void)setCornersRadius:(CGFloat)cornersRadius
{
    _cornersRadius = cornersRadius;
    if (self.rounded) { // to avoid calling setRounded
        [self setRounded:self.rounded];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self.backgroundLayer setBackgroundColor:backgroundColor.CGColor];
}

- (void)setProgressColor:(UIColor *)progressViewColor
{
    [self.progressLayer setBackgroundColor:progressViewColor.CGColor];
}

- (void)setStyle:(TCProgressViewStyle)style
{
    _style = style;
    
    CGRect newFrame = self.backgroundLayer.bounds;
    if (style == TCProgressViewStyleFromLeftToRight) {
        newFrame.origin.x = self.backgroundLayer.bounds.origin.x;
    }
    else if (style == TCProgressViewStyleFromCenter) {
        newFrame.origin.x = self.backgroundLayer.bounds.size.width/2;
    }
    
    [self.progressLayer setFrame:newFrame];
    [self setProgress:self.progress];
}

- (void)setProgress:(float)progress
{
    if (0.0f - EPSILON < progress && progress < 1.0f + EPSILON) {
        _progress = progress;
        
        CGRect oldFrame = self.backgroundLayer.bounds;
        CGRect newFrame = oldFrame;
        newFrame.size.width = self.backgroundLayer.bounds.size.width * progress;
        
        if (self.style == TCProgressViewStyleFromLeftToRight) {
            
        }
        else if (self.style == TCProgressViewStyleFromCenter) {
            newFrame.origin.x = self.backgroundLayer.bounds.size.width/2 - newFrame.size.width/2;
        }
        
        [self.progressLayer setFrame:newFrame];
        CABasicAnimation *progressAnim = [CABasicAnimation animationWithKeyPath:@"progress"];
        progressAnim.fromValue = [NSValue valueWithCGRect:oldFrame];
        progressAnim.toValue = [NSValue valueWithCGRect:newFrame];
        
        [self.progressLayer addAnimation:progressAnim forKey:@"progress"];
    }
}

@end

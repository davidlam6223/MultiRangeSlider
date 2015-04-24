//
//  MultiRangeSlider.m
//  MultiRangeSlider
//
//  Created by Zensis on 16/4/15.
//  Copyright (c) 2015 David. All rights reserved.

#import "MultiRangeSlider.h"
#import <QuartzCore/QuartzCore.h>


@implementation MultiRangeSlider{
    NSMutableArray * _thumbs;
    int _touchingIndex;
    UIView * _touchingThumb;
    UIView * _minThumb;
    UIView * _maxThumb;
    UIView * _nextThumb;
    UIView * _previousThumb;
    UIView * _track;
    UIView * _trackBackground;
    int padding;
    float _interval;
}


- (id)initWithFrame:(CGRect)frame numberOfThumb:(int)numberOfThumb
{
    self = [super initWithFrame:frame];
    if (self) {
        padding = 20;
        self.numberOfThumbs = numberOfThumb;
        self.trackWidth = 10;
        self.minimumValue = 0;
        self.maximumValue = 100;
        self.thumbImage = [UIImage imageNamed:@"handle.png"];
        _trackBackground = [[UIView alloc] initWithFrame:CGRectMake(padding, (self.frame.size.height-self.trackWidth)/2, -2*padding+self.frame.size.width, self.trackWidth)];
        _trackBackground.backgroundColor = [UIColor blueColor];
        _trackBackground.layer.cornerRadius = self.trackWidth/2;
        _trackBackground.layer.masksToBounds = YES;
        _trackBackground.userInteractionEnabled = NO;
        [self addSubview:_trackBackground];
        _interval = (-2*padding+self.frame.size.width)/(float)(self.maximumValue-self.minimumValue);
        _track = [[UIView alloc] initWithFrame:CGRectMake(padding, (self.frame.size.height-self.trackWidth)/2, 123, self.trackWidth)];
        _track.backgroundColor = [UIColor purpleColor];
        _track.layer.cornerRadius = self.trackWidth/2;
        _track.layer.masksToBounds = YES;
        _track.userInteractionEnabled = NO;
        [self addSubview:_track];
        _thumbs = [NSMutableArray array];
        for(int i=1; i<self.numberOfThumbs+1; i++){
            UIImageView * thumb = [[UIImageView alloc]initWithImage:self.thumbImage highlightedImage:[UIImage imageNamed:@"handle-hover"]];
            thumb.center = CGPointMake(padding+((self.maximumValue-self.minimumValue)*i/self.numberOfThumbs)*_interval, self.frame.size.height/2);
            [self addSubview:thumb];
            [_thumbs addObject:thumb];
        }
        
        _minThumb = [_thumbs objectAtIndex:0];
        _maxThumb = [_thumbs objectAtIndex:self.numberOfThumbs-1];
        [self updateTrackHighlight];
    }
    
    return self;
}


-(void)updateTrackHighlight{
    _track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

-(void)movehandle:(CGPoint)lastPoint{
    if(_touchingIndex-1 >= 0 &&[self getValueFromX:lastPoint.x] <= [self getValueWithIndex:_touchingIndex-1]){
        lastPoint.x = [self getXFromValue:[self getValueWithIndex:_touchingIndex-1]+1];
    }else if(_touchingIndex+1 <= self.numberOfThumbs-1 && [self getValueFromX:lastPoint.x] >= [self getValueWithIndex:_touchingIndex+1]){
        lastPoint.x = [self getXFromValue:[self getValueWithIndex:_touchingIndex+1]-1];
    }else if(lastPoint.x <= padding){
        lastPoint.x = padding;
    }else if(lastPoint.x >= -padding+self.frame.size.width){
        lastPoint.x = -padding+self.frame.size.width;
    }else{
        lastPoint.x = [self getXFromValue:[self getValueFromX:lastPoint.x]];
    }
    _touchingThumb.center = CGPointMake(lastPoint.x, _touchingThumb.center.y);
    
    if([_touchingThumb isEqual:_minThumb] || [_touchingThumb isEqual:_maxThumb])
        [self updateTrackHighlight];
    
    if(self.delegate != nil)
        [self.delegate thumb:_touchingIndex movedTo:[self getValueWithIndex:_touchingIndex]];
}


#pragma mark - UIControl Override -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint touchPoint = [touch locationInView:self];
    for(int i=self.numberOfThumbs-1; i>=0; i--){
        UIView * thumb = [_thumbs objectAtIndex:i];
        if(CGRectContainsPoint(thumb.frame, touchPoint)){
            [self setUpTouchingThumb:i];
            return YES;
        }
    }
    _touchingThumb = nil;
    return NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint = [touch locationInView:self];
    [self movehandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    _touchingThumb = nil;
    [self setNeedsDisplay];
}

-(void) setUpTouchingThumb: (int)index{
    _touchingThumb = [_thumbs objectAtIndex:index];
    _touchingIndex = index;
    if(index+1 < self.numberOfThumbs){
        _nextThumb = [_thumbs objectAtIndex:index+1];
    }
    else{
        _nextThumb = nil;
    }
    if(index-1 >= 0){
        _previousThumb = [_thumbs objectAtIndex:index-1];
    }
    else{
        _previousThumb = nil;
    }
}

- (int)getValueFromX:(float)x{
    if(x == padding) return self.minimumValue;
    else if(x == self.frame.size.width - 2*padding) return self.maximumValue;
    else return round((x-padding)/_interval);
}

- (int)getXFromValue:(int)value{
    return round(value*_interval+padding);
}

#pragma mark - public method
- (void)setThumb:(int)index To:(int)value{
    [self setUpTouchingThumb: index];
    [self movehandle: CGPointMake([self getXFromValue:value], _touchingThumb.center.y)];
    _touchingThumb = nil;
}

- (int)getValueWithIndex:(int)index{
    if(index < 0){
        return _minimumValue;
    }
    else if(index >=self.numberOfThumbs){
        return _maximumValue;
    }
    UIView * thumb= [_thumbs objectAtIndex:index];
    return [self getValueFromX:thumb.center.x];
}



@end

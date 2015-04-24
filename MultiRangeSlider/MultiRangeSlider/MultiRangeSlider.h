//
//  MultiRangeSlider.h
//  MultiRangeSlider
//
//  Created by Zensis on 16/4/15.
//  Copyright (c) 2015 David. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MultiRangeSliderDelegate <NSObject>

@optional
- (void)thumb:(int)index movedTo:(int)value;

@end

@interface MultiRangeSlider : UIControl

- (id)initWithFrame:(CGRect)frame numberOfThumb:(int)numberOfThumb;
- (void)setThumb:(int)index To:(int)value;
- (int)getValueWithIndex:(int)index;

//TODO handle value <0 , >1000
@property(nonatomic) int minimumValue;
@property(nonatomic) int maximumValue;
@property int numberOfThumbs;
@property int trackWidth;
@property UIColor* trackBackgroundColor;
@property UIColor* trackColor;
@property UIImage* thumbImage;
@property (nonatomic, weak) id<MultiRangeSliderDelegate> delegate;

@end

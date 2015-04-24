//
//  ViewController.m
//  MultiRangeSlider
//
//  Created by Zensis on 16/4/15.
//  Copyright (c) 2015 David. All rights reserved.
//

#import "ViewController.h"
#import "MultiRangeSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MultiRangeSlider *slider=  [[MultiRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) numberOfThumb:3];
    slider.trackBackgroundColor = [UIColor lightGrayColor];
    slider.delegate = self;
    [self.view addSubview:slider];
    NSLog(@"index: %d, value: %d", 0, [slider getValueWithIndex:0]);
    NSLog(@"index: %d, value: %d", 1, [slider getValueWithIndex:1]);
    NSLog(@"index: %d, value: %d", 2, [slider getValueWithIndex:2]);
//    [slider setThumb:0 To:0];
//    [slider setThumb:1 To:30];
//    [slider setThumb:2 To:50];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)thumb:(int)index movedTo:(int)value{
    NSLog(@"index: %d, value: %d", index, value);
}

@end

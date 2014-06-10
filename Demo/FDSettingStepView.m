//
//  FDSettingStepView.m
//  Demo
//
//  Created by hulingzhi on 14-6-10.
//  Copyright (c) 2014年 hulingzhi. All rights reserved.
//

#import "FDSettingStepView.h"

@implementation FDSettingStepView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    CGRect aRect = CGRectMake(0, 0, 300, 400);
    [self.contentLabel setFrame:aRect];
    [self.contentLabel setCenter:self.center];
    [self.contentLabel setTextColor:[UIColor blackColor]];
    [self addSubview:self.contentLabel];
    [self.contentLabel setText:self.stepContentString];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

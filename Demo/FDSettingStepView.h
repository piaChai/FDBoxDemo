//
//  FDSettingStepView.h
//  Demo
//
//  Created by hulingzhi on 14-6-10.
//  Copyright (c) 2014年 hulingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSettingStepView : UIView
@property (nonatomic,assign) NSInteger currentStep;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) NSString *stepContentString;
@end

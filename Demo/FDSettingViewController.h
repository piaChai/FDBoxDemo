//
//  FDSettingViewController.h
//  Demo
//
//  Created by hulingzhi on 14-6-10.
//  Copyright (c) 2014年 hulingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SoundBoxSettingStep) {
    SoundBoxSettingStepOne,
    SoundBoxSettingStepTwo,
    SoundBoxSettingStepThree,
};



@interface FDSettingViewController : UIViewController
@property (assign, nonatomic) SoundBoxSettingStep currentStep;
@end

//
//  FDMusicBoxViewController.m
//  Demo
//
//  Created by hulingzhi on 14-6-10.
//  Copyright (c) 2014年 hulingzhi. All rights reserved.
//

#import "FDMusicBoxViewController.h"
#import "ANBlurredImageView.h"

@interface FDMusicBoxViewController ()
@property (nonatomic) ANBlurredImageView *imageView;
@property (nonatomic) UILabel *titleLabel;
@end

@implementation FDMusicBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView = [[ANBlurredImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    self.imageView.framesCount=5;
    self.imageView.blurAmount=0.5;
    self.imageView.image = [UIImage imageNamed:@"Default@2x~iphone.png"];

    
    
    [self performSelector:@selector(blur:) withObject:self afterDelay:2.0f];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)blur:(id)sender
{
    // Arbitrary blur color. Fades in alpha from 0 to selected alpha.
    [self.imageView setBlurTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    
    // Recalculate frames, or risk them not showing.
    // Call sparingly, best if everything is set before in viewDidLoad or earlier to prevent recalculation.
    [_imageView generateBlurFramesWithCompletion:^{
        [_imageView blurInAnimationWithDuration:0.25f];
    }];
    
    [self showTitleLabel];
}

- (void)showTitleLabel
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 320+44, 320, 44)];
    self.titleLabel.text = @"FreeDream";
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:20.0f];
    [self.view addSubview:self.titleLabel];
    
    [UIView beginAnimations:@"test" context:nil];
    //动画时长
    [UIView setAnimationDuration:1];
    /*
     *要进行动画设置的地方
     */
    
    self.titleLabel.frame=CGRectMake(0, 160, 320, 44);
    self.titleLabel.alpha=1;
    
    
    //动画结束
    [UIView commitAnimations];
    
    [self.imageView kenBurnsAnimate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

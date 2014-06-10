//
//  FDSettingViewController.m
//  Demo
//
//  Created by hulingzhi on 14-6-10.
//  Copyright (c) 2014年 hulingzhi. All rights reserved.
//

#import "FDSettingViewController.h"
#import "FDSettingStepView.h"




@interface FDSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong,nonatomic) FDSettingStepView *stepView;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)prevButtonPressed:(id)sender;

@end

@implementation FDSettingViewController

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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1];
    
    self.stepView = [[FDSettingStepView alloc]init];
    [self.stepView setFrame:self.view.bounds];
    [self.view addSubview:self.stepView];
    switch (self.currentStep) {
        case SoundBoxSettingStepOne:
            self.prevButton.hidden = YES;
            self.stepView.stepContentString = NSLocalizedString(@"Step1", nil);
            break;
        case SoundBoxSettingStepTwo:
            self.stepView.stepContentString = NSLocalizedString(@"Step2", nil);
            break;
        case SoundBoxSettingStepThree:
            self.nextButton.hidden = YES;
            self.stepView.stepContentString = NSLocalizedString(@"Step3", nil);
            break;
        default:
            break;
    }
    [self.stepView layoutSubviews];
    
    
    [self.prevButton setTitle:NSLocalizedString(@"Prev_Step", nil) forState:UIControlStateNormal];
    [self.prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.prevButton];
    
    NSString *str = NSLocalizedString(@"Next_Step", nil);
    NSLog(@"%@",str);
    [self.nextButton setTitle:NSLocalizedString(@"Next_Step", nil) forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender {
    
    FDSettingViewController *ctrl = [[FDSettingViewController alloc]initWithNibName:@"FDSettingViewController" bundle:nil];
    switch (self.currentStep) {
        case SoundBoxSettingStepOne:
            ctrl.currentStep = SoundBoxSettingStepTwo;
            break;
        case SoundBoxSettingStepTwo:
            ctrl.currentStep = SoundBoxSettingStepThree;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)prevButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

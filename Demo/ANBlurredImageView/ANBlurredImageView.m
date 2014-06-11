//
//  ANBlurredImageView.m
//
//  Created by Aaron Ng on 1/4/14.
//  Copyright (c) 2014 Delve. All rights reserved.
//

#import "ANBlurredImageView.h"
#import "UIImage+BoxBlur.h"

#define enlargeRatio 1.2
#define imageBufer 3

@implementation ANBlurredImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _baseImage = self.image;
    [self generateBlurFramesWithCompletion:^{}];
    
    // Defaults
    self.animationDuration = 0.1f;
    self.animationRepeatCount = 1;
}

// Downsamples the image so we avoid needing to blur a huge image.
-(UIImage*)downsampleImage{
    NSData *imageAsData = UIImageJPEGRepresentation(self.baseImage, 0.001);
    UIImage *downsampledImaged = [UIImage imageWithData:imageAsData];
    return downsampledImaged;
}

#pragma mark -
#pragma mark Animation Methods


-(void)generateBlurFramesWithCompletion:(void(^)())completion{
    
    // Reset our arrays. Generate our reverse array at the same time to save work later on blurOut.
    _framesArray = [[NSMutableArray alloc]init];
    _framesReverseArray = [[NSMutableArray alloc]init];
    
    // Our default number of frames, if none is provided.
    // Keep this low to prevent huge performance issues.
    NSInteger frames = 5;
    if (_framesCount)
        frames = _framesCount;
    
    if (!_blurTintColor)
        _blurTintColor = [UIColor clearColor];
    
    // Set our blur amount, 0-1 if availabile.
    // If < 0, reset to lowest blur. If > 1, reset to highest blur.
    CGFloat blurLevel = _blurAmount;
    if (_blurAmount < 0.0f || !_blurAmount)
        blurLevel = 0.1f;
    
    if (_blurAmount > 1.0f)
        blurLevel = 1.0f;
    
    UIImage *downsampledImage = [self downsampleImage];
    
    // Create our array, set each image as a spot in the array.
    for (int i = 0; i < frames; i++){
        UIImage *blurredImage = [downsampledImage drn_boxblurImageWithBlur:((CGFloat)i/frames)*blurLevel withTintColor:[_blurTintColor colorWithAlphaComponent:(CGFloat)i/frames * CGColorGetAlpha(_blurTintColor.CGColor)]];
        
        if (blurredImage){
            // Our normal animation.
            [_framesArray addObject:blurredImage];
            // Our reverse animation.
            [_framesReverseArray insertObject:blurredImage atIndex:0];
        }
        
    }
    completion();
    
}

-(void)blurInAnimationWithDuration:(CGFloat)duration{
    
    // Set our duration.
    self.animationDuration = duration;
    
    // Set our forwards image array;
    self.animationImages = _framesArray;
    
    // Set our image to the last image to make sure it's permanent on animation end.
    [self setImage:[_framesArray lastObject]];
    
    // BOOM! Blur in.
    [self startAnimating];
}

-(void)blurOutAnimationWithDuration:(CGFloat)duration{
    
    // Set our duration.
    self.animationDuration = duration;
    
    // Set our reverse image array.
    self.animationImages = _framesReverseArray;
    
    // Set our end frame.
    [self setImage:_baseImage];
    
    // BOOM! Blur out.
    [self startAnimating];
}

-(void)blurInAnimationWithDuration:(CGFloat)duration completion:(void(^)())completion{
    
    // Call our blurout with the correct duration.
    [self blurInAnimationWithDuration:duration];
    
    // Our callback
    // Via http://stackoverflow.com/questions/9283270/access-method-after-uiimageview-animation-finish
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.animationDuration * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(completion){
            completion();
        }
    });
}

-(void)blurOutAnimationWithDuration:(CGFloat)duration completion:(void(^)())completion{
    
    // Call our blurout with the correct duration.
    [self blurOutAnimationWithDuration:duration];
    
    // Our callback
    // Via http://stackoverflow.com/questions/9283270/access-method-after-uiimageview-animation-finish
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.animationDuration * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(completion){
            completion();
        }
    });
}

- (void)kenBurnsAnimate{
    
    float resizeRatio   = -1;
    float widthDiff     = -1;
    float heightDiff    = -1;
    float originX       = -1;
    float originY       = -1;
    float zoomInX       = -1;
    float zoomInY       = -1;
    float moveX         = -1;
    float moveY         = -1;
    float frameWidth    = _isLandscape? self.frame.size.width : self.frame.size.height;
    float frameHeight   = _isLandscape? self.frame.size.height : self.frame.size.width;
    
    // Widder than screen
    if (self.image.size.width > frameWidth)
    {
        widthDiff  = self.image.size.width - frameWidth;
        
        // Higher than screen
        if (self.image.size.height > frameHeight)
        {
            heightDiff = self.image.size.height - frameHeight;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameHeight / self.image.size.height;
            else
                resizeRatio = frameWidth / self.image.size.width;
            
            // No higher than screen
        }
        else
        {
            heightDiff = frameHeight - self.image.size.height;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameWidth / self.image.size.width;
            else
                resizeRatio = self.bounds.size.height / self.image.size.height;
        }
        
        // No widder than screen
    }
    else
    {
        widthDiff  = frameWidth - self.image.size.width;
        
        // Higher than screen
        if (self.image.size.height > frameHeight)
        {
            heightDiff = self.image.size.height - frameHeight;
            
            if (widthDiff > heightDiff)
                resizeRatio = self.image.size.height / frameHeight;
            else
                resizeRatio = frameWidth / self.image.size.width;
            
            // No higher than screen
        }
        else
        {
            heightDiff = frameHeight - self.image.size.height;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameWidth / self.image.size.width;
            else
                resizeRatio = frameHeight / self.image.size.height;
        }
    }
    
    // Resize the image.
    float optimusWidth  = (self.image.size.width * resizeRatio) * enlargeRatio;
    float optimusHeight = (self.image.size.height * resizeRatio) * enlargeRatio;
    
    // Calcule the maximum move allowed.
    float maxMoveX = optimusWidth - frameWidth;
    float maxMoveY = optimusHeight - frameHeight;
    
    float rotation = (arc4random() % 9) / 100;
    
    switch (arc4random() % 4) {
        case 0:
            originX = 0;
            originY = 0;
            zoomInX = 1.25;
            zoomInY = 1.25;
            moveX   = -maxMoveX;
            moveY   = -maxMoveY;
            break;
            
        case 1:
            originX = 0;
            originY = frameHeight - optimusHeight;
            zoomInX = 1.10;
            zoomInY = 1.10;
            moveX   = -maxMoveX;
            moveY   = maxMoveY;
            break;
            
            
        case 2:
            originX = frameWidth - optimusWidth;
            originY = 0;
            zoomInX = 1.30;
            zoomInY = 1.30;
            moveX   = maxMoveX;
            moveY   = -maxMoveY;
            break;
            
        case 3:
            originX = frameWidth - optimusWidth;
            originY = frameHeight - optimusHeight;
            zoomInX = 1.20;
            zoomInY = 1.20;
            moveX   = maxMoveX;
            moveY   = maxMoveY;
            break;
            
        default:
            NSLog(@"def");
            break;
    }
    
    CALayer *picLayer    = [CALayer layer];
    picLayer.contents    = (id)self.image.CGImage;
    picLayer.anchorPoint = CGPointMake(0, 0);
    picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
    picLayer.position    = CGPointMake(originX, originY);
    
    [self.layer addSublayer:picLayer];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:1];
    [animation setType:kCATransitionFade];
    [[self layer] addAnimation:animation forKey:nil];
    
    // Remove the previous view
    if ([[self subviews] count] > 0){
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    
    // Generates the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:self.timeTransition+2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    CGAffineTransform rotate    = CGAffineTransformMakeRotation(rotation);
    CGAffineTransform moveRight = CGAffineTransformMakeTranslation(moveX, moveY);
    CGAffineTransform combo1    = CGAffineTransformConcat(rotate, moveRight);
    CGAffineTransform zoomIn    = CGAffineTransformMakeScale(zoomInX, zoomInY);
    CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
    self.transform = transform;
    [UIView commitAnimations];

}

@end

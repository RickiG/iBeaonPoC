//
//  RGStatusView.m
//  iBeaconPoc
//
//  Created by Ricki Gregersen on 08/03/14.
//  Copyright (c) 2014 rickigregersen.com. All rights reserved.
//

#import "RGStatusView.h"

@interface RGStatusView ()

@property(nonatomic, strong) NSArray *stateImages;

@end

@implementation RGStatusView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self)
        return nil;
    
    [self setupImages];
    
    return self;
}

- (void) setupImages
{
    _stateImages = @[[self imageViewWithImagePath:@"unknown.jpg"],
                     [self imageViewWithImagePath:@"faraway.jpg"],
                     [self imageViewWithImagePath:@"near.jpg"],
                     [self imageViewWithImagePath:@"close.jpg"]];
    
    [self updateStateImagesWithState:0 animated:NO];
}

- (void) updateStateImagesWithState:(NSUInteger) state animated:(BOOL) animated
{
    [_stateImages enumerateObjectsUsingBlock:^(UIImageView *imgView, NSUInteger idx, BOOL *stop) {
       
        CGPoint targetPoint = (idx == state ? self.center : [self randomPointOutsideOfScreen]);
        
        if (animated) {
         
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 
                                 imgView.center = targetPoint;
                                 
                             } completion:NULL];
            
        } else {
            
            imgView.center = targetPoint;
        }
    }];
}

static CGFloat imageWidth = 300.0f;
static CGFloat imageHeight = 300.0f;

- (UIImageView*) imageViewWithImagePath:(NSString*) imagePath
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
    imgView.center = [self randomPointOutsideOfScreen];
    [self addSubview:imgView];
    
    return imgView;
}

#define ARC4RANDOM_MAX      0x100000000

- (CGPoint) randomPointOutsideOfScreen
{
    return CGPointMake(self.center.x, -1 * imageHeight * 0.5f);
    return CGPointMake(self.center.x, CGRectGetHeight(self.frame) + imageHeight * 0.5f);
    
    CGFloat minX = CGRectGetWidth(self.frame) + imageWidth * 0.5f;
    CGFloat maxX = CGRectGetWidth(self.frame) + imageWidth;

    CGFloat minY = CGRectGetHeight(self.frame) + imageHeight * 0.5f;
    CGFloat maxY = CGRectGetHeight(self.frame) + imageHeight;
    
    CGFloat xPos = ((float)arc4random() / ARC4RANDOM_MAX * (maxX - minX)) + minX;
    CGFloat yPos = ((float)arc4random() / ARC4RANDOM_MAX * (maxY - minY)) + minY;
    
    return (CGPoint){xPos, yPos};
}

@end

//
//  RGStatusView.m
//  iBeaconPoc
//
//  Created by Ricki Gregersen on 08/03/14.
//  Copyright (c) 2014 rickigregersen.com. No rights reserved.
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
       
        CGPoint targetPoint = (idx == state ? self.center : [self pointOutsideOfScreen]);
        
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
    imgView.center = [self pointOutsideOfScreen];
    [self addSubview:imgView];
    
    return imgView;
}

- (CGPoint) pointOutsideOfScreen
{
    return CGPointMake(self.center.x, -1 * imageHeight * 0.5f);
}

@end

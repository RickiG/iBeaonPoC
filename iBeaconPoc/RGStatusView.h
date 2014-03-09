//
//  RGStatusView.h
//  iBeaconPoc
//
//  Created by Ricki Gregersen on 08/03/14.
//  Copyright (c) 2014 rickigregersen.com. No rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGStatusView : UIView

/*
 State: 
 0 : unknown
 1 : far away
 2 : close
 3 : immidiate
 */
- (void) updateStateImagesWithState:(NSUInteger) state animated:(BOOL) animated;

@end

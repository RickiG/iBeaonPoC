//
//  RGViewController.m
//  iBeaconPoc
//
//  Created by Ricki Gregersen on 08/03/14.
//  Copyright (c) 2014 rickigregersen.com. All rights reserved.
//

#import "RGViewController.h"
#import "RGStatusView.h"
#import <CoreLocation/CoreLocation.h>

@interface RGViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet RGStatusView *statusImageView;

@end

@implementation RGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.statusTextView.font = [UIFont fontWithName:@"Courier-Bold" size:17.0f];
    self.statusTextView.text = @"Searching for iBeacon";
    self.statusTextView.textColor = [UIColor greenColor];
    [self.statusImageView updateStateImagesWithState:0 animated:NO];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self setupRegion];
    
}

- (void) setupRegion
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.rickigregersen.hood"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    [self updateStatusFromBeacon:beacon];
}

- (void) updateStatusFromBeacon:(CLBeacon*) beacon
{
    NSMutableString *statusString = [NSMutableString string];
    [statusString appendString:[NSString stringWithFormat:@"Beacon UUID : %@\n", beacon.proximityUUID.UUIDString]];
    [statusString appendString:[NSString stringWithFormat:@"Major : %@\n", beacon.major]];
    [statusString appendString:[NSString stringWithFormat:@"Minor : %@\n", beacon.minor]];
    [statusString appendString:[NSString stringWithFormat:@"Accuracy : %f\n\n", beacon.accuracy]];
    
    NSUInteger updateState = 0;
    NSString *proximityString = @"";
    
    if (beacon.proximity == CLProximityFar) {
        proximityString = @"Status : Far Away";
        updateState = 1;
    } else if (beacon.proximity == CLProximityNear) {
        proximityString = @"Status : Near";
        updateState = 2;
    } else if (beacon.proximity == CLProximityImmediate) {
        proximityString = @"Status : Really Close!";
        updateState = 3;
    } else {
        proximityString = @"Status : Unknow";
    }
    
    [statusString appendString:proximityString];
    self.statusTextView.textColor = [UIColor greenColor]; 
    self.statusTextView.text = statusString;
    
    [self.statusImageView updateStateImagesWithState:updateState animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

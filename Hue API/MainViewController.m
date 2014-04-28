//
//  MainViewController.m
//  Hue API
//
//  Created by Dare Ryan on 4/28/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"

@interface MainViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startDeterminingUserLocation];
NSLog(@"%@", Wunderground_Key);
}

-(void)startDeterminingUserLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    NSLog(@"%f %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
}

@end

//
//  MainViewController.m
//  Hue API
//
//  Created by Dare Ryan on 4/28/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startDeterminingUserLocation];
    
   
}

-(void)startDeterminingUserLocation
{
    if ([CLLocationManager authorizationStatus] == 3) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.delegate = self;
        NSLog(@"%u",[CLLocationManager authorizationStatus]);
    }
    else{
        UIAlertView *locAlert = [[UIAlertView alloc]initWithTitle:@"Locations Services Disabled" message:@"Please enable location services in settings to determine your zipcode for weather updates" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        locAlert.delegate = self;
        [locAlert show];
    }
    
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    NSLog(@"%f %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
}






@end

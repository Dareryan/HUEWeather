//
//  MainViewController.m
//  Hue API
//
//  Created by Dare Ryan on 4/28/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "WeatherAPI.h"
#import "HUEAPI.h"

@interface MainViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSNumber *currentTemp;
@property (strong, nonatomic) HUEAPI *HUEAPI;
@property (strong, nonatomic) NSNumber *hue;
- (IBAction)buttonPressed:(id)sender;

@end

@implementation MainViewController


-(void)startDeterminingUserLocation
{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    
    [self.locationManager stopUpdatingLocation];
    
    [WeatherAPI getHighTemperatureForTodayForLatitude:self.location.coordinate.latitude Longitude:self.location.coordinate.longitude WithCompletion:^(NSNumber *temp) {
        self.currentTemp = temp;
        [self checkAuthorizationStatusAndSetColor];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self.HUEAPI authorizeNewUser];
    }
    else{
        NSLog(@"Didn't click OK");
    }
}

-(void)checkAuthorizationStatusAndSetColor
{
    self.HUEAPI = [[HUEAPI alloc]init];
    [self.HUEAPI checkBridgeAuthorizationStatusWithCompletion:^(NSString *error) {
        if ([error isEqualToString:@"unauthorized user"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unauthorized User" message:@"This app is not yet authorized to access your Hue bridge. Please press the bridge button then click OK" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                
                [alert show];
            });
        }
        else{
            [self.HUEAPI getListOfAvailableBulbsWithCompletion:^(NSArray *bulbIDS) {
                [self setBackgroundColorBasedOnTemperature:self.currentTemp];
                [self setColorForBulbs:bulbIDS BasedOnTemperature:self.currentTemp];
            }];
        }
    }];
}

-(void)setBackgroundColorBasedOnTemperature: (NSNumber *)temperature
{
    UIColor *backgroundColor;
    
    if ([temperature floatValue] <= 32.0) {
        backgroundColor = [UIColor colorWithRed:0 green:.08 blue:1 alpha:1]; //blue
    }
    else if ([temperature floatValue] > 32.0 && [temperature floatValue] < 50.0){
        backgroundColor = [UIColor colorWithRed:0 green:0.78 blue:.90 alpha:1]; //turquoise
    }
    else if ([temperature floatValue] >= 50.0 && [temperature floatValue] < 70.0){
        backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0 alpha:1]; //yellow
    }
    else if ([temperature floatValue] >= 70.0 && [temperature floatValue] < 90.0){
        backgroundColor = [UIColor colorWithRed:1.0 green:0.50 blue:0.05 alpha:1]; //orange
    }
    else if ([temperature floatValue] >= 90.0){
        backgroundColor = [UIColor colorWithRed:1.0 green:.08 blue:0 alpha:1]; //red
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setBackgroundColor:backgroundColor];
        }];
    });
}

-(void)setColorForBulbs:(NSArray *)bulbs BasedOnTemperature:(NSNumber *)temperature
{
    if ([temperature floatValue] <= 32.0) {
        [self.HUEAPI turnOnAvailableBulbs:bulbs andSetToHue:@46920]; //blue
    }
    else if ([temperature floatValue] > 32.0 && [temperature floatValue] < 50.0){
        [self.HUEAPI turnOnAvailableBulbs:bulbs andSetToHue:@42000];//turquoise
    }
    else if ([temperature floatValue] >= 50.0 && [temperature floatValue] < 70.0){
        [self.HUEAPI turnOnAvailableBulbs:bulbs andSetToHue:@20000];//yellow
    }
    else if ([temperature floatValue] >= 70.0 && [temperature floatValue] < 90.0){
        [self.HUEAPI turnOnAvailableBulbs:bulbs andSetToHue:@10000]; //orange
    }
    else if ([temperature floatValue] >= 90.0){
        [self.HUEAPI turnOnAvailableBulbs:bulbs andSetToHue:@0]; //red
    }
}

- (IBAction)buttonPressed:(id)sender
{
    self.locationManager = [[CLLocationManager alloc]init];
    
    [self startDeterminingUserLocation];
    
    self.location = self.locationManager.location;
    
    [WeatherAPI getHighTemperatureForTodayForLatitude:self.location.coordinate.latitude Longitude:self.location.coordinate.longitude WithCompletion:^(NSNumber *temp) {
        self.currentTemp = temp;
        [self checkAuthorizationStatusAndSetColor];
    }];
}
@end

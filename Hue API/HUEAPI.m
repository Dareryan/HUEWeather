//
//  HUEAPI.m
//  Hue API
//
//  Created by Dare Ryan on 5/1/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import "HUEAPI.h"

@interface HUEAPI()

@end

@implementation HUEAPI

-(void)getBridgeIPAddressWithCompletion:(void (^)(NSString *))completion
{
    NSString *URLString = @"http://www.meethue.com/api/nupnp";
    NSURL *requestURL = [[NSURL alloc]initWithString:URLString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *JSONResponseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSDictionary *JSONResponseDict = [JSONResponseArray lastObject];
        self.bridgeIP = JSONResponseDict[@"internalipaddress"];
        completion(self.bridgeIP);
       }]resume];
}

-(void)checkBridgeAuthorizationStatusWithCompletion:(void (^)(NSString *))completion
{
    [self getBridgeIPAddressWithCompletion:^(NSString *IPAddress) {
       
        NSString *URLString = [NSString stringWithFormat:@"http://%@/api/HUEWeatherAPI", IPAddress];
        NSURL *requestURL = [[NSURL alloc]initWithString:URLString];
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSArray *JSONResponseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ([JSONResponseArray count] == 1) {
                NSDictionary *responseDict = JSONResponseArray[0];
                NSString *errorString = responseDict[@"error"][@"description"];
                completion(errorString);
            }
            else{
                completion(@"Authorized");
            }
          
        }]resume];
    }];
}

-(void)authorizeNewUser
{
    NSDictionary *newUserDict = @{@"devicetype":@"HUEWeatherAPI", @"username":@"HUEWeatherAPI"};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:newUserDict options:0 error:nil];
    NSString *URLString = [NSString stringWithFormat:@"http://%@/api", self.bridgeIP];
    NSURL *requestURL = [[NSURL alloc]initWithString:URLString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]resume];
}

-(void)getListOfAvailableBulbsWithCompletion:(void (^)(NSArray *))completion
{
    NSString *URLString =[NSString stringWithFormat:@"http://%@/api/HUEWeatherAPI/lights", self.bridgeIP];
    NSURL *requestURL = [[NSURL alloc]initWithString:URLString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *JSONResponseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"%@", JSONResponseDict);
        completion([JSONResponseDict allKeys]);
    }]resume];

}

-(void)turnOnAvailableBulbs:(NSArray *)bulbs andSetToHue:(NSNumber *)hue
{
    for (NSString *bulbID in bulbs) {
        
        NSString *lightParams = @"{\"on\":true}";
        
        NSString *URLString = [NSString stringWithFormat:@"http://%@/api/HUEWeatherAPI/lights/%@/state/", self.bridgeIP, bulbID];
        NSData *postBody = [lightParams dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *requestURL = [[NSURL alloc]initWithString:URLString];
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:postBody];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@, %@, %@", data, response, error);
        }]resume];
    }
}


@end

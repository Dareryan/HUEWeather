//
//  WeatherAPI.m
//  Hue API
//
//  Created by Dare Ryan on 4/28/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import "WeatherAPI.h"
#import "Constants.h"

@implementation WeatherAPI

+(void)getHighTemperatureForTodayForLatitude: (CGFloat)latitude Longitude: (CGFloat)longitude WithCompletion:(void (^)(NSNumber *))completion
{
    NSString *URLString = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%f,%f.json", Wunderground_Key, latitude, longitude];
    NSURL *requestURL = [[NSURL alloc]initWithString:URLString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *JSONResponseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSNumber *temp = JSONResponseDict[@"current_observation"][@"feelslike_f"];
        
        completion(temp);
        
    }]resume];
    
}



@end

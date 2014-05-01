//
//  WeatherAPI.h
//  Hue API
//
//  Created by Dare Ryan on 4/28/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherAPI : NSObject

+(void)getHighTemperatureForTodayForLatitude: (CGFloat)latitude Longitude: (CGFloat)longitude WithCompletion:(void (^)(NSNumber *))completion;



@end

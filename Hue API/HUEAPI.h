//
//  HUEAPI.h
//  Hue API
//
//  Created by Dare Ryan on 5/1/14.
//  Copyright (c) 2014 Dare Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUEAPI : NSObject
@property (strong, nonatomic) NSString *bridgeIP;
-(void)getBridgeIPAddressWithCompletion:(void (^)())completion;
-(void)checkBridgeAuthorizationStatusWithCompletion:(void (^)(NSString *))completion;
-(void)authorizeNewUser;
-(void)getListOfAvailableBulbsWithCompletion:(void (^)(NSArray *))completion;
-(void)turnOnAvailableBulbs:(NSArray *)bulbs andSetToHue:(NSNumber *)hue;
@end

//
//  AVCGMapItem.h
//  ACTest
//
//  Created by Luiz Duraes on 3/13/16.
//  Copyright © 2016 Mob4U IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AVCGMapItem : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSDictionary *dictLocation;
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;

-(instancetype)initWithAddress:(NSString *)address;

@end

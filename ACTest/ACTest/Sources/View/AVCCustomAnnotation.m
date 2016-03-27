//
//  AVCCustomAnnotation.m
//  ACTest
//
//  Created by Luiz Duraes on 3/26/16.
//  Copyright © 2016 Avenue Code. All rights reserved.
//

#import "AVCCustomAnnotation.h"
#import "AVCGMapItem.h"

@interface AVCCustomAnnotation ()

@property (strong, nonatomic) AVCGMapItem *mapItem;

@end

@implementation AVCCustomAnnotation

@synthesize coordinate;

#pragma mark - Public

-(instancetype)initWithMapItem:(AVCGMapItem *)mapItem {
    if(self = [super init]) {
        [self setMapItem:mapItem];
    }
    
    return self;
}

#pragma mark - Override

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.mapItem.latitude, self.mapItem.longitude);
}

-(NSString *)title {
    return self.mapItem.address;
}

@end

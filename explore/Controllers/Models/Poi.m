//
//  Poi.m
//  explore
//
//  Created by sahil singh on 19/08/23.
//

#import "Poi.h"

@implementation Poi

- (instancetype) initWithLatitude:(double)latitude
                    longitude:(double)longitude{
    if(self = [super init]){
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Poi class]]) {
        return NO;
    }
    
    Poi *otherPoi = (Poi *)object;
    
    // Compare latitude and longitude properties
    if (self.latitude != otherPoi.latitude || self.longitude != otherPoi.longitude) {
        return NO;
    }
    
    return YES;
}

@end


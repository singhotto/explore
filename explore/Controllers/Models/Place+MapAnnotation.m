//
//  Place+MapAnnotation.m
//  explore
//
//  Created by sahil singh on 19/08/23.
//

#import "Place+MapAnnotation.h"

@implementation Place (MapAnnotation)


- (CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.location.latitude;
    coordinate.longitude = self.location.longitude;
    return coordinate;
}

- (NSString *)title{
    return self.placeName;
}

@end

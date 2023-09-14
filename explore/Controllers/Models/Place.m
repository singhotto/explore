//
//  Place.m
//  explore
//
//  Created by sahil singh on 28/07/23.
//

#import "Place.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@implementation Place

- (instancetype)initWithPlaceName:(NSString *)name location:(Poi *)location placeDescription:(NSString *)desc imageName: (NSString *)imageName imageData: (NSData *)imageData{
    if(self = [super init]){
        self.placeName = name;
        self.placeDescription = desc;
        self.imageName = imageName;
        self.location = location;
        self.imageData = imageData;
    }
    return self;
}
- (instancetype)initWithPlaceName:(NSString *)name location:(Poi *)location placeDescription:(NSString *)desc lastModified:(NSDate *)date imagePath: (NSString *)path{
    if(self = [super init]){
        self.placeName = name;
        self.placeDescription = desc;
        self.imagePath = path;
        self.location = location;
        self.lastModified = date;
    }
    return self;
}
@end

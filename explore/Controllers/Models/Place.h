//
//  Place.h
//  explore
//
//  Created by sahil singh on 28/07/23.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

NS_ASSUME_NONNULL_BEGIN

@interface Place : NSObject

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeDescription;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSDate *lastModified;
@property (nonatomic, strong) Poi *location;

- (instancetype)initWithPlaceName:(NSString *)name location:(Poi *)location placeDescription:(NSString *)desc imageName: (NSString *)imageName imageData: (NSData *)imageData;

- (instancetype)initWithPlaceName:(NSString *)name location:(Poi *)location placeDescription:(NSString *)desc
                        lastModified:(NSDate *)date imagePath: (NSString *)path;

@end

NS_ASSUME_NONNULL_END

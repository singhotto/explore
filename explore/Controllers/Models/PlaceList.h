//
//  PlaceList.h
//  explore
//
//  Created by sahil singh on 13/08/23.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "Poi.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceList : NSObject

- (long)size;
- (NSArray *)getAll;
- (void)save:(Place *)p;
- (Place *)getAtIndex:(NSInteger)index;
- (long)indexOfPlace:(Place *)place;
- (nonnull Place *)placeWithLocation: (Poi *)location;
- (void)removePlaceWithLocation: (Poi *)location;
- (void)updatePlaceWithLocation: (Poi *)location newPlaceName:(NSString *)newName newPlaceDescription:(NSString *)newDesc newImageData:(NSData *)newImageData;

@end

NS_ASSUME_NONNULL_END

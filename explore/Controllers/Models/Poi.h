//
//  Poi.h
//  explore
//
//  Created by sahil singh on 19/08/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Poi : NSObject

- (instancetype) initWithLatitude:(double)latitude
                    longitude:(double)longitude;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

@end

NS_ASSUME_NONNULL_END


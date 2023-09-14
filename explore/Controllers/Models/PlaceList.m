//
//  PlaceList.m
//  explore
//
//  Created by sahil singh on 13/08/23.
//

#import "PlaceList.h"
#import "PlaceModel+CoreDataModel.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface PlaceList ()
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation PlaceList

- (instancetype)init{
    if(self = [super init]){
        self.list = [[NSMutableArray alloc] init];
        [self updateList];
    }
    return self;
}

- (void)updateList{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *MOContext = appDelegate.managedObjectContext;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceModel"];

    // Create a sort descriptor to sort by lastModified in descending order
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastModified" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];

    NSError *error = nil;
    NSArray *results = [MOContext executeFetchRequest:request error:&error];

    if (!error) {
        NSMutableArray *convertedPlaces = [NSMutableArray array];
        for (PlaceModel *placeModel in results) {
            Place *place = [[Place alloc] initWithPlaceName:placeModel.placeName location:[[Poi alloc] initWithLatitude:placeModel.latitude longitude:placeModel.longitude] placeDescription:placeModel.placeDescription lastModified:placeModel.lastModified imagePath:placeModel.imagePath];
            [convertedPlaces addObject:place];
        }
        self.list = [NSMutableArray arrayWithArray:convertedPlaces];
    } else {
        NSLog(@"Error fetching places: %@, %@", error, error.userInfo);
    }
}

- (nonnull NSArray *)getAll {
    return self.list;
}

- (nonnull Place *)getAtIndex:(NSInteger)index {
    return [self.list objectAtIndex:index];
}

- (long)indexOfPlace:(Place *)place{
    return [self.list indexOfObject:place];
}

- (nonnull Place *)placeWithLocation: (Poi *)location{
    for (Place *place in self.list) {
        if ([place.location isEqual:location]) {
            return place;
        }
    }
    return nil;
}

- (void)save:(nonnull Place *)p {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *MOContext = appDelegate.managedObjectContext;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PlaceModel" inManagedObjectContext:MOContext];
    NSManagedObject *newPlace = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:MOContext];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    p.imagePath = [documentDirectory stringByAppendingPathComponent:p.imageName];
    BOOL success = [p.imageData writeToFile:p.imagePath atomically:YES];
    
    if(success || !p.imageData){
        [newPlace setValue:p.placeName forKey:@"placeName"];
        [newPlace setValue:p.placeDescription forKey:@"placeDescription"];
        [newPlace setValue:p.imagePath forKey:@"imagePath"];
        [newPlace setValue:@(p.location.longitude) forKey:@"longitude"];
        [newPlace setValue:@(p.location.latitude) forKey:@"latitude"];
        [newPlace setValue:[NSDate date] forKey:@"lastModified"];
        NSError *error = nil;
        if(![MOContext save:&error]){
            NSLog(@"Error saving place data: %@, %@", error, error.userInfo);
        }
    }else{
        NSLog(@"Failed to save the image.");
    }
    [self updateList];
}

- (long)size {
    return self.list.count;
}

- (void)removePlaceWithLocation: (Poi *)location{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *MOContext = appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceModel"];
    double latitudeTolerance = 0.0001; // Adjust tolerance as needed
    double longitudeTolerance = 0.0001;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f",
                              location.latitude - latitudeTolerance,
                              location.latitude + latitudeTolerance,
                              location.longitude - longitudeTolerance,
                              location.longitude + longitudeTolerance];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [MOContext executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        NSManagedObject *placeToRemove = [results firstObject];
        NSString *imagePath = [placeToRemove valueForKey:@"imagePath"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            NSError *fileError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&fileError];
            if (fileError) {
                NSLog(@"Error removing image file: %@, %@", fileError, fileError.userInfo);
            }
        }
        
        [MOContext deleteObject:placeToRemove];
        
        NSError *saveError = nil;
        if (![MOContext save:&saveError]) {
            NSLog(@"Error saving after deleting place: %@, %@", saveError, saveError.userInfo);
        }
    } else {
        NSLog(@"Error fetching place data for removal: %@, %@", error, error.userInfo);
    }
    [self updateList];
}

- (void)updatePlaceWithLocation: (Poi *)location newPlaceName:(nonnull NSString *)newName newPlaceDescription:(nonnull NSString *)newDesc newImageData:(nonnull NSData *)newImageData {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *MOContext = appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceModel"];
    
    double latitudeTolerance = 0.0001; // Adjust tolerance as needed
    double longitudeTolerance = 0.0001;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f",
                              location.latitude - latitudeTolerance,
                              location.latitude + latitudeTolerance,
                              location.longitude - longitudeTolerance,
                              location.longitude + longitudeTolerance];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [MOContext executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
            NSManagedObject *placeToUpdate = [results firstObject];
            
            if (newName) {
                [placeToUpdate setValue:newName forKey:@"placeName"];
            }
            
            if (newDesc) {
                [placeToUpdate setValue:newDesc forKey:@"placeDescription"];
            }
            
            if (newImageData) {
                NSString *oldImagePath = [placeToUpdate valueForKey:@"imagePath"];
            
                NSFileManager *fileManager = [NSFileManager defaultManager];
            
                if ([fileManager fileExistsAtPath:oldImagePath]) {
                    NSError *fileError = nil;
                    [fileManager removeItemAtPath:oldImagePath error:&fileError];
                
                    if (fileError) {
                        NSLog(@"Error removing old image file: %@, %@", fileError, fileError.userInfo);
                    }
                }
            
                BOOL success = [newImageData writeToFile:oldImagePath atomically:YES];
            
                if (!success) {
                    NSLog(@"Failed to save the new image.");
                }
            }

            
            NSError *saveError = nil;
            if (![MOContext save:&saveError]) {
                NSLog(@"Error saving after updating place: %@, %@", saveError, saveError.userInfo);
            }else{
                [placeToUpdate setValue:[NSDate date] forKey:@"lastModified"];
            }
    } else {
        NSLog(@"Error fetching place data for updating: %@, %@", error, error.userInfo);
    }
    [self updateList];
}

@end

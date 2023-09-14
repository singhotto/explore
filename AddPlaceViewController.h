//
//  AddPlaceViewController.h
//  explore
//
//  Created by sahil singh on 27/07/23.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddPlaceViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSData *imageData;

@end

NS_ASSUME_NONNULL_END

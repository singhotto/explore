//
//  ModifyPlaceViewController.m
//  explore
//
//  Created by sahil singh on 13/08/23.
//

#import "ModifyPlaceViewController.h"
#import "PlaceList.h"

@interface ModifyPlaceViewController ()
@property (nonatomic, strong) NSData *imageData;
@end

@implementation ModifyPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameField.text = self.place.placeName;
    self.descField.text = self.place.placeDescription;
    self.imageView.image = [UIImage imageWithContentsOfFile:self.place.imagePath];
    [self addGesture];
}

- (void)addGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture requireGestureRecognizerToFail:self.nameField.gestureRecognizers.firstObject];
    [tapGesture requireGestureRecognizerToFail:self.descField.gestureRecognizers.firstObject];
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.descField resignFirstResponder];
}

- (IBAction)updateImage:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = selectedImage;
    self.imageData = UIImageJPEGRepresentation(selectedImage, 0.8);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)update:(id)sender {
    PlaceList *list = [[PlaceList alloc] init];
    [list updatePlaceWithLocation:self.place.location newPlaceName:self.nameField.text newPlaceDescription:self.descField.text newImageData:self.imageData];
    
    [self performSegueWithIdentifier:@"placeUpdated" sender:self];
}

@end

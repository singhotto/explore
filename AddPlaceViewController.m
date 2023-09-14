//
//  AddPlaceViewController.m
//  explore
//
//  Created by sahil singh on 27/07/23.
//

#import "AddPlaceViewController.h"
#import "Place.h"
#import "PlaceList.h"
#import "TempMsg.h"

@implementation AddPlaceViewController

- (void)viewDidLoad {
    self.descriptionField.layer.cornerRadius = 10.0;
    self.descriptionField.layer.masksToBounds = YES;
    
    [self addGesture];
}

- (void)addGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture requireGestureRecognizerToFail:self.nameField.gestureRecognizers.firstObject];
    [tapGesture requireGestureRecognizerToFail:self.descriptionField.gestureRecognizers.firstObject];
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
}

- (IBAction)addImageBtn:(id)sender {
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

- (IBAction)saveBtn:(id)sender {
    if(self.nameField.text.length == 0){
        TempMsg *temp = [[TempMsg alloc] initWthMessage:@"Enter Name!" type:@"warrning"];
        [temp showMsgInView:self.view];
        return;
    }
    Place *place = [[Place alloc] init];
    [place setPlaceName:self.nameField.text];
    [place setLocation: [[Poi alloc] initWithLatitude:self.coordinates.latitude longitude:self.coordinates.longitude]];
    [place setPlaceDescription:self.descriptionField.text];
    [place setImageName:[NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]]];
    [place setImageData:self.imageData];
    PlaceList *list = [[PlaceList alloc] init];
    [list save:place];
    [self performSegueWithIdentifier:@"backToMaps" sender:self];
}

@end

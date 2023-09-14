//
//  SinglePlaceViewController.h
//  explore
//
//  Created by sahil singh on 05/08/23.
//

#import <UIKit/UIKit.h>
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DeleteViewControllerDelegate <NSObject>
- (void)didDeleteItem;
@end

@interface SinglePlaceViewController : UIViewController
@property (strong, nonatomic) Place *place;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) id<DeleteViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

//
//  TempMsg.h
//  explore
//
//  Created by sahil singh on 30/07/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TempMsg : UIView

- (instancetype)initWthMessage:(NSString *)msg type:(NSString *)type;

- (void)showMsgInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

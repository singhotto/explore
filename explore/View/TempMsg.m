//
//  TempMsg.m
//  explore
//
//  Created by sahil singh on 30/07/23.
//

#import "TempMsg.h"

@implementation TempMsg

- (nonnull instancetype)initWthMessage:(nonnull NSString *)msg type: (NSString *)type{
    if(self = [super initWithFrame:CGRectMake(0, 0, 240, 40)]){
        self.backgroundColor = [self getColorForType:type];
        self.layer.cornerRadius = 10.0;
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:self.bounds];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.textColor = [UIColor whiteColor];
        msgLabel.font = [UIFont boldSystemFontOfSize:30.0];
        msgLabel.text = msg;
        [self addSubview:msgLabel];
    }
    return self;
}

- (UIColor *)getColorForType: (NSString *)type{
    if([type isEqualToString:@"success"]){
        return [UIColor colorWithRed:0.298039 green:0.686275 blue:0.313725 alpha:1];
    }else if([type isEqualToString:@"danger"]){
        return [UIColor colorWithRed:0.956863 green:0.262745 blue:0.211765 alpha:1.0];
    }else if([type isEqualToString:@"info"]){
        return [UIColor blueColor];
    }else if([type isEqualToString:@"warrning"]){
        return [UIColor systemYellowColor];
    }
    return nil;
}

- (void)showMsgInView:(UIView *)view {
    self.frame = CGRectMake((CGRectGetWidth(view.bounds) - 240) / 2.0, CGRectGetMaxY(view.bounds) - 100, 240, 40);
    [view addSubview:self];

    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end

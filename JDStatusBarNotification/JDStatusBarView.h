//
//  JDStatusBarView.h
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDStatusBarViewDelegate
@optional
- (void)didTapDetailButton;
@end

@interface JDStatusBarView : UIView
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UILabel *rightTextLabel;
@property (nonatomic, strong, readonly) UIImageView *leftIconImgView;
@property (nonatomic, strong, readonly) UIImageView *rightIconImgView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) CGFloat textVerticalPositionAdjustment;
@property (nonatomic, assign) NSObject<JDStatusBarViewDelegate> *delegate;

- (void)updateRightTextLabel:(NSString *)text rightIconImage:(UIImage *)image;

@end

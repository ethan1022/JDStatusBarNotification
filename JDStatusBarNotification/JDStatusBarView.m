//
//  JDStatusBarView.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"
#import "JDStatusBarLayoutMarginHelper.h"

@interface JDStatusBarView ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *rightTextLabel;
@property (nonatomic, strong) UIImageView *leftIconImgView;
@property (nonatomic, strong) UIImageView *rightIconImgView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *detailButton;

@end

@implementation JDStatusBarView

#pragma mark - instance method

- (void)didTapDetailButton:(UIButton *)btn {
  if ([self.delegate respondsToSelector:@selector(didTapDetailButton)]) {
    [self.delegate didTapDetailButton];
  }
}

- (void)updateRightTextLabel:(NSString *)text rightIconImage:(UIImage *)image {
  // detail button
  if (!self.detailButton) {
    self.detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.detailButton setTitle:@"" forState:UIControlStateNormal];
    [self.detailButton addTarget:self action:@selector(didTapDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.detailButton];
  }
  // right icon image view
  if (!self.rightIconImgView) {
    CGFloat padding = 8.0;
    CGFloat iconWidth = 20;
    self.rightIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - iconWidth - padding, 0, 20, 20)];
    [self addSubview:self.rightIconImgView];
  }
  self.rightIconImgView.image = image;

  //right text label
  if (!self.rightTextLabel) {
    self.rightTextLabel = [[UILabel alloc] init];
    self.rightTextLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.rightTextLabel.textColor = [UIColor whiteColor];
    self.rightTextLabel.backgroundColor = [UIColor clearColor];
    self.rightTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.rightTextLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTextLabel.adjustsFontSizeToFitWidth = YES;
    self.rightTextLabel.clipsToBounds = YES;
    [self addSubview:self.rightTextLabel];
  }
  self.rightTextLabel.text = text;
  [self.rightTextLabel sizeToFit];
}

#pragma mark - dynamic getter

- (UIImageView *)leftIconImgView {
    if (!_leftIconImgView) {
        CGFloat padding = 8.0;
        _leftIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 0, 20, 20)];
        [self addSubview:_leftIconImgView];
    }
     return _leftIconImgView;
}

- (UILabel *)textLabel;
{
  if (_textLabel == nil) {
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.clipsToBounds = YES;
    [self addSubview:_textLabel];
  }
  return _textLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView;
{
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

#pragma mark - setter

- (void)setTextVerticalPositionAdjustment:(CGFloat)textVerticalPositionAdjustment;
{
  _textVerticalPositionAdjustment = textVerticalPositionAdjustment;
  [self setNeedsLayout];
}

#pragma mark - layout

- (void)layoutSubviews;
{
  [super layoutSubviews];

  // label
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMargin().top;
  CGFloat xPoint = self.leftIconImgView ? 30 : 0;
  CGFloat textLabelWidth = self.bounds.size.width;

  if (self.leftIconImgView) {
    textLabelWidth = textLabelWidth - CGRectGetWidth(self.leftIconImgView.frame) - 8 - 2; // |-8-leftIconImgView-2-textLabel-|
  }

  if (self.rightIconImgView) {
    CGFloat iconImgViewPadding = 5.0;
    CGFloat iconImgViewWidth = CGRectGetWidth(self.rightIconImgView.frame);
    CGFloat rightLabelWidth = CGRectGetWidth(self.rightTextLabel.frame);
    textLabelWidth = textLabelWidth - iconImgViewPadding - iconImgViewWidth - rightLabelWidth;
    self.rightTextLabel.frame = CGRectMake(self.rightIconImgView.frame.origin.x - rightLabelWidth,
                                           self.textVerticalPositionAdjustment + topLayoutMargin + 1,
                                           rightLabelWidth,
                                           self.bounds.size.height - topLayoutMargin - 1);
    
    self.detailButton.frame = CGRectMake(CGRectGetMinX(self.rightTextLabel.frame),
                                         CGRectGetMinY(self.rightTextLabel.frame),
                                         rightLabelWidth + iconImgViewWidth,
                                         CGRectGetHeight(self.rightTextLabel.frame));
  }
  self.textLabel.frame = CGRectMake(xPoint,
                                    self.textVerticalPositionAdjustment + topLayoutMargin + 1,
                                    textLabelWidth,
                                    self.bounds.size.height - topLayoutMargin - 1);

  // activity indicator
  if (_activityIndicatorView ) {
    CGSize textSize = [self currentTextSize];
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.x = round((self.bounds.size.width - textSize.width)/2.0) - indicatorFrame.size.width - 8.0;
    indicatorFrame.origin.y = ceil(1+(self.bounds.size.height - indicatorFrame.size.height + topLayoutMargin)/2.0);
    _activityIndicatorView.frame = indicatorFrame;
  }
}

- (CGSize)currentTextSize;
{
  CGSize textSize = CGSizeZero;

  // use new sizeWithAttributes: if possible
  SEL selector = NSSelectorFromString(@"sizeWithAttributes:");
  if ([self.textLabel.text respondsToSelector:selector]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    textSize = [self.textLabel.text sizeWithAttributes:attributes];
#endif
  }

  // otherwise use old sizeWithFont:
  else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
    textSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
#endif
  }

  return textSize;
}

@end

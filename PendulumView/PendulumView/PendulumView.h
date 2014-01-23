//
//  PendulumView.h
//  PendulumView
//
//  Created by Tu You on 14-1-19.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendulumView : UIView

@property (nonatomic, assign) BOOL hidesWhenStopped;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor;
- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor ballDiameter:(CGFloat)ballDiameter;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end

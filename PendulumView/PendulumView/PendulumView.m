//
//  PendulumView.m
//  PendulumView
//
//  Created by Tu You on 14-1-19.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PendulumView.h"

static const NSUInteger ballCount = 7;
static const CGFloat defaultBallDiameter = 14;
static const float ballPendulateRadiusFactor = 1.5;
static const float ballPendulateAngle = M_PI_2 / 1;

@interface PendulumView ()

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) UIView *leftBall;
@property (nonatomic, strong) UIView *rigthBall;

@property (nonatomic, strong) NSMutableArray *reflectionBalls;
@property (nonatomic, strong) UIView *leftReflectionBall;
@property (nonatomic ,strong) UIView *rightReflectionBall;

@property (nonatomic, strong) UIColor *ballColor;
@property (nonatomic, assign) CGFloat ballDiameter;

@property (nonatomic, assign) float offset;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL shouldAnimate;

@end

@implementation PendulumView


- (id)initWithFrame:(CGRect)frame
{
    UIColor *defaultBallColor = [UIColor colorWithRed:0.47 green:0.60 blue:0.89 alpha:1];
    return [self initWithFrame:frame ballColor:defaultBallColor];
}

- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor
{
    return [self initWithFrame:frame ballColor:ballColor ballDiameter:defaultBallDiameter];
}

- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor ballDiameter:(CGFloat)ballDiameter
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.hidesWhenStopped = YES;
        
        self.ballColor = ballColor;
        
        if (ballDiameter < 0)
        {
            ballDiameter = defaultBallDiameter;
        }
        
        if (ballDiameter > CGRectGetWidth(frame) / ballCount)
        {
            ballDiameter = CGRectGetWidth(frame) / ballCount;
        }
        
        self.ballDiameter = ballDiameter;
        
        self.offset = sin(ballPendulateAngle) * (ballPendulateRadiusFactor + 0.5) * self.ballDiameter;
        
        [self createBalls];
        [self createReflection];
        
        self.shouldAnimate = YES;
        [self startAnimating];
    }
    return self;
}

- (void)createBalls
{
    self.balls = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat xPos = width / 2 - (ballCount / 2 + 0.5) * self.ballDiameter;
    CGFloat yPos = CGRectGetHeight(self.frame) / 2 - self.ballDiameter / 2;
    
    for (int i = 0; i < ballCount; i++)
    {
        UIView *ball = [self ball];
        ball.frame = CGRectMake(xPos, yPos, self.ballDiameter, self.ballDiameter);
        [self addSubview:ball];
        [self.balls addObject:ball];
        
        xPos += self.ballDiameter;
    }
    
    self.leftBall = self.balls[0];
    self.rigthBall = self.balls[ballCount - 1];
}

- (void)createReflection
{
    self.reflectionBalls = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat xPos = width / 2 - (ballCount / 2 + 0.5) * self.ballDiameter;
    CGFloat yPos = CGRectGetHeight(self.frame) / 2 + self.ballDiameter / 2 + 5;
    
    for (int i = 0; i < ballCount; i++)
    {
        UIView *reflectionBall = [self ball];
        reflectionBall.frame = CGRectMake(xPos, yPos, self.ballDiameter, self.ballDiameter);
        reflectionBall.transform = CGAffineTransformMakeRotation(M_PI);
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = reflectionBall.bounds;
        gradient.startPoint = CGPointMake(0.5, 1);
        gradient.endPoint = CGPointMake(0.5, 0);
        gradient.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.2].CGColor, (id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
        gradient.locations = @[@(0), @(0.35), @(1)];
        
        reflectionBall.layer.mask = gradient;

        [self addSubview:reflectionBall];
    
        [self.reflectionBalls addObject:reflectionBall];
        
        xPos += self.ballDiameter;
    }
    
    self.leftReflectionBall = self.reflectionBalls[0];
    self.rightReflectionBall = self.reflectionBalls[ballCount - 1];
}

- (UIView *)ball
{
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ballDiameter, self.ballDiameter)];
    ball.backgroundColor = self.ballColor;
    ball.layer.cornerRadius = self.ballDiameter / 2;
    ball.clipsToBounds = YES;
    return ball;
}

- (void)leftBallPendulate
{
    [self setAnchorPoint:CGPointMake(0.5, -ballPendulateRadiusFactor) forView:self.leftBall];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.leftBall.transform = CGAffineTransformMakeRotation(ballPendulateAngle);
                         self.leftReflectionBall.frame = CGRectMake(self.leftReflectionBall.frame.origin.x - self.offset, self.leftReflectionBall.frame.origin.y, self.leftReflectionBall.frame.size.width, self.leftReflectionBall.frame.size.height);
                         self.leftReflectionBall.alpha = 0.2f;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.leftBall.transform = CGAffineTransformMakeRotation(0);
                                              self.leftReflectionBall.frame = CGRectMake(self.leftReflectionBall.frame.origin.x + self.offset, self.leftReflectionBall.frame.origin.y, self.leftReflectionBall.frame.size.width, self.leftReflectionBall.frame.size.height);
                                              self.leftReflectionBall.alpha = 1.0f;
                                          } completion:^(BOOL finished) {
                                              if (_shouldAnimate)
                                              {
                                                  [self rightBallPendulate];
                                              }
                                          }];
                     }];
}

- (void)rightBallPendulate
{
    [self setAnchorPoint:CGPointMake(0.5, -ballPendulateRadiusFactor) forView:self.rigthBall];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.rigthBall.transform = CGAffineTransformMakeRotation(-ballPendulateAngle);
                         self.rightReflectionBall.frame = CGRectMake(self.rightReflectionBall.frame.origin.x + self.offset, self.rightReflectionBall.frame.origin.y, self.rightReflectionBall.frame.size.width, self.rightReflectionBall.frame.size.height);
                         self.rightReflectionBall.alpha = 0.2f;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.rigthBall.transform = CGAffineTransformMakeRotation(0);
                                              self.rightReflectionBall.frame = CGRectMake(self.rightReflectionBall.frame.origin.x - self.offset, self.rightReflectionBall.frame.origin.y, self.rightReflectionBall.frame.size.width, self.rightReflectionBall.frame.size.height);
                                              self.rightReflectionBall.alpha = 1.0f;
                                          } completion:^(BOOL finished) {
                                              if (_shouldAnimate)
                                              {
                                                  [self leftBallPendulate];
                                              }
                                          }];
                     }];

}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (void)startAnimating
{
    if (_animating)
    {
        return;
    }
    _animating = YES;
    _shouldAnimate = YES;
    
    [self leftBallPendulate];
}

- (void)stopAnimating
{
    if (!_animating)
    {
        return;
    }

    _animating = NO;
    _shouldAnimate = NO;
    
    if (_hidesWhenStopped)
    {
        // fade out to disappear
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (BOOL)isAnimating
{
    return _animating;
}

@end

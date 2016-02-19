//
//  WDProgressGrooeyLine.m
//  WDProgressGrooeyLine
//
//  Created by 吴迪玮 on 16/2/18.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import "WDProgressGrooeyLine.h"

#define CIRCLE_RADIUS 7

@interface WDProgressGrooeyLine()

@property (nonatomic,strong) CAShapeLayer *progressLayer;

@end

@implementation WDProgressGrooeyLine{
    NSInteger currentIndex_;
    NSInteger sumLength_;
    NSInteger posX_;
    
    CGPoint lastStartPoint_;
}

- (instancetype)initWithFrame:(CGRect)frame withColors:(NSArray *)colors withPointLengths:(NSArray *)lengths
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.pointColors = colors;
        self.pointLengths = lengths;
        self.distanceForVal = 23;//默认23
        self.valUnit = @"";
        posX_ = 2;
        sumLength_ = [(NSNumber *)[self.pointLengths valueForKeyPath:@"@sum.doubleValue"] integerValue]+4;
        self.clipsToBounds = NO;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    [self performSelector:@selector(animationCurrentPoint) withObject:nil afterDelay:1];
}

- (void)animationCurrentPoint {
    if (currentIndex_ == self.pointColors.count) {
        UIColor *lastColor = self.pointColors[currentIndex_++ -1];
        CGPoint lastEndPoint = CGPointMake(posX_, CIRCLE_RADIUS+2);
        [self drawCircle:lastEndPoint circleR:CIRCLE_RADIUS color:lastColor];
        [self initLabelInIndex:currentIndex_-2 center:CGPointMake((lastStartPoint_.x+lastEndPoint.x)/2, lastStartPoint_.y+self.distanceForVal) color:lastColor];
        [self notifyProgress];
        return;
    }
    
    CGPoint sPoint = CGPointMake(posX_, CIRCLE_RADIUS+2);
    posX_ += [self.pointLengths[currentIndex_] floatValue]/sumLength_*CGRectGetWidth(self.frame);
    CGPoint ePoint = CGPointMake(posX_, CIRCLE_RADIUS+2);
    
    UIColor *sColor = currentIndex_?self.pointColors[currentIndex_-1]:self.pointColors[currentIndex_];
    UIColor *eColor = self.pointColors[currentIndex_++];
    
    [self addBezierPathFrom:sPoint to:ePoint beginTime:0 duration:1 repeatTime:1 startColor:sColor endColor:eColor];
    
    if (currentIndex_>1) {
        [self drawCircle:sPoint circleR:CIRCLE_RADIUS color:sColor];
        [self initLabelInIndex:currentIndex_-2 center:CGPointMake((lastStartPoint_.x+sPoint.x)/2, sPoint.y+self.distanceForVal) color:sColor];
        [self notifyProgress];
        lastStartPoint_ = sPoint;
    }
    
    if (currentIndex_ <= self.pointColors.count) {
        [self performSelector:@selector(animationCurrentPoint) withObject:nil afterDelay:1];
    }
}

- (void)initLabelInIndex:(NSInteger)progress center:(CGPoint)point color:(UIColor *)color {
    NSInteger val = [self.pointLengths[progress] integerValue];
    
    NSMutableAttributedString *valText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@",val,self.valUnit]];
    [valText beginEditing];
    [valText addAttribute:NSFontAttributeName
                    value:self.valFont range:NSMakeRange(0, valText.length -self.valUnit.length)];
    [valText addAttribute:NSFontAttributeName
                    value:self.unitFont range:NSMakeRange(valText.length -self.valUnit.length, self.valUnit.length)];
    [valText endEditing];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = color;
    label.attributedText = valText;
    [label sizeToFit];
    label.center = point;
    [self addSubview:label];
}

- (void)notifyProgress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(notifyProgress:)]) {
        [self.delegate notifyProgress:currentIndex_-1];
    }
}

- (void)addBezierPathFrom:(CGPoint)sPoint
                       to:(CGPoint)ePoint
                beginTime:(NSInteger)beginTime
                 duration:(NSInteger)duration
               repeatTime:(NSInteger)rTime
               startColor:(UIColor *)sColor
                 endColor:(UIColor *)eColor
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineWidth = 5.0;
    path.lineCapStyle = kCGLineCapRound;  //线条拐角
    path.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [path moveToPoint:sPoint];
    
    [path addLineToPoint:ePoint];
    
    [path stroke];
    
    //遮罩层
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor=[UIColor whiteColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = 4;
    
    //渐变图层
    CGPoint gradientStartPoint;
    CGPoint gradientEndPoint;
    NSInteger xDiff = ePoint.x - sPoint.x;
    NSInteger yDiff = ePoint.y - sPoint.y;
    NSInteger xyDiff = labs(xDiff) - labs(yDiff);
    if (xyDiff > 0 ) {
        if (xDiff > 0 ) {
            gradientStartPoint = CGPointMake(0, 0);
            gradientEndPoint = CGPointMake(1, 0);
        } else {
            gradientStartPoint = CGPointMake(1, 0);
            gradientEndPoint = CGPointMake(0, 0);
        }
    } else {
        if (yDiff > 0 ) {
            gradientStartPoint = CGPointMake(0, 0);
            gradientEndPoint = CGPointMake(0, 1);
        } else {
            gradientStartPoint = CGPointMake(0, 1);
            gradientEndPoint = CGPointMake(0, 0);
        }
    }
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = _progressLayer.frame;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[sColor CGColor],(id)[eColor CGColor], nil]];
    [gradientLayer setLocations:@[@0,@1]];
    [gradientLayer setStartPoint:gradientStartPoint];
    [gradientLayer setEndPoint:gradientEndPoint];
    
    
    //用progressLayer来截取渐变层 遮罩
    [gradientLayer setMask:_progressLayer];
    [self.layer addSublayer:gradientLayer];
    
    //增加动画
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.beginTime = CACurrentMediaTime() + beginTime;
    pathAnimation.repeatDuration = rTime;
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses=NO;
    _progressLayer.path=path.CGPath;
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

- (void)drawCircle:(CGPoint)point
           circleR:(NSInteger)circleR
             color:(UIColor *)color {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:point radius:circleR startAngle:0.0 endAngle:180.0 clockwise:YES];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.fillColor =  color.CGColor;
    circleLayer.strokeColor=[UIColor whiteColor].CGColor;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineWidth = 1;
    circleLayer.path = path.CGPath;
    [self.layer addSublayer:circleLayer];
}

-(UIFont *)valFont{
    if (!_valFont) {
        _valFont = [UIFont fontWithName:@"DIN Condensed" size:18.0];
    }
    return _valFont;
}

-(UIFont *)unitFont{
    if (!_unitFont) {
        _unitFont = [UIFont fontWithName:@"DIN Condensed" size:12.0];
    }
    return _unitFont;
}

@end

//
//  WDProgressGrooeyLine.h
//  WDProgressGrooeyLine
//
//  Created by 吴迪玮 on 16/2/18.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WDProgressGrooeyLineDelegate <NSObject>

@optional
- (void)notifyProgress:(NSInteger)progressIndex;

@end

@interface WDProgressGrooeyLine : UIView

@property (weak, nonatomic) id<WDProgressGrooeyLineDelegate> delegate;

@property (strong, nonatomic) NSArray *pointColors;
@property (strong, nonatomic) NSArray *pointLengths;//最后以百分比形式

@property (strong, nonatomic) UIFont *valFont;
@property (strong, nonatomic) NSString *valUnit;
@property (strong, nonatomic) UIFont *unitFont;

@property (nonatomic) NSInteger distanceForVal;

- (instancetype)initWithFrame:(CGRect)frame withColors:(NSArray *)colors withPointLengths:(NSArray *)lengths;

@end

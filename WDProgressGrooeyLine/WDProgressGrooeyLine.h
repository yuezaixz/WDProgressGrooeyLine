//
//  WDProgressGrooeyLine.h
//  WDProgressGrooeyLine
//
//  Created by 吴迪玮 on 16/2/18.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDProgressGrooeyLine : UIView

@property (strong, nonatomic) NSArray *pointColors;
@property (strong, nonatomic) NSArray *pointLengths;//最后以百分比形式

- (instancetype)initWithFrame:(CGRect)frame withColors:(NSArray *)colors withPointLengths:(NSArray *)lengths;

@end

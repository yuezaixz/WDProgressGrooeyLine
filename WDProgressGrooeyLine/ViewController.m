//
//  ViewController.m
//  WDProgressGrooeyLine
//
//  Created by 吴迪玮 on 16/2/18.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    WDProgressGrooeyLine *line = [[WDProgressGrooeyLine alloc] initWithFrame:CGRectMake(100, 100, 200, 200)
                                                                  withColors:@[
                                                                               [UIColor colorWithRed:233.0/255.0 green:85.0/255.0 blue:19.0/255.0 alpha:1],
                                                                               [UIColor colorWithRed:245.0/255 green:166.0/255 blue:35.0/255 alpha:1],
                                                                               [UIColor colorWithRed:126.0/255 green:211.0/255 blue:33.0/255 alpha:1],
                                                                               [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1]
                                                                               ]
                                                            withPointLengths:@[@76,@120,@54,@80]];
    line.delegate = self;
    [self.view addSubview:line];
}

-(void)notifyProgress:(NSInteger)progressIndex{
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)progressIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import "ViewController.h"
#import <libextobjc/EXTScope.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self scrollViewInitalSetup];
    [self bindViewModel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel {
    @weakify(self);
    [[RACObserve(self.viewModel, hasUpdatedContent) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self addButtonsToContentView];
    }];
}


#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}


#pragma mark - Scaling
- (void)scrollViewInitalSetup {
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.delegate = self;
}

- (void)setViewsWidth:(NSInteger)width height:(NSInteger)height {
//    NSLog(@"%f  %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
//    NSLog(@"%f  %f", self.contentView.frame.origin.x, self.contentView.frame.origin.y);
    
    CGRect newFrame = self.contentView.frame;
    
    newFrame.size.width = width;
    newFrame.size.height = height;
    
    self.scrollView.contentSize = CGSizeMake(width, height);
    [self.contentView setFrame:newFrame];
}


#pragma mark - Buttons
- (void)addButtonsToContentView {
    NSInteger rowsCount = [self.viewModel rowsCount];
    NSInteger columnsCount = [self.viewModel columnsCount];
    
    if (rowsCount == 0 || columnsCount == 0)
        return;
    
    NSInteger width = columnsCount * buttonAspectSize + columnsCount * buttonDelimiter + buttonDelimiter;
    NSInteger height = rowsCount * buttonAspectSize + rowsCount * buttonDelimiter + buttonDelimiter;
    [self setViewsWidth:width height:height];
    
    
    for (int i = 0; i < rowsCount; i++) {
        for (int j = 0; j < columnsCount; j++) {
            UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            newButton.bounds = CGRectMake(0, 0, buttonAspectSize, buttonAspectSize);
            newButton.center = CGPointMake(buttonAspectSize / 2 + buttonDelimiter + (buttonAspectSize + buttonDelimiter) * j,
                                           buttonAspectSize / 2 + buttonDelimiter + (buttonAspectSize + buttonDelimiter) * i);

            [newButton setBackgroundColor:[UIColor colorWithRed:0.4 green:0.7 blue:0.1 alpha:1]];

            [newButton setTag:i + j];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapGestureHandler:)];
            [newButton addGestureRecognizer:tapGesture];
            [self.contentView addSubview:newButton];
        }
    }
    
    
    
//    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    newButton.bounds = CGRectMake(0, 0, buttonAspectSize, buttonAspectSize);
//    newButton.center = CGPointMake(buttonAspectSize, buttonAspectSize);
//    [newButton setBackgroundColor:[UIColor colorWithRed:0.4 green:0.7 blue:0.1 alpha:1]];
//    [newButton setTag:2];
//
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapGestureHandler:)];
//    [newButton addGestureRecognizer:tapGesture];
//
//    [self.contentView addSubview:newButton];
}

- (void)buttonTapGestureHandler:(UIGestureRecognizer *)gestureRecognizer {
    UIColor *freeSeatColor = [UIColor colorWithRed:0.4 green:0.7 blue:0.1 alpha:1];
    UIColor *chosenSeatColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.7 alpha:1];
    
    
    UIButton *tappedButton = (UIButton *)gestureRecognizer.view;
    if ([tappedButton.backgroundColor isEqual:freeSeatColor]) {
        tappedButton.backgroundColor = chosenSeatColor;
    } else {
        tappedButton.backgroundColor = freeSeatColor;
    }
    
//    NSInteger tag = tappedButton.tag;
//    NSLog(@"%i", tag);
}
@end

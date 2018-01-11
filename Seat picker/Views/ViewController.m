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
@property (strong, nonatomic) UIColor *selectedSeatColor;
@property double buttonAspectSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.totalAmount.text = @"";
    self.selectedSeatColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.05 alpha:1.0];
    
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
        [self calculateButtonSize];
        [self addButtonsToContentView];
        [self addLegend];
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
    CGRect newFrame = self.contentView.frame;
    
    newFrame.size.width = width;
    newFrame.size.height = height;
    
    [self.contentView setFrame:newFrame];
    
    self.scrollView.contentSize = CGSizeMake(width, height);
    newFrame.origin = self.scrollView.frame.origin;
    [self.scrollView setFrame:newFrame];
}


#pragma mark - Buttons
- (void)calculateButtonSize {
    NSInteger columnsCount = [self.viewModel columnsCount];
    
    if (columnsCount == 0) {
        return;
    }
    
    self.buttonAspectSize = (self.scrollView.frame.size.width - (columnsCount + 1) * buttonDelimiter) / columnsCount;
}

- (void)addButtonsToContentView {
    NSInteger rowsCount = [self.viewModel rowsCount];
    NSInteger columnsCount = [self.viewModel columnsCount];
    NSInteger currentCellIndex = 0;
    
    if (rowsCount == 0 || columnsCount == 0)
        return;
    
    NSInteger width = columnsCount * self.buttonAspectSize + columnsCount * buttonDelimiter + buttonDelimiter;
    NSInteger height = rowsCount * self.buttonAspectSize + rowsCount * buttonDelimiter + buttonDelimiter;
    [self setViewsWidth:width height:height];
    
    
    for (int i = 0; i < rowsCount; i++) {
        for (int j = 0; j < columnsCount; j++, currentCellIndex++) {
            UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            newButton.bounds = CGRectMake(0, 0, self.buttonAspectSize, self.buttonAspectSize);
            newButton.center = CGPointMake(self.buttonAspectSize / 2 + buttonDelimiter + (self.buttonAspectSize + buttonDelimiter) * j,
                                           self.buttonAspectSize / 2 + buttonDelimiter + (self.buttonAspectSize + buttonDelimiter) * i);

            [newButton setTag:currentCellIndex];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapGestureHandler:)];
            
            if ([self.viewModel isEnabled:currentCellIndex]) {
                [newButton setEnabled:YES];
                [newButton setBackgroundColor:[self.viewModel getBackgroundColor:currentCellIndex]];
                [newButton addGestureRecognizer:tapGesture];
            } else {
                [newButton setEnabled:NO];
            }

            [self.contentView addSubview:newButton];
        }
    }
}

- (void)buttonTapGestureHandler:(UIGestureRecognizer *)gestureRecognizer {
    UIButton *tappedButton = (UIButton *)gestureRecognizer.view;
    NSInteger buttonTag = tappedButton.tag;
    UIColor *seatColor = [self.viewModel getBackgroundColor:buttonTag];
    
    if ([self.viewModel availableSeat:buttonTag]) {
        if ([tappedButton.backgroundColor isEqual:self.selectedSeatColor]) {
            [tappedButton setBackgroundColor:seatColor];
            self.totalAmount.text = [self.viewModel recountTotals:buttonTag withOperation:NumericOperationSubtract];
        } else {
            [tappedButton setBackgroundColor:self.selectedSeatColor];
            self.totalAmount.text = [self.viewModel recountTotals:buttonTag withOperation:NumericOperationAdd];
        }
    }
    
    NSLog(@"%li", tappedButton.tag);
}


# pragma mark - Legend
- (void)addLegend {
    NSInteger labelsCount = [self.viewModel getLegendLabelsCount];
    
    for (int i = 0; i < labelsCount; i++) {
        UIView *labelLegendColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, legendLabelColorAspectSize, legendLabelColorAspectSize)];
        [labelLegendColor setBackgroundColor:[self.viewModel getLegendLabelColorWithIndex:i]];
        [labelLegendColor setCenter:CGPointMake(legendLabelColorAspectSize / 2, legendLabelColorAspectSize / 2)];
        
        UILabel *legendText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, legendTextLabelWidth, legendTextLabelHeight)];
        legendText.text = [NSString stringWithFormat:@" - %@", [self.viewModel getLegendLabelTextWithIndex:i]];
        [legendText setCenter:CGPointMake(legendLabelColorAspectSize + legendTextLabelWidth / 2, legendLabelColorAspectSize / 2)];
        
        CGRect newFrame = CGRectMake(0, 0, legendLabelColorAspectSize + legendTextLabelWidth, legendLabelColorAspectSize);
        UIView *stackView = [[UIView alloc] initWithFrame:newFrame];
        [stackView addSubview:labelLegendColor];
        [stackView addSubview:legendText];
        
        [stackView setCenter: CGPointMake((legendLabelColorAspectSize + legendTextLabelWidth) / 2 + buttonDelimiter + (legendLabelColorAspectSize + legendTextLabelWidth) * i,
                                          legendLabelColorAspectSize / 2 + buttonDelimiter)]; // + (legendLabelColorAspectSize + buttonDelimiter) * i
        
        
//        CGRect newFrame = legendText.frame;
//        legendText setCenter:<#(CGPoint)#>
//        legendText.center.y = stackView.frame.size.y / 2;
        
        [self.legendView addSubview:stackView];
    }
}
@end

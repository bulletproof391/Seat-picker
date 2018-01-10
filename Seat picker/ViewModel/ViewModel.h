//
//  ViewModel.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SeatsModel.h"


typedef NS_ENUM(NSInteger, NumericOperation) {
    NumericOperationAdd,
    NumericOperationSubtract,
};

@interface ViewModel : NSObject

@property (strong, nonatomic) RACSignal *hasUpdatedContent;

- (instancetype)initWithModel:(SeatsModel *)model;
- (NSInteger)rowsCount;
- (NSInteger)columnsCount;
- (BOOL)isEnabled:(NSInteger)buttonTag;
- (BOOL)availableSeat:(NSInteger)buttonTag;
- (UIColor *)getBackgroundColor:(NSInteger)buttonTag;
- (NSString *)recountTotals:(NSInteger)buttonTag withOperation:(NumericOperation)operation;


- (NSInteger)getLegendLabelsCount;
- (UIColor *)getLegendLabelColorWithIndex:(NSInteger)index;
- (NSString *)getLegendLabelTextWithIndex:(NSInteger)index;
@end

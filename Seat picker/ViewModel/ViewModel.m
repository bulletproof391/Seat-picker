//
//  ViewModel.m
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import "ViewModel.h"

@interface ViewModel ()

@property (nonatomic, strong) SeatsModel *model;
@property (nonatomic, strong) Sector *sector;
@property NSInteger totalAmount;

@end


@implementation ViewModel

- (instancetype)initWithModel:(SeatsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [RACObserve(self.model, sectorSignal) subscribeNext:^(id x) {
            self.sector = [x valueForKey:@"value"];
            self.hasUpdatedContent = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                return nil;
            }];
        }];
    }
    
    return self;
}

# pragma mark - Seats
- (NSInteger)rowsCount {
    return (self.sector) ? self.sector.rowsCount : 0;
}

- (NSInteger)columnsCount {
    return (self.sector) ? self.sector.columnsCount : 0;
}

- (BOOL)isEnabled:(NSInteger)buttonTag {
    return self.sector.seats[buttonTag].enabled;
}

- (UIColor *)getBackgroundColor:(NSInteger)buttonTag {
    return self.sector.seats[buttonTag].color;
}

- (BOOL)availableSeat:(NSInteger)buttonTag {
    return self.sector.seats[buttonTag].isAvailable;
}

- (NSString *)recountTotals:(NSInteger)buttonTag withOperation:(NumericOperation)operation{
    switch (operation) {
        case NumericOperationAdd:
            self.totalAmount += self.sector.seats[buttonTag].price;
            break;
            
        case NumericOperationSubtract:
            self.totalAmount -= self.sector.seats[buttonTag].price;
            break;
    }
    
    return [NSString stringWithFormat:@"%li", self.totalAmount];
}


# pragma mark - Legend
- (NSInteger)getLegendLabelsCount {
    return self.sector.legend.count;
}

- (UIColor *)getLegendLabelColorWithIndex:(NSInteger)index {
    return self.sector.legend[index].color;
}

- (NSString *)getLegendLabelTextWithIndex:(NSInteger)index {
    return self.sector.legend[index].caption;
}
@end

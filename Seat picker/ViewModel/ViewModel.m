//
//  ViewModel.m
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import "ViewModel.h"
#import "Sector.h"

@interface ViewModel ()

@property (nonatomic, strong) SeatsModel *model;
@property (nonatomic, strong) Sector *sector;

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
@end

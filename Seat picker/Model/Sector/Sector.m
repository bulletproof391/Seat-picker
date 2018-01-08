//
//  Sector.m
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 07.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import "Sector.h"

@implementation Sector

- (instancetype)init {
    self = [super init];
    if (self) {
        _legend = [[NSMutableArray alloc] init];
        _seats = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end

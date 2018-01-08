//
//  SeatsModel.m
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import "SeatsModel.h"
#import "Networking.h"

@interface SeatsModel ()

@end


@implementation SeatsModel

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    
    if (self) {        
        NSString *URLString = [NSString stringWithFormat:@"%@", URL];
        Networking *request = [[Networking alloc] initWithURL:URLString];
        [request downloadData:^(NSData *seatsData) {
            self.sectorSignal = [self mapDataToModel:seatsData];
        }];
    }
    
    return self;
}

-(RACSignal *)mapDataToModel:(NSData *)data {
    NSError *error;
    Sector *sector = [[Sector alloc] init];
    NSDictionary *sectorDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&error];
    
    if (error) {
        NSLog(@"%@", [error description]);
        [RACSignal return:nil];
    }
    
    sector.identifier = [sectorDictionary objectForKey:@"id"];
    sector.caption = [sectorDictionary objectForKey:@"caption"];
    sector.rowsCount = ((NSNumber *)[sectorDictionary objectForKey:@"r"]).integerValue;
    sector.columnsCount = ((NSNumber *)[sectorDictionary objectForKey:@"n"]).integerValue;
    sector.ticketsCount = ((NSNumber *)[sectorDictionary objectForKey:@"tc"]).integerValue;
    

    NSArray<NSDictionary *> *legend = [sectorDictionary objectForKey:@"pz"];
    for (NSDictionary *item in legend) {
        unsigned int num;
        Legend *newLegend = [[Legend alloc] init];
        
        newLegend.caption = [item objectForKey:@"caption"];
        
        NSString *stringColor = [NSString stringWithFormat:@"0x%@", [item objectForKey:@"color"]];
        NSScanner *scanner = [[NSScanner alloc] initWithString:stringColor];
        if ([scanner scanHexInt:&num])
            newLegend.color = UIColorFromRGB(num);
        
        newLegend.sort = ((NSNumber *)[item objectForKey:@"sort"]).integerValue;
        newLegend.price = ((NSNumber *)[item objectForKey:@"price"]).integerValue;
        
        [sector.legend addObject:newLegend];
    }

    NSArray<NSDictionary *> *seats = [sectorDictionary objectForKey:@"seats"];
    for (NSDictionary *item in seats) {
        unsigned int num;
        Seat *seat = [[Seat alloc] init];
        
        seat.identifier = [item objectForKey:@"id"];
        seat.row = ((NSNumber *)[item objectForKey:@"r"]).integerValue;
        seat.column = ((NSNumber *)[item objectForKey:@"n"]).integerValue;
        seat.rowInSector = ((NSNumber *)[item objectForKey:@"rc"]).integerValue;
        seat.columnInSector = ((NSNumber *)[item objectForKey:@"nc"]).integerValue;
        seat.enabled = ((NSString *)[item objectForKey:@"ss"]).boolValue;
        seat.price = ((NSNumber *)[item objectForKey:@"price"]).integerValue;
        seat.isAvailable = ((NSString *)[item objectForKey:@"a"]).boolValue;
        
        NSString *stringColor = [NSString stringWithFormat:@"0x%@", [item objectForKey:@"c"]];
        NSScanner *scanner = [[NSScanner alloc] initWithString:stringColor];
        if ([scanner scanHexInt:&num])
            seat.color = UIColorFromRGB(num);
        
        [sector.seats addObject:seat];
    }
    
    NSLog(@"data downloaded");
    return [RACSignal return:sector];
}

@end

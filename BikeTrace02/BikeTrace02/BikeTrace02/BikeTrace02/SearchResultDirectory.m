//
//  SearchResultDirectory.m
//  BikeTrace02
//
//  Created by Al Carter on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResultDirectory.h"
#import "SearchResult.h"

@implementation SearchResultDirectory
@synthesize searchResultList;

- (id) init{
    if(self){
        self.searchResultList = [[NSMutableArray alloc] init];
    } 
    
    //temp data added to array.
    
    SearchResult * sr1 = [[SearchResult alloc] init];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 37.810000;
    theCoordinate.longitude = -122.477989;
    sr1.coordinate = theCoordinate;
    [self.searchResultList addObject:sr1];
    
    SearchResult * sr2 = [[SearchResult alloc] init];
//    CLLocationCoordinate2D secondCoordinate;
//    secondCoordinate.latitude = 37.810000;
//    secondCoordinate.longitude = -122.477989;
//    sr2.coordinate = secondCoordinate;
    [self.searchResultList addObject:sr2];
    
    //end temp data section.
    
    return self;
}

- (id) initWithArray:(NSMutableArray *)array{
    if(self){
        self.searchResultList = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

@end

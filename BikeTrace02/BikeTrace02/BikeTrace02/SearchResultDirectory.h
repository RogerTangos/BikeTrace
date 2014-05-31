//
//  SearchResultDirectory.h
//  BikeTrace02
//
//  Created by Al Carter on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"

@interface SearchResultDirectory : NSObject{
    NSMutableArray * searchResultList;
}

@property (readwrite, strong) NSMutableArray * searchResultList;

- (id) init;
- (id) initWithArray:(NSMutableArray *)array;

@end

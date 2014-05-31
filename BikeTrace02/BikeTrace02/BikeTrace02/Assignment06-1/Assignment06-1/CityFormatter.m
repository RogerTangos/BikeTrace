//
//  CityFormatter.m
//  Assignment06-1
//
//  Created by Al Carter on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityFormatter.h"

@implementation CityFormatter

-(NSString *)formatCity:(NSString *)input {
    
    input = [[input componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSString *firstChar = [input substringToIndex:1];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
    input = [[folded uppercaseString] stringByAppendingString:[input substringFromIndex:1]];
    //    abé -> Ab
    
    return input;
}

@end

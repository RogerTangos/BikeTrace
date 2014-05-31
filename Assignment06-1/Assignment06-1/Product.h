//
//  Product.h
//  Assignment06-1
//
//  Created by Al Carter on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
	NSString *type;
	NSString *name;
}

@property (nonatomic, copy) NSString *type, *name;

+ (id)productWithType:(NSString *)type name:(NSString *)name;

@end
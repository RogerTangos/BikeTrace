//
//  Product.m
//  Assignment06-1
//
//  Created by Al Carter on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize type, name;


+ (id)productWithType:(NSString *)type name:(NSString *)name
{
	Product *newProduct = [[self alloc] init];
	newProduct.type = type;
	newProduct.name = name;
	return newProduct;
}

@end
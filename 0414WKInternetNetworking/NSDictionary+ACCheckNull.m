//
//  NSDictionary+ACCheckNull.m
//  0414WKInternetNetworking
//
//  Created by NEIL on 2015/4/14.
//  Copyright (c) 2015年 NEIL. All rights reserved.
//

#import "NSDictionary+ACCheckNull.h"

@implementation NSDictionary (ACCheckNull)


-(BOOL)Checknumber:(NSString *)data{
   return [self objectForKey:data] && [self objectForKey:data] != [NSNull null];
}

@end

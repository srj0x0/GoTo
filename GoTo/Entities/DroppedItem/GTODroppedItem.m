//
//  GTODroppedItem.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/30/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTODroppedItem.h"

@interface GTODroppedItem()

@property (strong, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString * _Nullable name;

@end

@implementation GTODroppedItem

+ (instancetype)itemWithURL:(NSURL *)url name:(NSString * _Nullable)name {
    return [[self alloc] initWithURL:url andName:name];
}

- (instancetype)initWithURL:(NSURL *)url andName:(NSString *)name {
    self = [super init];
    if (self) {
        _url = url;
        _name = name;
    }
    return self;
}

@end

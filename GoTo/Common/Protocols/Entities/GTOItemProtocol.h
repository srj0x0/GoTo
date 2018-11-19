//
//  GTOItemProtocol.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/12/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTOItemProtocol <NSObject>

- (NSURL *)url;
- (NSString * _Nullable)name;

@end

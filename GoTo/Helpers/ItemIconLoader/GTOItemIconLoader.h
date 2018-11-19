//
//  GTOItemIconLoader.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTOItemIconLoader <NSObject>

- (NSImage *)iconForItemWithURL:(NSURL *)url;

@end

//
//  GTONibReusableView.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/5/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTONibReusableView

+ (NSString *)reuseIdentifier;
+ (NSNib *)nib;

@end

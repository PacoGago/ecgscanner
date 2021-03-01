//
//  OpenCVWrapper.h
//  scannerecg
//
//  Created by Paco Gago on 20/02/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

+ (UIImage *)toGray:(UIImage *)source;
+ (UIImage *)im2bw:(UIImage *)source;

@end

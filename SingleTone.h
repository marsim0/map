//
//  SingleTone.h
//  map
//
//  Created by Мариам Б. on 17.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTone : NSObject
@property (strong,nonatomic) NSMutableArray * addressArray;
+ (SingleTone *) sharedSingleTone;
- (void) makeAddressArray;

@end

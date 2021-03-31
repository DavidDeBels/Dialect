//
//  UITextField+DIALocalizable.m
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import "UITextField+DIALocalizable.h"



// MARK: - UITextField DIALocalizable Category Implementation

@implementation UITextField (DIALocalizable)

// MARK: DIALocalizable

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(void (^)(NSString * _Nonnull, NSString * _Nullable, UITextField * _Nonnull))onUpdate {
    [super setLocalizationKey:localizationKey onUpdate:(void (^)(NSString *, NSString *, id<DIALocalizable>))onUpdate];
}

- (void)setLocalizationKey:(NSString *)localizationKey table:(NSString *)table onUpdate:(void (^)(NSString * _Nonnull, NSString * _Nullable, UITextField * _Nonnull))onUpdate {
    [super setLocalizationKey:localizationKey table:table onUpdate:(void (^)(NSString *, NSString *, id<DIALocalizable>))onUpdate];
}

@end

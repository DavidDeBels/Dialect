//
//  UITextField+DIALocalizable.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+DIALocalizable.h"

NS_ASSUME_NONNULL_BEGIN



// MARK: - UITextField DIALocalizable Category Interface

@interface UITextField (DIALocalizable)

// MARK: DIALocalizable

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, UITextField *textField))onUpdate NS_SWIFT_NAME(setLocalization(key:onUpdate:));

- (void)setLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, UITextField *textField))onUpdate NS_SWIFT_NAME(setLocalization(key:table:onUpdate:));

@end

NS_ASSUME_NONNULL_END

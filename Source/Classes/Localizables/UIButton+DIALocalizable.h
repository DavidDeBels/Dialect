//
//  UIButton+DIALocalizable.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+DIALocalizable.h"

NS_ASSUME_NONNULL_BEGIN



// MARK: - UIButton DIALocalizable Category Interface

@interface UIButton (DIALocalizable)

// MARK: DIALocalizable

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, UIButton *button))onUpdate NS_SWIFT_NAME(setLocalization(key:onUpdate:));

- (void)setLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, UIButton *button))onUpdate NS_SWIFT_NAME(setLocalization(key:table:onUpdate:));

// MARK: UIButton specific

- (void)setTitleForLocalizationKey:(NSString *)localizationKey forState:(UIControlState)state NS_SWIFT_NAME(setTitleForLocalization(key:state:));

- (void)setTitleForLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table forState:(UIControlState)state NS_SWIFT_NAME(setTitleForLocalization(key:table:state:));

- (void)setTitleForLocalizationKey:(NSString *)localizationKey replace:(nullable NSDictionary<NSString *, NSString *> *)replace forState:(UIControlState)state NS_SWIFT_NAME(setTitleForLocalization(key:replace:state:));

- (void)setTitleForLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table bundle:(nullable NSBundle *)bundle replace:(nullable NSDictionary<NSString *, NSString *> *)replace forState:(UIControlState)state NS_SWIFT_NAME(setTitleForLocalization(key:table:bundle:replace:state:));

@end

NS_ASSUME_NONNULL_END

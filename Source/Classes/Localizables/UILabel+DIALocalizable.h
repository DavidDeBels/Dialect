//
//  UILabel+DIALocalizable.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+DIALocalizable.h"

NS_ASSUME_NONNULL_BEGIN



// MARK: - UILabel DIALocalizable Category Interface

@interface UILabel (DIALocalizable)

// MARK: DIALocalizable

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, UILabel *label))onUpdate NS_SWIFT_NAME(setLocalization(key:onUpdate:));

- (void)setLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, UILabel *label))onUpdate NS_SWIFT_NAME(setLocalization(key:table:onUpdate:));

// MARK: UILabel specific

- (void)setTextForLocalizationKey:(NSString *)localizationKey NS_SWIFT_NAME(setTextForLocalization(key:));

- (void)setTextForLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table NS_SWIFT_NAME(setTextForLocalization(key:table:));

- (void)setTextForLocalizationKey:(NSString *)localizationKey replace:(nullable NSDictionary<NSString *, NSString *> *)replace NS_SWIFT_NAME(setTextForLocalization(key:replace:));

- (void)setTextForLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table bundle:(nullable NSBundle *)bundle replace:(nullable NSDictionary<NSString *, NSString *> *)replace NS_SWIFT_NAME(setTextForLocalization(key:table:bundle:replace:));

@end

NS_ASSUME_NONNULL_END

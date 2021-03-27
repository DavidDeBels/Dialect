//
//  DIALocalizable.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



// MARK: - DIALocalizable Protocol

@protocol DIALocalizable <NSObject>

@property (nonatomic, copy, readonly, nullable) NSString *dialectLocalizationKey;
@property (nonatomic, copy, readonly, nullable) NSString *dialectLocalizationTable;

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, id<DIALocalizable> object))onUpdate NS_SWIFT_NAME(setLocalization(key:onUpdate:));

- (void)setLocalizationKey:(NSString *)localizationKey table:(nullable NSString *)table onUpdate:(nullable void (^)(NSString *key, NSString * _Nullable table, id<DIALocalizable> object))onUpdate  NS_SWIFT_NAME(setLocalization(key:table:onUpdate:));;

- (void)removeLocalization;

- (void)dialect_updateLocalization;

@end

NS_ASSUME_NONNULL_END

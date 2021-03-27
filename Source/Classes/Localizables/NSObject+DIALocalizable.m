//
//  NSObject+DIALocalizable.m
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+DIALocalizable.h"

#import "DIALocalization+Private.h"

static void *kDIALocalizationKeyPropertyKey = &kDIALocalizationKeyPropertyKey;
static void *kDIALocalizationTablePropertyKey = &kDIALocalizationTablePropertyKey;
static void *kDIALocalizationBlockPropertyKey = &kDIALocalizationBlockPropertyKey;



// MARK: - NSObject DIALocalizable Category Implementation

@implementation NSObject (DIALocalizable)

- (NSString *)dialectLocalizationKey {
    return objc_getAssociatedObject(self, kDIALocalizationKeyPropertyKey);
}

- (NSString *)dialectLocalizationTable {
    return objc_getAssociatedObject(self, kDIALocalizationTablePropertyKey);
}

- (void)setLocalizationKey:(nonnull NSString *)localizationKey onUpdate:(nullable void (^)(NSString * _Nonnull, NSString * _Nullable, id<DIALocalizable> _Nonnull))onUpdate {
    [self setLocalizationKey:localizationKey table:nil onUpdate:onUpdate];
}

- (void)setLocalizationKey:(nonnull NSString *)localizationKey table:(nullable NSString *)table onUpdate:(nullable void (^)(NSString * _Nonnull, NSString * _Nullable, id<DIALocalizable> _Nonnull))onUpdate {
    objc_setAssociatedObject(self, kDIALocalizationKeyPropertyKey, localizationKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kDIALocalizationTablePropertyKey, table, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kDIALocalizationBlockPropertyKey, onUpdate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    [Dialect addLocalizable:self];
    
    if (onUpdate) {
        onUpdate(self.dialectLocalizationKey, self.dialectLocalizationTable, self);
    }
}

- (void)removeLocalization {
    objc_setAssociatedObject(self, kDIALocalizationKeyPropertyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kDIALocalizationTablePropertyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kDIALocalizationBlockPropertyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [Dialect removeLocalizable:self];
}

- (void)dialect_updateLocalization {
    void (^completion)(NSString *, NSString *, id<DIALocalizable>) = objc_getAssociatedObject(self, kDIALocalizationBlockPropertyKey);
    if (completion) {
        completion(self.dialectLocalizationKey, self.dialectLocalizationTable, self);
    }
}

@end

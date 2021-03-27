//
//  Dialect+Private.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import "DIALocalization.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dialect (Private)

+ (void)addLocalizable:(id<DIALocalizable>)localizableObject;

+ (void)removeLocalizable:(id<DIALocalizable>)localizableObject;

@end

NS_ASSUME_NONNULL_END

//
//  DIALocalizedString.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#ifndef DIALocalizedString_h
#define DIALocalizedString_h

#define DIALocalizedString(key, comment) \
        [Dialect stringFor:(key) table:nil bundle:nil defaultValue:@"" replace:nil]
#define DIALocalizedStringFromTable(key, tbl, comment) \
        [Dialect stringFor:(key) table:(tbl) bundle:nil defaultValue:@"" replace:nil]
#define DIALocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
        [Dialect stringFor:(key) table:(tbl) bundle:(bundle) defaultValue:@"" replace:nil]
#define DIALocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
        [Dialect stringFor:(key) table:(tbl) bundle:(bundle) defaultValue:(val) replace:nil]

#endif /* DIALocalizedString_h */

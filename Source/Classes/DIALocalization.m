//
//  Dialect.m
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import "DIALocalization.h"



// MARK: Dialect Implementation

@implementation Dialect

+ (void)load {
    // Load default table
    NSString *filePath = [self filePathForTable:nil];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (fileExists) {
        [self loadFromDiskAtPath:filePath table:nil];
    }
    
    // Load custom tables
    NSString *directory = [self directoryForTable:@""];
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    for (NSString *file in directoryContents) {
        NSString *table = [file stringByDeletingPathExtension];
        NSString *filePath = [directory stringByAppendingString:file];
        
        if (table && filePath) {
            [self loadFromDiskAtPath:filePath table:table];
        }
    }
}

+ (void)loadFromDiskAtPath:(NSString *)filePath table:(NSString *)table {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSError *parseError = nil;
        id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
        if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = (NSDictionary *)JSONObject;
            
            // Store in memory
            if (!table) {
                _mainTableDictionary = dictionary;
            } else {
                NSMutableDictionary *customTableDictionaries = [self customTableDictionaries];
                [customTableDictionaries setObject:dictionary forKey:table];
            }
        }
    }
}



// MARK: Helper functions

+ (NSString *)directoryForTable:(NSString *)table {
    NSString* directory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/dialect/"];
    if (table) {
        directory = [directory stringByAppendingString:@"tables/"];
    }
    
    return directory;
}

+ (NSString *)filePathForTable:(NSString *)table {
    NSString *filename = @"main.json";
    if (table) {
        filename = [NSString stringWithFormat:@"%@.json", table];
    }
    
    NSString *filePath = [[self directoryForTable:table] stringByAppendingString:filename];
    return filePath;
}



// MARK: Store localization dictionaries

static NSDictionary *_mainTableDictionary = nil;
+ (NSDictionary *)mainTableDictionary {
    return _mainTableDictionary;
}

+ (NSMutableDictionary *)customTableDictionaries {
    static NSMutableDictionary *_customTableDictionaries;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _customTableDictionaries = [[NSMutableDictionary alloc] init];
    });

    return _customTableDictionaries;
}



// MARK: Store localizable objects

+ (NSHashTable *)mainTableLocalizables {
    static NSHashTable *_mainTableLocalizables;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mainTableLocalizables = [NSHashTable weakObjectsHashTable];
    });

    return _mainTableLocalizables;
}

+ (NSMutableDictionary *)customTableLocalizables {
    static NSMutableDictionary *_customTableLocalizables;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _customTableLocalizables = [[NSMutableDictionary alloc] init];
    });

    return _customTableLocalizables;
}

+ (void)addLocalizable:(id<DIALocalizable>)localizableObject {
    if (localizableObject) {
        NSString *table = localizableObject.dialectLocalizationTable;

        NSHashTable *hashTable = [self mainTableLocalizables];
        if (table) {
            hashTable = [[self customTableLocalizables] objectForKey:table];
            if (!hashTable) {
                hashTable = [NSHashTable weakObjectsHashTable];
            }
            [[self customTableLocalizables] setObject:hashTable forKey:table];
        }
        
        [hashTable addObject:localizableObject];
    }
}

+ (void)removeLocalizable:(id<DIALocalizable>)localizableObject {
    if (localizableObject) {
        NSString *table = localizableObject.dialectLocalizationTable;
        
        NSHashTable *hashTable = [self mainTableLocalizables];
        if (table) {
            hashTable = [[self customTableLocalizables] objectForKey:table];
            [hashTable removeObject:localizableObject];
            
            if (hashTable.count == 0) {
                [[self customTableLocalizables] removeObjectForKey:table];
            }
        } else {
            [hashTable removeObject:localizableObject];
        }
    }
}



// MARK: Get localization dictionary

+ (NSDictionary<NSString *, NSString *> *)localizationDictionaryForTable:(NSString *)table {
    if (!table) {
        return [self mainTableDictionary];
    } else {
        return [[self customTableDictionaries] objectForKey:table];
    }
}



// MARK: Set localization dictionary

+ (void)setLocalizationDictionary:(NSDictionary<NSString *, NSString *> *)dictionary table:(NSString *)table update:(BOOL)update storeOnDisk:(BOOL)store {
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Store in memory
            NSDictionary *previousDictionary = nil;
            if (!table) {
                previousDictionary = _mainTableDictionary;
                _mainTableDictionary = dictionary;
            } else {
                NSMutableDictionary *customTableDictionaries = [self customTableDictionaries];
                previousDictionary = [customTableDictionaries objectForKey:table];
                [customTableDictionaries setObject:dictionary forKey:table];
            }
            
            // Update localizable objects
            if (update) {
                [self updateLocalizablesForTable:table previousDictionary:previousDictionary newDictionary:dictionary force:NO];
            }
            
            // Store on disk
            if (store) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Create the directory if needed
                    BOOL* isDirectory = NULL;
                    NSString *directory = [self directoryForTable:table];
                    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:isDirectory];
                    if (!directoryExists) {
                        NSError* error = NULL;
                        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
                    }
                    
                    // Write to disk
                    NSError *parseError = nil;
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
                
                    if (data && !parseError) {
                        NSString *filePath = [self filePathForTable:table];
                        NSDictionary *attributes = @{
                            NSFileCreationDate: [NSDate date],
                            NSFileSize: @(data.length)
                        };
                        
                        [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes];
                    }
                });
            }
        });
    }
}

+ (void)removeLocalizationDictionaryForTable:(NSString *)table update:(BOOL)update removeFromDisk:(BOOL)removeFromDisk {
    [self removeLocalizationDictionaryForTable:table update:update unlink:NO removeFromDisk:removeFromDisk];
}

+ (void)removeLocalizationDictionaryForTable:(NSString *)table unlink:(BOOL)unlink removeFromDisk:(BOOL)removeFromDisk {
    [self removeLocalizationDictionaryForTable:table update:NO unlink:unlink removeFromDisk:removeFromDisk];
}

+ (void)removeLocalizationDictionaryForTable:(NSString *)table update:(BOOL)update unlink:(BOOL)unlink removeFromDisk:(BOOL)removeFromDisk {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Remove from memory
        NSDictionary *previousDictionary = nil;
        if (!table) {
            previousDictionary = _mainTableDictionary;
            _mainTableDictionary = nil;
        } else {
            NSMutableDictionary *customTableDictionaries = [self customTableDictionaries];
            previousDictionary = [customTableDictionaries objectForKey:table];
            [customTableDictionaries removeObjectForKey:table];
        }
        
        // Update localizable objects
        if (update) {
            [self updateLocalizablesForTable:table previousDictionary:previousDictionary newDictionary:nil force:YES];
        }
        
        // Unlink localizable object
        if (unlink) {
            NSHashTable *hashTable = nil;
            if (!table) {
                hashTable = [self mainTableLocalizables];
            } else {
                hashTable = [[self customTableLocalizables] objectForKey:table];
                [[self customTableLocalizables] removeObjectForKey:table];
            }
            
            for (id<DIALocalizable> localizableObject in hashTable) {
                [localizableObject removeLocalization];
            }
            [hashTable removeAllObjects];
        }
        
        // Remove from disk
        if (removeFromDisk) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSString *filePath = [self filePathForTable:table];
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            });
        }
    });
}




// MARK: Download localization dictionary

+ (void)downloadLocalizationDictionaryWithURL:(NSURL *)URL table:(NSString *)table {
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
    [self downloadLocalizationDictionaryWithURLRequest:URLRequest table:table];
}

+ (void)downloadLocalizationDictionaryWithURLRequest:(NSURLRequest *)URLRequest table:(NSString *)table {
    NSMutableURLRequest *request = [URLRequest mutableCopy];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data.length > 0) {
            NSError *parseError = nil;
            id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
            if ([JSONObject isKindOfClass:[NSDictionary class]]) {
                [self setLocalizationDictionary:JSONObject table:table update:YES storeOnDisk:YES];
            }
        }
    }];
    [task resume];
}



// MARK: Get localized string

+ (NSString *)stringFor:(NSString *)localizationKey {
    return [self stringFor:localizationKey table:nil bundle:nil defaultValue:nil replace:nil];
}

+ (NSString *)stringFor:(NSString *)localizationKey table:(NSString *)table {
    return [self stringFor:localizationKey table:table bundle:nil defaultValue:nil replace:nil];
}

+ (NSString *)stringFor:(NSString *)localizationKey replace:(NSDictionary *)replace {
    return [self stringFor:localizationKey table:nil bundle:nil defaultValue:nil replace:replace];
}

+ (NSString *)stringFor:(NSString *)localizationKey table:(NSString *)table replace:(NSDictionary *)replace {
    return [self stringFor:localizationKey table:table bundle:nil defaultValue:nil replace:replace];
}

+ (NSString *)stringFor:(NSString *)localizationKey table:(NSString *)table defaultValue:(NSString *)defaultValue replace:(NSDictionary *)replace {
    return [self stringFor:localizationKey table:table bundle:nil defaultValue:defaultValue replace:replace];
}

+ (NSString *)stringFor:(NSString *)localizationKey table:(NSString *)table bundle:(NSBundle *)bundle defaultValue:(NSString *)defaultValue replace:(NSDictionary *)replace {
    NSString *string = nil;
    NSBundle *selectedBundle = bundle ?: [NSBundle mainBundle];
    NSDictionary *localizationDictionary = [self localizationDictionaryForTable:table];
    
    // Look for key in Dialect dictionary
    if (localizationDictionary) {
        string = [localizationDictionary objectForKey:localizationKey];
    }
    
    // Fallback to localized string from bundle
    if (!string) {
        string = [selectedBundle localizedStringForKey:localizationKey value:nil table:table];
    }
    
    // Fallback to default value
    if (!string) {
        string = defaultValue;
    }
    
    // Do replacements if necessary
    if (string && replace.count > 0) {
        for (NSString *key in replace.allKeys) {
            string = [string stringByReplacingOccurrencesOfString:key withString:replace[key]];
        }
    }
    
    return string;
}



// MARK: Update localizable objects

+ (void)updateLocalizablesForTable:(NSString *)table previousDictionary:(NSDictionary *)previousDictionary newDictionary:(NSDictionary *)newDictionary force:(BOOL)force {
    // Get the correct hashtable containing localizable objects for this table
    NSHashTable *hashTable = [self mainTableLocalizables];
    if (table) {
        hashTable = [[self customTableLocalizables] objectForKey:table];
    }
    
    if (hashTable.count > 0) {
        for (id<DIALocalizable> localizableObject in hashTable) {
            // Check if the key has changed
            NSString *localizationKey = localizableObject.dialectLocalizationKey;
            NSString *previousValue = [previousDictionary objectForKey:localizationKey];
            NSString *newValue = [newDictionary objectForKey:localizationKey];
            
            if (force || ((previousValue != nil || newValue != nil) && ![previousValue isEqual:newValue])) {
                [localizableObject dialect_updateLocalization];
            }
        }
    }
}

@end

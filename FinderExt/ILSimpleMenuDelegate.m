//
//  ILSimpleMenuDelegate.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILSimpleMenuDelegate.h"
#import "FinderExt.h"

@implementation ILSimpleMenuDelegate

- (id)initWithMenuItem:(NSMenuItem *)menuItemFile menuItemFolder:(NSMenuItem *)menuItemFolder menuItemOther:(NSMenuItem *)menuItemOther atIndex:(NSInteger)index
{
  self = [super init];
  if (self) {
    _menuItemFile = [menuItemFile retain];
    _menuItemFolder = [menuItemFolder retain];
    _menuItemOther = [menuItemOther retain];
    _index = index;
  }
  return self;
}

- (void)dealloc
{
  [_menuItemFile release];
  [_menuItemFolder release];
  [super dealloc];
}

- (BOOL)isValidInsertion:(NSString *)fullPath
{
    // If sync.html is available on server, override options, otherwise do not
//    NSString *filePath = [NSString stringWithFormat: @"%@/Library/Application Support/%@/sync.cfg", NSHomeDirectory(), @BRAND];

//    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];

    // Do we not depend on synchtml anymore to show finder menu?
//    if ([jsonString rangeOfString:@"\"synchtml\": 1"].location == NSNotFound && [jsonString rangeOfString:@"\"synchtml\":1"].location == NSNotFound) {
//        return NO;
//    }
    NSString *syncFolderName = [NSHomeDirectory() stringByAppendingPathComponent:@BRAND];

    if (![fullPath hasPrefix:[NSString stringWithFormat:@"%@/", syncFolderName]] || [fullPath isEqualToString:syncFolderName]) {
        return NO;
    }

    return YES;
}

- (void)finderWillShowContextMenu:(NSMenu *)menu
{
    if ([_menuItemFile menu]) {
        // Detach from previous menu
        [[_menuItemFile menu] removeItem:_menuItemFile];
    }

    // Find first separator to insert menu after it
    NSInteger index;
    for (index = 1 /* 0 is always separator  */; index < [menu numberOfItems]; ++index) {
        if ([[menu itemAtIndex:index] isSeparatorItem]) {
            // separator found!
            break;
        }
    }

    NSString *full_path = [[[ILFinderMenu sharedInstance] selectedItems] objectAtIndex:0];
    BOOL isDir;

    if ([self isValidInsertion:full_path]) {
        // Show menu only for specified directory
        if ([[NSFileManager defaultManager] fileExistsAtPath:full_path isDirectory:&isDir] && isDir) {
            [menu insertItem:_menuItemFolder atIndex:index + 1];
        } else {
            [menu insertItem:_menuItemFile atIndex:index + 1];
        }

    } else if ([[NSFileManager defaultManager] fileExistsAtPath:full_path isDirectory:&isDir] && !isDir) {
        // Show different menu. Menu with option to copy file to ZSS.
        [menu insertItem:_menuItemOther atIndex:index + 1];
    }
    [menu insertItem:[NSMenuItem separatorItem] atIndex:index + 2];


}

@end

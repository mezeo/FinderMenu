//
//  ILSimpleMenuDelegate.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILSimpleMenuDelegate.h"

@implementation ILSimpleMenuDelegate

- (id)initWithMenuItem:(NSMenuItem *)menuItemFile menuItemFolder:(NSMenuItem *)menuItemFolder atIndex:(NSInteger)index
{
  self = [super init];
  if (self) {
    _menuItemFile = [menuItemFile retain];
    _menuItemFolder = [menuItemFolder retain];
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

- (void)finderWillShowContextMenu:(NSMenu *)menu
{
    if ([_menuItemFile menu]) {
        // Detach from previous menu
        [[_menuItemFile menu] removeItem:_menuItemFile];
    }

    NSString *full_path = [[[ILFinderMenu sharedInstance] selectedItems] objectAtIndex:0];
    // Show menu only for specified directory
    BOOL isDir;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:full_path isDirectory:&isDir] && isDir) {
        [menu insertItem:_menuItemFolder atIndex:_index];
    } else {
        [menu insertItem:_menuItemFile atIndex:_index];
    }
}

@end

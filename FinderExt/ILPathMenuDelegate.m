//
//  ILPathMenuDelegate.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILPathMenuDelegate.h"

#import "ILFinderMenu.h"

@implementation ILPathMenuDelegate

- (id)initWithPath:(NSString *)path
          menuItemFile:(NSMenuItem *)menuItemFile
          menuItemFolder:(NSMenuItem *)menuItemFolder
             index:(NSInteger)index
{
    self = [super initWithMenuItem:menuItemFile menuItemFolder:menuItemFolder atIndex:index];
  if (self) {
    _path = [path retain];
  }
  return self;
}

- (void)dealloc
{
  [_path release];
  [super dealloc];
}

- (void)finderWillShowContextMenu:(NSMenu *)menu
{
    NSArray *selectedItems = [[ILFinderMenu sharedInstance] selectedItems];

    if (selectedItems && ([selectedItems count] > 0)
        && [[selectedItems objectAtIndex:0] hasPrefix:_path]) {
        [super finderWillShowContextMenu:menu];
  }
}

@end

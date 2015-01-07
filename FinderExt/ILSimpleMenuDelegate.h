//
//  ILSimpleMenuDelegate.h
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "ILFinderMenu.h"

@interface ILSimpleMenuDelegate : NSObject <ILFinderMenuDelegate> {
 @private
  NSMenuItem *_menuItemFile;
  NSMenuItem *_menuItemFolder;
  NSMenuItem *_menuItemOther;
  NSInteger _index;
}

- (id)initWithMenuItem:(NSMenuItem *)menuItemFile menuItemFolder:(NSMenuItem *)menuItemFolder menuItemOther:(NSMenuItem *)menuItemOther atIndex:(NSInteger)index;

@end

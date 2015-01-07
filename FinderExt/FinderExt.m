//
//  FinderInj.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import "FinderExt.h"

#import "ILFinderMenu.h"
#import "ILPathMenuDelegate.h"


@implementation FinderExt

static FinderExt *_instance = nil;

+ (void)load {
  
  NSLog(@"Main bundle: %@", [[NSBundle mainBundle] bundleIdentifier]);
  if (!_instance) {
    _instance = [[FinderExt alloc] init];
  }
  NSLog(@"FinderExt load is complete");
}

- (id)init
{
  self = [super init];
  if (self) {
    // Don't set up logging right now since we don't write much to log.
    // It will go to console log anyway.
    //[self setupLogging];
    
    NSMenuItem *menuItemFile = [self createMenuItemFile];
    NSMenuItem *menuItemFolder = [self createMenuItemFolder];
    NSMenuItem *menuItemOther = [self createMenuItemOther];

    [self injectMenuItem:menuItemFile menuItemFolder:menuItemFolder menuItemOther:menuItemOther];
  }
  return self;
}

- (void)setupLogging
{
  // Write log file to ~/Library/Application Support/BRAND/FinderExt.log
  NSString *logPathComponent = [NSString stringWithFormat: @"Library/Application Support/%@/FinderExt.log", @BRAND];
  const char* logFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:logPathComponent] UTF8String];
  freopen(logFilePath, "a", stdout);
  freopen(logFilePath, "a", stderr);
}

- (NSMenuItem *)createMenuItemFolder
{
    // Build extension menu
    NSMenuItem *myMenuItem = [[NSMenuItem alloc] initWithTitle:@BRAND action:nil keyEquivalent:@""];
    NSMenu *mySubmenu = [[NSMenu alloc] initWithTitle:@BRAND];
    [mySubmenu setAutoenablesItems:NO];

    [[mySubmenu addItemWithTitle:@FINDER_SECURE_SHARE
                          action:@selector(openSecureShare:)
                   keyEquivalent:@""]
     setTarget:self];
    
    [mySubmenu addItem:[NSMenuItem separatorItem]];
    
    [[mySubmenu addItemWithTitle:@FINDER_VIEW_WEB_HOME
                          action:@selector(openWebHome:)
                   keyEquivalent:@""]
     setTarget:self];

    [myMenuItem setSubmenu:mySubmenu];

    return myMenuItem;
}

- (NSMenuItem *)createMenuItemFile
{
    // Build extension menu
    NSMenuItem *myMenuItem = [[NSMenuItem alloc] initWithTitle:@BRAND action:nil keyEquivalent:@""];
    NSMenu *mySubmenu = [[NSMenu alloc] initWithTitle:@BRAND];
    [mySubmenu setAutoenablesItems:NO];
    
    [[mySubmenu addItemWithTitle:@FINDER_PUBLIC_SHARE
                          action:@selector(openPublicShare:)
                   keyEquivalent:@""]
     setTarget:self];
    
    [[mySubmenu addItemWithTitle:@FINDER_SECURE_SHARE
                          action:@selector(openSecureShare:)
                   keyEquivalent:@""]
     setTarget:self];
    
    [[mySubmenu addItemWithTitle:@FINDER_COMMENTS
                          action:@selector(openComments:)
                   keyEquivalent:@""]
     setTarget:self];
    
    [[mySubmenu addItemWithTitle:@FINDER_FILE_VERSIONS
                          action:@selector(openVersions:)
                   keyEquivalent:@""]
     setTarget:self];
    
    [mySubmenu addItem:[NSMenuItem separatorItem]];
    
    [[mySubmenu addItemWithTitle:@FINDER_VIEW_FILE_WEB
                          action:@selector(openFileWeb:)
                   keyEquivalent:@""]
     setTarget:self];
    
    [[mySubmenu addItemWithTitle:@FINDER_VIEW_WEB_HOME
                          action:@selector(openWebHome:)
                   keyEquivalent:@""]
     setTarget:self];

    [myMenuItem setSubmenu:mySubmenu];

    return myMenuItem;
}

- (NSMenuItem *)createMenuItemOther
{
    // Build extension menu
    NSMenuItem *myMenuItem = [[NSMenuItem alloc] initWithTitle:@BRAND action:nil keyEquivalent:@""];
    NSMenu *mySubmenu = [[NSMenu alloc] initWithTitle:@BRAND];
    [mySubmenu setAutoenablesItems:NO];

    [[mySubmenu addItemWithTitle:@FINDER_COPY_TO_SYNC_FOLDER
                          action:@selector(copyToSyncFolder:)
                   keyEquivalent:@""]
     setTarget:self];

    [myMenuItem setSubmenu:mySubmenu];

    return myMenuItem;
}

- (void)injectMenuItem:(NSMenuItem *)menuItemFile menuItemFolder:menuItemFolder menuItemOther:menuItemOther
{
  // Create menu only in User's home directory
  ILSimpleMenuDelegate *simpleDelegate = [[[ILPathMenuDelegate alloc]
                                           initWithPath:NSHomeDirectory()
                                           menuItemFile:menuItemFile
                                           menuItemFolder:menuItemFolder
                                           menuItemOther:menuItemOther
                                           index:4]
                                          autorelease];
  [[ILFinderMenu sharedInstance] setDelegate:simpleDelegate];
}

- (void)openBrowser:(NSString *)option {
    NSString *fullpath = [[[ILFinderMenu sharedInstance] selectedItems] objectAtIndex:0];
    NSString *launchPath = [NSString stringWithFormat: @"/Applications/%@.app/Contents/Resources/MacSyncBrowserControl.app/Contents/MacOS/MacSyncBrowserControl", @BRAND];
    [NSTask launchedTaskWithLaunchPath:launchPath arguments:[NSArray arrayWithObjects:fullpath, @BRAND, option, nil]];
}

- (void)openPublicShare:(id)sender { [self openBrowser:@"publicshare"]; }
- (void)openSecureShare:(id)sender { [self openBrowser:@"secureshare"]; }
- (void)openVersions:(id)sender { [self openBrowser:@"version"]; }
- (void)openComments:(id)sender { [self openBrowser:@"comment"]; }
- (void)openFileWeb:(id)sender { [self openBrowser:@"fileWeb"]; }
- (void)openWebHome:(id)sender { [self openBrowser:@"webHome"]; }
- (void)copyToSyncFolder:(id)sender { [self openBrowser:@"copytosyncfolder"]; }


@end

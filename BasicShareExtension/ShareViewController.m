//
//  ShareViewController.m
//  BasicShareExtension
//
//  Created by Andy on 9/30/14.
//  Copyright (c) 2014 Andy Pierz. All rights reserved.
//

#import "ShareViewController.h"
#import "WXApi.h"
@interface ShareViewController ()
@property  SLComposeSheetConfigurationItem * item;
@property (strong, nonatomic) NSArray * array;
@property (strong, nonatomic) NSMutableArray * thingsToAdd;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [WXApi registerApp:@"zzz"];
}

#pragma mark - Config Table Delegate Methods
-(void)didSelectOptionAtIndexPath:(NSIndexPath *)indexPath {
    //sets the item's "value" to the option the user selected and pops the config table menu
    
    self.item.value = self.array[indexPath.row];
    [self popConfigurationViewController];
    
}


- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    
    //This loads the data into the shared NSUserDefaults, make sure you set up your app group properply and change
    //the suitename!
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.yourname.yourappgroup"];
    
    //stores the user text and the selected option in an NSDictionary
    NSDictionary * objectToAdd = [[NSDictionary alloc] initWithObjectsAndKeys:self.contentText, @"INFO", self.item.value, @"WHICH_OPTION", nil];
    
    
    //stores the dictionary in an array in our shared NSUserDefalts
    if (![mySharedDefaults objectForKey:@"THINGS_TO_ADD"]) {
        self.thingsToAdd = [[NSMutableArray alloc]init];
    }
    
    else {
        self.thingsToAdd = [mySharedDefaults objectForKey:@"THINGS_TO_ADD"];
    }
    
//    [self.thingsToAdd addObject:objectToAdd];
//    
//    [mySharedDefaults setObject:self.thingsToAdd forKey:@"THINGS_TO_ADD"];
//    
//    [mySharedDefaults synchronize];
    
    WXWebpageObject *sendMsg = [[WXWebpageObject alloc] init];
    sendMsg.webpageUrl = self.contentText;
//    sendMsg.bText = YES;
//    NSLog(self.contentText);
//    [WXApi sendReq:sendMsg];


    
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    
    //Creates an instance of our config menu and sets its size to be the same as the main extension view
    ConfigMenuTableViewController * configTable = [[ConfigMenuTableViewController alloc]init];
    configTable.size = self.preferredContentSize;
    
    //calls up the shared NSUserDefaults, make sure you set up your app group properply and change
    //the suitename!
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.yourname.yourappgroup"];
    
    //stores the options from the main app in an array
    self.array = [mySharedDefaults objectForKey:@"OPTIONS"];
    
    //passes the array to our config menu
    configTable.OptionNames = [self.array mutableCopy];
    configTable.delegate = self;
    
    
    //sets the properties of our configuration item before passing it to the view controller
    self.item = [[SLComposeSheetConfigurationItem alloc]init];
    self.item.title = @"Option";
    self.item.tapHandler = ^{ NSLog(@"block hit");
        [self pushConfigurationViewController:configTable];
    };
    
    
    return @[self.item];
}

@end

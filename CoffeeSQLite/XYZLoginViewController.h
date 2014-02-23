//
//  XYZLoginViewController.h
//  CoffeeSQLite
//
//  Created by Francis Hall on 10/02/2014.
//  Copyright (c) 2014 FrancisHall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface XYZLoginViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *customerDB;

@property (weak, nonatomic) IBOutlet UILabel *status;

- (IBAction)backgroundtap:(id)sender;


@end

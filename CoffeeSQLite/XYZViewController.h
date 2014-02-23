//
//  XYZViewController.h
//  CoffeeSQLite
//
//  Created by Francis Hall on 08/02/2014.
//  Copyright (c) 2014 FrancisHall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface XYZViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *tier;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;



- (IBAction)findCustomer:(id)sender;
- (IBAction)backgroundtap:(id)sender;
- (IBAction)saveData:(id)sender;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *customerDB;

@end
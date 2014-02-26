//
//  XYZLoginViewController.m
//  CoffeeSQLite
//
//  Created by Francis Hall on 10/02/2014.
//  Copyright (c) 2014 FrancisHall. All rights reserved.
//

#import "XYZLoginViewController.h"
#import "XYZHomeViewController.h"

@interface XYZLoginViewController ()

@end

@implementation XYZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.password.delegate=self;
    self.email.delegate=self;
	// Do any additional setup after loading the view, typically from a nib.
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"customer.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_customerDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CUSTOMER (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, EMAIL TEXT, PASSWORD TEXT, TIER TEXT )";
            
            if (sqlite3_exec(_customerDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _status.text = @"Failed to create table";
            }
            sqlite3_close(_customerDB);
        } else {
            _status.text = @"Failed to open/create database";
        }
    }
}



- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue
//Cancel button method
{
    
}


- (void) login:(id)sender
{
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_customerDB) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM CUSTOMER WHERE NAME='%@' AND PASSWORD='%@'", self.email.text, self.password.text];
        
        const char *sql = [query UTF8String];
        
              sqlite3_stmt *selectstmt;
        
        if(sqlite3_prepare_v2(_customerDB, sql, -1, &selectstmt, NULL) == SQLITE_OK)
            

        
        {
            sqlite3_bind_text(selectstmt, 1, [_email.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectstmt, 2, [_password.text UTF8String], -1, SQLITE_TRANSIENT);
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                [self performSegueWithIdentifier:@"loginsegue" sender:self];
                _status.text = @"Login Successful";
                
                NSLog(@"Successful login");
            }
            
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginsegue"]) {
        XYZHomeViewController *homecontroller = [segue destinationViewController];
        homecontroller.customername.text=_email.text;
    }
}




-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
    // Hides the keyboard when the 'return' button is pushed.
}

- (IBAction)backgroundtap:(id)sender {
    [self.view endEditing:YES];
    //when the background is tapped, the keyboard is removed.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // instead of doing a background outlet instead implement this method
    
    if (![self.view isFirstResponder]) {
        [self.view becomeFirstResponder];
    }
}




@end


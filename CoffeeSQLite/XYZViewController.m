//
//  XYZViewController.m
//  CoffeeSQLite
//
//  Created by Francis Hall on 08/02/2014.
//  Copyright (c) 2014 FrancisHall. All rights reserved.
//

#import "XYZViewController.h"


@interface XYZViewController ()

@end

@implementation XYZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (void) saveData:(id)sender
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_customerDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CUSTOMER (name, email, password, tier) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
                               _name.text, _email.text, _password.text, _tier.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_customerDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _status.text = @"Registration Complete!";
            _name.text = @"";
            _email.text = @"";
            _password.text = @"";
            _tier.text = @"";
        } else {
            _status.text = @"Failed to add customer";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_customerDB);
    }
}


- (void) findCustomer:(id)sender
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_customerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT email, password, tier FROM customer WHERE name=\"%@\"",
                              _name.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_customerDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
         
                NSString *tierField = [[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 2)];
                _tier.text = tierField;
                _status.text = @"Match found";
            } else {
                _status.text = @"Match not found";
                _email.text = @"";
                _password.text = @"";
                _tier.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_customerDB);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundtap:(id)sender {
    [self.view endEditing:YES];
    //when the background is tapped, the keyboard is removed.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
    // Hides the keyboard when the 'return' button is pushed.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    if (sender != self.doneButton) return;
    if (sender == self.doneButton) {
        
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_customerDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CUSTOMER (name, email, password, tier) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
                                   _name.text, _email.text, _password.text, _tier.text];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_customerDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                _status.text = @"Contact added";
                _name.text = @"";
                _email.text = @"";
                _password.text = @"";
                _tier.text = @"";
            } else {
                _status.text = @"Failed to add contact";
            }
            sqlite3_finalize(statement);
            sqlite3_close(_customerDB);
     
        }

        
        
        
    }

      }
    





@end

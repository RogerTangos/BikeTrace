//
//  RideList.m
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RideDirectory.h"

static sqlite3 *database = nil;

@implementation RideDirectory
@synthesize rideList;

-(id) initializeArray: (NSArray *) array {    
    if(self){
        self.rideList = [[NSMutableArray alloc] initWithArray:array];
    } 
    
    return self;    
}

-(id) initialize {
    if(self){
        self.rideList = [[NSMutableArray alloc] init];
    }

    return self;
}


//this should only EVER be called from the database.
-(Ride *) newRide {
    //keep a count of the rides.
    
    
    Ride *r = [[Ride alloc] init];
    
    //default date/time.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd 'at' HH:mm" ];
    NSDate *now = [[NSDate alloc] init];
    r.title = [dateFormat stringFromDate:now];
    r.dataPointList = [[NSMutableArray alloc] init];
    
    [self.rideList addObject:r];
    return r;
}

-(Ride *) newRideWithoutAdd{
    Ride *r = [[Ride alloc] init];
    
    //default date/time.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd 'at' HH:mm" ];
    NSDate *now = [[NSDate alloc] init];
    r.title = [dateFormat stringFromDate:now];
    r.dataPointList = [[NSMutableArray alloc] init];
    
    return r;
}



-(id) returnAllRides {
    return rideList;
}

#pragma mark - SearchWithRange
-(id) searchWithRange:(NSString *)searchTerm {
    // returns a list of people match the search term
    NSMutableArray *tempList = [[NSMutableArray alloc] init ];
    
    for(Ride *r in self.rideList) {

        if ([r.title rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound) {
        } else {
            [tempList addObject:r];
        }
    }
        return tempList;
}

#pragma mark - Database
- (void) copyDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    
    BOOL success = [fileManager fileExistsAtPath:dbPath]; 
    
    //if the DB doesn't exist in dbPath, create it.
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"biketrace.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success) 
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }   
}

- (NSString *) getDBPath {
	//find the path for the database and return it.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"biketrace.sqlite"];
    // Look here for the simulator sql database:
    // /Users/arcarter/Library/Application Support/iPhone Simulator/5.1/Applications
    
}

- (void) getInitialDataToDisplay:(NSString *)dbPath {
    
    NSLog(SQLITE_OK);
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select id, title from RideList";
		sqlite3_stmt *selectstmt;
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            // was sql, -1
            
            //NSLog(@"sqlite3_step(selectstmt) is %d",sqlite3_step(selectstmt));
            
            //while there are rows unused in the database
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                //get the idNumber from the database, too.
                int i = sqlite3_column_int(selectstmt, 0);  
                
                NSString * title= [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                Ride *r = [self newRide];
                r.idNum = i;
                r.title = title;
            }
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
//    NSLog(@"failed to open sqLite in RideDirectory.");
}


-(void) insertIntoSQL:(NSString *)dbPath andRide:(Ride *)r {
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO RideList (title) VALUES (\"%@\")", r.title];
        //NSLog(@"insertSQL Statement:%@",insertSQL);
        
        const char *insert_stmt = [insertSQL UTF8String]; 
        sqlite3_stmt *selectstmt;
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &selectstmt, NULL);
        
        if(sqlite3_step(selectstmt) == SQLITE_DONE) {
//            NSLog(@"Ride added"); 
            
            r.idNum = sqlite3_last_insert_rowid(database);
            
        } else {
            NSLog(@"Failed to add ride");
        }
        
        sqlite3_finalize(selectstmt); 
        sqlite3_close(database);
    }
}


//delete doesn't yet work because rides don't yet have an id.
-(void) deleteFromSQL:(NSString *)dbPath andRide:(Ride *)r {
    NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM RideList WHERE ID=\"%D\"", r.idNum]; 
    
    const char *insert_stmt = [insertSQL UTF8String]; 
    sqlite3_stmt *selectstmt;
    
    sqlite3_prepare_v2(database, insert_stmt,  -1, &selectstmt, NULL); 
    
    if (sqlite3_step(selectstmt) == SQLITE_DONE) {
//        NSLog(@"Ride Deleted");
    } else { 
        NSLog(@"Failed to delete");
    } 
    
    sqlite3_finalize(selectstmt); 
    
    sqlite3_close(database);
}

-(int) getMostRecentInsertKey:(NSString *)dbPath{
        int i = sqlite3_last_insert_rowid(database);
    return i;
}

-(void) updateRideTitleInSQL:(NSString *)dbPath andRide:(Ride *)r{
//    NSLog(@"updaateRideTitleInSQL called");
    
     NSString *insertSQL = [NSString stringWithFormat: @"UPDATE RideList set title = \"%@\" WHERE ID=\"%D\"", r.title, r.idNum]; 
        
    const char *insert_stmt = [insertSQL UTF8String]; 
    sqlite3_stmt *selectstmt;
    
    sqlite3_prepare_v2(database, insert_stmt,  -1, &selectstmt, NULL); 
    
    if (sqlite3_step(selectstmt) == SQLITE_DONE) {
//        NSLog(@"Ride Updated");
    } else { 
        NSLog(@"Failed to Update");
    } 
    
    sqlite3_finalize(selectstmt); 
    
    sqlite3_close(database);
}

    
@end
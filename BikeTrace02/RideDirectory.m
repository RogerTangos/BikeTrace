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
@synthesize networkRideList;

-(id) initializeArray: (NSArray *) array {    
    if(self){
        self.rideList = [[NSMutableArray alloc] initWithArray:array];
        self.networkRideList = [[NSMutableArray alloc] init];
        
    }
    
    return self;    
}

-(id) initialize {
    if(self){
        self.rideList = [[NSMutableArray alloc] init];
        self.networkRideList = [[NSMutableArray alloc] init];
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

-(id) returnNetworkRides {
    return networkRideList;
}

#pragma mark - Network


-(NSData *) loadNetworkRides:(CLLocation *) currentLocation{
    
    NSLog(@"loadNearbyRides in RideDirectory.m called");
    
    NSString *latitude = [[NSString alloc] initWithFormat:@"%g", currentLocation.coordinate.latitude];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%g", currentLocation.coordinate.longitude];
    
    NSLog(@"latitude: %@", latitude);
    NSLog(@"longitude: %@", longitude);
   
    
    NSString *queryString = @"http://ec2-107-22-150-242.compute-1.amazonaws.com/retrieveNearby.php";
    NSMutableURLRequest *theRequest = [NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:queryString]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
                                       ];
    [theRequest setHTTPMethod:@"POST"];
    
    // format and post data;
    NSString *post = [NSString stringWithFormat:@"latitude=%@&longitude=%@", latitude, longitude];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    [theRequest setHTTPBody:postData];
    
    NSError * error = [[NSError alloc] init];
    NSURLResponse * response = [[NSURLResponse alloc] init];
    NSData * data = [[NSData alloc] init];
    
    // wish this were asynch. Had torouble with method passing and had to rever to sync 2014-06-01 ARC
    data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    return data;
 
}

-(NSArray *)arrayFromData:(NSData *)data {
    // encode as string for debugging
    //    NSString *responseText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //    NSString *newLineStr = @"\n";
    //    responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
    
    NSError * error = [[NSError alloc] init];
    NSArray * parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"%@", parsedData);
    
//    if(error) {
//        NSLog(@"json serialization error: %@",error.description);
//    }
    
    return parsedData;
}

-(NSArray *) reverseEngineerPointDataToArr:(NSArray*)oldArr{
//    have to do this using NSString because navigating JSON using static typing is proving too time consuming. - ARC 2014-06-01
    
    NSMutableArray * pointArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * currentDataPoint in oldArr){
        
//        this is ridiculously backwards
        NSString * dataString = [NSString stringWithFormat:@"%@", currentDataPoint];
        NSLog(@"%i",[dataString length]);
        NSLog(@"%@", dataString);
        
        
        // use regex to match...
        NSError *error = [[NSError alloc] init];
        NSRange range = NSMakeRange(0, [dataString length]);
        NSString * pattern = @"(\\-?[0-9]+\\.?[0-9]*)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];

         // find matches and add to result array
        NSArray *matches = [regex matchesInString:dataString options:0 range:range];
        [pointArray addObject:[self reverseRegex:matches andString:dataString]];
    }
    
    return pointArray;
}

-(NSArray *) reverseRegex:(NSArray *)matches andString:(NSString *)str{
        
        NSMutableArray *point = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            NSString *numString = [str substringWithRange:matchRange];
            [point addObject:numString];
        }
    
    // [0]alt, [1]course, [2]horizontalAccuracy, [3]id, [4]latitude, [5]longitude,
    // [6]ridelist_id, [7]speed, [8]timestamp, [9]verticalAccuracy
    //  points are ordered by ridelist_id
        return point;
}

-(void) createRidesFromNetworkReturnArray:(NSArray *)arr{

    // add the first ride to the directory
    NSString *currentRideId = [[NSString alloc] init];
//    NSLog(@"%@", arr[0]);
//    NSLog(@"%@", arr[0][6]);
    
    currentRideId = arr[0][6];
    Ride *currentRide = [[Ride alloc] init];
    currentRide = [self newRideWithoutAdd];
    [self.networkRideList addObject:currentRide];
    NSLog(@"New ride: %@", currentRideId);
    
    for (NSArray * point in arr){
        // add a new ride and start populating it
        if (![point[6] isEqualToString:currentRideId]){
            currentRideId = point[6];
            currentRide = [self newRideWithoutAdd];
            [self.networkRideList addObject:currentRide];
            NSLog(@"New ride: %@", currentRideId);
        }
        
        // turn array into cllocation, device motion variables...
//        NSString * altStr = point[0];
//        NSString * courseStr = point[1];
//        NSString * horizontalAccuracyStr = point[2];
//        // NSString * idStr = point[3];
//        NSString * latitudeStr = point[4];
//        NSString *  = point[5];
////        NSString * ridelist_idStr = point[6];
//        NSString * speedStr = point[7];
//        NSString * timestampStr = point[8];
//        NSString * verticalAccuracyStr = point[9];
        
        
        double latitude = [point[4] doubleValue];
        double longitude = [point[4] doubleValue];
        double alt = [point[0] doubleValue];
        double horizontalAccuracy = [point[2] doubleValue];
        double verticalAccuracy = [point[9] doubleValue];
        double course = [point[1] doubleValue];
        double speed = [point[7] doubleValue];
        double timestampDouble = [point[8] doubleValue];
        NSDate * timestamp = [[NSDate alloc] initWithTimeIntervalSince1970:timestampDouble];
        
        CLLocation * pointLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:alt horizontalAccuracy:horizontalAccuracy verticalAccuracy:verticalAccuracy course:course speed:speed timestamp:timestamp];
        
        NSLog(@"made it past making a pointlocation");

        [currentRide newDataPoint:pointLocation andDeviceMotion:nil];
    }
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
//
//  Ride.m
//  BikeTrace02
//
//  Created by Al Carter on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ride.h"

static sqlite3 *database = nil;

@implementation Ride
@synthesize dataPointList;
//@synthesize restFunctions;
@synthesize title;
@synthesize idNum;

-(id) initialize {
    if(self){
        self.dataPointList = [[NSMutableArray alloc] init];
//        self.restFunctions = [[RestFunctions alloc] init];
    }
    return self;
}

-(id) initializeArray: (NSArray *) array {    
    if(self){
        self.dataPointList = [[NSMutableArray alloc] initWithArray:array];
    } 
    return self;    
}

- (void) newDataPoint:(CLLocation *)location andDeviceMotion:(CMDeviceMotion *)deviceMotion{
    
    DataPoint * data = [[DataPoint alloc] initWithData:location andDeviceMotion:deviceMotion];
    
    [dataPointList addObject:data];
}

- (Ride *) removeDataAfterRideEnded:(double)seconds{
    NSDate * currentDate = [[NSDate alloc] init];
    
    seconds = (seconds * -1);
    
    NSTimeInterval * timeInterval = &seconds;
    
    //the error is here.  
    NSDate * cutoffTime = [currentDate dateByAddingTimeInterval:*timeInterval];
    
    for (DataPoint * dp in dataPointList){
        
        if ([dp.date compare:cutoffTime] == NSOrderedDescending){
            int startRemovalInt = [dataPointList indexOfObject:dp];
            int lengthForRemovalInt = ([dataPointList count]-startRemovalInt);
            
            NSRange removalRange = {startRemovalInt, lengthForRemovalInt};
            
            [dataPointList removeObjectsInRange:removalRange];
            break;
        }
        
        
    }
    return self;
}

#pragma mark - Business Intelligence:

- (double) averageSpeed{
    double sum = 0.0;

    for (DataPoint * dp in dataPointList){
        sum = sum + dp.location.speed;}
    double averageSpeed = sum/[dataPointList count];
    return averageSpeed;
}


- (double) distance{
    double totalDistance = 0.0;
    
    //cycle through points and get the distance to the next point.
    for (DataPoint *dp in dataPointList){
        int nextPointIndex = [dataPointList indexOfObject:dp] +1;
        if (nextPointIndex < [dataPointList count]){
        double distance = [dp.location distanceFromLocation:[dataPointList objectAtIndex:nextPointIndex]];
        totalDistance = totalDistance + distance;
        }
    }
    
    return totalDistance;
}

- (NSDate *) startTime{
    NSDate * date = [dataPointList objectAtIndex:0];
    return date;
}
/*
- (double) duration{
    
    DataPoint * dp1 = [dataPointList objectAtIndex:0];
    DataPoint * dpx = [dataPointList lastObject];
    
//    DataPoint * dpy = [dataPointList objectAtIndex:[dataPointList count]];
    
    double timeInterval = [dpx.date timeIntervalSinceDate:dp1.date];
    
    return timeInterval;
} */

#pragma mark - Database DataPoint recovery:

- (NSString *) getDBPath {
    //find the path for the database and return it.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"biketrace.sqlite"];
    // /Users/arcarter/Library/Application Support/iPhone Simulator/5.1/Applications
}

- (void) getInitialDataToDisplay:(NSString *)dbPath{
    NSLog(SQLITE_OK);
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString * initial = @"select id, lat, long, alt, horizontalAccuracy, verticalAccuracy,timestamp, speed, course, rideList_id from DataPointList WHERE rideList_id = ";
        NSString *intString = [NSString stringWithFormat:@"%d", self.idNum];
        initial = [initial stringByAppendingFormat:intString];
        
        //NSLog(@"initial:");
        //NSLog(initial);
        
        const char *sql = [initial cStringUsingEncoding:NSASCIIStringEncoding];
        
      
        sqlite3_stmt *selectstmt;
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {            
            
            //while there are rows unused in the database
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                //get the idNumber from the database, too.
//                int id = sqlite3_column_int(selectstmt, 0);
                double latitude = sqlite3_column_double(selectstmt, 1);
                double longitude = sqlite3_column_double(selectstmt, 2);
                double alt = sqlite3_column_double(selectstmt, 3);
                double horizontalAcc = sqlite3_column_double(selectstmt, 4);
                double verticalAcc = sqlite3_column_double(selectstmt, 5);
                double timestamp = sqlite3_column_double(selectstmt, 6);
                double speed = sqlite3_column_double(selectstmt, 7);
                double course = sqlite3_column_double(selectstmt, 8);
//                int ridelist_id = sqlite3_column_double(selectstmt, 10);
                
                
                //we have to create a whole new location and assign it to the dataPoint, because CLLocation is read only.
                CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:
                                           CLLocationCoordinate2DMake(latitude, longitude) 
                                                                        altitude:alt 
                                                              horizontalAccuracy:horizontalAcc verticalAccuracy:verticalAcc
                                                                          course:course speed:speed timestamp:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                
                DataPoint * dataPoint = [[DataPoint alloc] initWithData:newLocation andDeviceMotion:nil];
                
                [self.dataPointList addObject:dataPoint];
            }
        }
    }
    else
        sqlite3_close(database);
}

-(void) postToServer {
    NSLog(@"Post To Server Called");
    NSString *queryString = @"http://ec2-107-22-150-242.compute-1.amazonaws.com/insertRide.php";
    NSMutableURLRequest *theRequest = [NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:queryString]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0
                                       ];
    [theRequest setHTTPMethod:@"POST"];
    
    // create a list of data points with dictionary objects and string keys for sending to the server.
    NSMutableArray * dataListForPost = [[NSMutableArray alloc] init];
    for (DataPoint * dp in dataPointList){
        [dataListForPost addObject:[dp toNSDictionaryWithStrings]];
    }
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dataListForPost
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@", [connectionError localizedDescription]);
        } else {
            NSString *responseText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"Response: %@", responseText);
            
            NSString *newLineStr = @"\n";
            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
            
            NSLog(@"%@", responseText);
        }
    }];
    
    
}

-(void) insertIntoSQL:(NSString *)dbPath {
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
      
        
        for (DataPoint * dp in dataPointList){
        
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO DataPointList (lat, long, alt, horizontalAccuracy, verticalAccuracy, timestamp, speed, course, rideList_id) VALUES (\"%.9lf\", \"%.9lf\", \"%.4lf\", \"%4lf\", \"%lf\", \"%lf\", \"%lf\", \"%lf\",\"%d\")", 
                              dp.location.coordinate.latitude, 
                              dp.location.coordinate.longitude, 
                              dp.location.altitude, 
                              dp.location.horizontalAccuracy, 
                              dp.location.verticalAccuracy,
                              dp.date.timeIntervalSince1970,
                              dp.location.speed, 
                              dp.location.course, 
                              self.idNum];

//        NSLog(@"insertSQL Statement:%@",insertSQL);
        
        const char *insert_stmt = [insertSQL UTF8String]; 
        sqlite3_stmt *selectstmt;
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &selectstmt, NULL);
        
        if(sqlite3_step(selectstmt) == SQLITE_DONE) {
//            NSLog(@"DataPoint added"); 
        } else {
            NSLog(@"dataPoint failed to add.");
        }
        
        sqlite3_finalize(selectstmt); 
        
        }
        sqlite3_close(database);
    }

    
}

- (void) deleteFromSQL:(NSString *)dbPath andDataPoint:(DataPoint *)dp{
    
}
//
//- (NSMutableDictionary *) toNSDictionaryWithStrings {
//     NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSString *courseString = [NSString stringWithFormat:@"%lf", location.course];
//    
//    [dictionary setValue:latitudeString forKey:@"latitude"];
//    
//    return dictionary;
//}

@end

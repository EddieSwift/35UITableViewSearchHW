//
//  EGBStudent.m
//  35UITableViewSearchHW
//
//  Created by Eduard Galchenko on 2/11/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBStudent.h"

@implementation EGBStudent

static NSString* firstNames[] = {
    
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie", @"Aaron",
    @"Arnold", @"Anna"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook", @"Gildert",
    @"Moor", @"Vai"
};

static NSInteger amountOfStudents = 53;

+ (EGBStudent* ) randomStudent {
    
    EGBStudent *student = [[EGBStudent alloc] init];
    
    student.firstName = firstNames[arc4random() % amountOfStudents];
    student.lastName = lastNames[arc4random() % amountOfStudents];
    student.dateOfBirth = [EGBStudent generateRandomDateWithinDaysBeforeToday];
    
    return student;
}

+ (NSDate *) generateRandomDateWithinDaysBeforeToday {
    
    int r1 = arc4random_uniform(3600);
    int r2 = arc4random_uniform(23);
    int r3 = arc4random_uniform(59);
    
    NSCalendar *gregorian =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [NSDateComponents new];
    
    [offsetComponents setDay:(r1*-1)];
    [offsetComponents setHour:r2];
    [offsetComponents setMinute:r3];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1999];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSDate *rndDate1 = [gregorian dateByAddingComponents:offsetComponents
                                                  toDate:date options:0];
    
    return rndDate1;
}

@end

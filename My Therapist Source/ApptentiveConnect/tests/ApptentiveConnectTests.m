//
//  ApptentiveConnectTests.m
//  ApptentiveConnectTests
//
//  Created by Andrew Wooster on 3/18/11.
//  Copyright 2011 Apptentive, Inc.. All rights reserved.
//

#import "ApptentiveConnectTests.h"
#import "ATConnect.h"
#import "ATPersonInfo.h"
#import "ATDeviceInfo.h"
#import "ATUtilities.h"

@implementation ApptentiveConnectTests

- (void)setUp {
	[super setUp];
	
	// Set-up code here.
}

- (void)tearDown {
	// Tear-down code here.
	
	[super tearDown];
}

- (void)testExample {
}

- (void)testInitialUserName {
	ATPersonInfo *person = [[[ATPersonInfo alloc] init] autorelease];
	[person saveAsCurrentPerson];
	XCTAssertTrue([ATPersonInfo currentPerson].name == nil, @"New person object's name should be nil");
	
	[ATConnect sharedConnection].initialUserName = @"setAfterInit";
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"setAfterInit"], @"Setting the initialUserName should set the current person's name.");
	
	[ATConnect sharedConnection].initialUserName = @"setToSomethingElse";
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"setToSomethingElse"], @"Should be able to change the initial user name");
	
	person = [ATPersonInfo currentPerson];
	person.name = @"changingThePersonNameDirectly";
	[person saveAsCurrentPerson];
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"changingThePersonNameDirectly"], @"Should be able to set the person object's name directly.");
	
	[ATConnect sharedConnection].initialUserName = @"settingInitialNameAFTERsettingPersonNameDirectly";
	XCTAssertFalse([[ATPersonInfo currentPerson].name isEqualToString:@"settingInitialNameAFTERsettingPersonNameDirectly"], @"Person object should not take a new *initial* name if the person has a non-initial name");
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"changingThePersonNameDirectly"], @"Should still be using the (non-initial) name that was set directly.");
	
	person = [ATPersonInfo currentPerson];
	person.name = @"settingNameDirectlyAgain";
	[person saveAsCurrentPerson];
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"settingNameDirectlyAgain"], @"Should be able to set the person object's name directly.");
	
	// Set initial name prior to creating new person object
	[ATConnect sharedConnection].initialUserName = @"setBeforeInit";
	person = [[[ATPersonInfo alloc] init] autorelease];
	[person saveAsCurrentPerson];
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"setBeforeInit"], @"A new person object should pick up the set initialUserName.");
	
	[ATConnect sharedConnection].initialUserName = @"settingToAnotherInitialName";
	XCTAssertTrue([[ATPersonInfo currentPerson].name isEqualToString:@"settingToAnotherInitialName"], @"Should be able to change the initial name.");
}

- (void)testInitialUserEmailAddress {
	ATPersonInfo *person = [[[ATPersonInfo alloc] init] autorelease];
	[person saveAsCurrentPerson];
	XCTAssertTrue([ATPersonInfo currentPerson].emailAddress == nil, @"New person object's email address should be nil");
	XCTAssertFalse([[ATPersonInfo currentPerson] hasEmailAddress], @"New person shouldn't have email address.");
	
	[ATConnect sharedConnection].initialUserEmailAddress = @"setAfterInit@example.com";
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"setAfterInit@example.com"], @"Setting the initialUserEmailAddress should set the current person's email address");
	XCTAssertTrue([[ATPersonInfo currentPerson] hasEmailAddress], @"Person should have email address after it's set.");
	
	[ATConnect sharedConnection].initialUserEmailAddress = @"setToSomethingElse@example.com";
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"setToSomethingElse@example.com"], @"Should be able to change the initial email address");
	
	person = [ATPersonInfo currentPerson];
	person.emailAddress = @"changingThePersonEmailDirectly@example.com";
	[person saveAsCurrentPerson];
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"changingThePersonEmailDirectly@example.com"], @"Should be able to set the person object's email directly.");
	
	[ATConnect sharedConnection].initialUserEmailAddress = @"settingInitialEmailAddressAFTERsettingPersonsEmailAddressDirectly@example.com";
	XCTAssertFalse([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"settingInitialEmailAddressAFTERsettingPersonsEmailAddressDirectly@example.com"], @"Person object should not take a new *initial* email address if the person has a non-initial email");
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"changingThePersonEmailDirectly@example.com"], @"Should still be using the (non-initial) email address that was set directly.");

	person = [ATPersonInfo currentPerson];
	person.emailAddress = @"settingEmailDirectlyAgain@example.com";
	[person saveAsCurrentPerson];
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"settingEmailDirectlyAgain@example.com"], @"Should be able to set the person object's email directly.");
	
	// Set initial email address prior to creating new person object
	[ATConnect sharedConnection].initialUserEmailAddress = @"setBeforeInit@example.com";
	person = [[[ATPersonInfo alloc] init] autorelease];
	[person saveAsCurrentPerson];
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"setBeforeInit@example.com"], @"A new person object should pick up the set initialUserEmailAddress.");
	
	[ATConnect sharedConnection].initialUserEmailAddress = @"settingToAnotherInitialEmailAddress@example.com";
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:@"settingToAnotherInitialEmailAddress@example.com"], @"Should be able to change the initial email address");
	
	// Initial email address validation
	NSString *valid = @"valid@example.com";
	XCTAssertTrue([ATUtilities emailAddressIsValid:valid], @"Valid email is valid.");
	NSString *invalid = @"INVALID";
	XCTAssertFalse([ATUtilities emailAddressIsValid:invalid], @"Invalid email is invalid.");
	person = [[[ATPersonInfo alloc] init] autorelease];
	[person saveAsCurrentPerson];
	[ATConnect sharedConnection].initialUserEmailAddress = valid;
	XCTAssertTrue([[ATConnect sharedConnection].initialUserEmailAddress isEqualToString:valid], @"Initial email should only be set to a valid email address.");
	XCTAssertTrue([[ATPersonInfo currentPerson].emailAddress isEqualToString:valid], @"Person's email should only be set to a valid email address.");
	[ATConnect sharedConnection].initialUserEmailAddress = invalid;
	XCTAssertTrue([[ATConnect sharedConnection].initialUserEmailAddress isEqualToString:valid], @"Initial email should only be set to a valid email address.");
	XCTAssertFalse([[ATConnect sharedConnection].initialUserEmailAddress isEqualToString:invalid], @"Initial email should NOT be set to an invalid email address.");
	XCTAssertFalse([[ATPersonInfo currentPerson].emailAddress isEqualToString:invalid], @"Person's email should NOT be set to an invalid initial email address.");
}


- (void)testCustomPersonData {
	ATPersonInfo *person = [[[ATPersonInfo alloc] init] autorelease];
	XCTAssertTrue([[person apiJSON] objectForKey:@"person"] != nil, @"A person should always have a base apiJSON key of 'person'");
	
	// Add standard types of data
	XCTAssertTrue([[[person apiJSON] objectForKey:@"person"] objectForKey:@"name"] == nil, @"Name should not be set.");
	person.name = @"Peter";
	XCTAssertTrue([[[[person apiJSON] objectForKey:@"person"] objectForKey:@"name"] isEqualToString:@"Peter"], @"Name should be set to 'Peter'");

	// Add custom person data
	XCTAssertTrue([[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] == nil, @"Custom data key should not exist if it has not been explicitly added.");
	[[ATConnect sharedConnection] addCustomPersonData:@"brown" withKey:@"hair_color"];
	[[ATConnect sharedConnection] addCustomPersonData:@(70) withKey:@"height"];
	[[ATConnect sharedConnection] addCustomPersonData:[NSNull null] withKey:@"nsNullCustomData"];
	
	// Arrays, dictionaries, etc. should throw exception if added to custom data
	NSDictionary *customDictionary = [NSDictionary dictionaryWithObject:@"thisShould" forKey:@"notWork"];
	@try {
		[[ATConnect sharedConnection] addCustomPersonData:customDictionary withKey:@"customDictionary"];
	}
	@catch (NSException * e) {
		XCTAssertTrue(e != nil, @"Attempting to add a dictionary to custom_data should throw an exception: %@", e);
	}
	@finally {
		XCTAssertTrue([[[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] objectForKey:@"customDictionary"] == nil, @"Dictionaries should not be added to custom_data");
	}
	
	// Test custom person data
	XCTAssertTrue(([[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] != nil), @"The person should have a `custom_data` parent attribute.");
	XCTAssertTrue([[[[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] objectForKey:@"hair_color"] isEqualToString:@"brown"], @"Custom data 'hair_color' should be 'brown'");
	XCTAssertTrue([[[[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] objectForKey:@"height"] isEqualToNumber:@(70)], @"Custom data 'height' should be '70'");
	XCTAssertTrue([[[[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] objectForKey:@"nsNullCustomData"] isEqual:[NSNull null]], @"Custom data 'nsNullCustomData' should be equal to '[NSNull null]'");

	// Remove custom person data
	[[ATConnect sharedConnection] removeCustomPersonDataWithKey:@"hair_color"];
	XCTAssertTrue([[[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] objectForKey:@"hair_color"] == nil, @"The 'hair_color' custom data was removed, should no longer be in custom_data");
	XCTAssertTrue([[[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] objectForKey:@"height"] != nil, @"The 'height' custom data was not removed, should still be in custom_data");
	[[ATConnect sharedConnection] removeCustomPersonDataWithKey:@"height"];
	[[ATConnect sharedConnection] removeCustomPersonDataWithKey:@"nsNullCustomData"];
	XCTAssertTrue([[[person apiJSON] objectForKey:@"person"] objectForKey:@"custom_data"] == nil, @"All custom data keys were removed; person data should no longer have a key for `custom_data`");
}

- (void)testCustomDeviceData {
	ATDeviceInfo *device = [[[ATDeviceInfo alloc] init] autorelease];
	XCTAssertTrue([[device apiJSON] objectForKey:@"device"] != nil, @"A device should always have a base apiJSON key of 'device'");
	
	// Add custom device data
	XCTAssertTrue([[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] == nil, @"Custom data key should not exist if it has not been explicitly added.");
	[[ATConnect sharedConnection] addCustomDeviceData:@"black" withKey:@"color"];
	[[ATConnect sharedConnection] addCustomDeviceData:@(499) withKey:@"MSRP"];
	[[ATConnect sharedConnection] addCustomDeviceData:[NSNull null] withKey:@"nsNullCustomData"];
	
	// Arrays, dictionaries, etc. should throw exception if added to custom data
	NSArray *customArray = [NSArray arrayWithObject:@"thisShouldNotWork"];
	@try {
		[[ATConnect sharedConnection] addCustomDeviceData:customArray withKey:@"customArray"];
	}
	@catch (NSException * e) {
		XCTAssertTrue(e != nil, @"Attempting to add an array to custom_data should throw an exception: %@", e);
	}
	@finally {
		XCTAssertTrue([[[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] objectForKey:@"customArray"] == nil, @"Arrays should not be added to custom_data");
	}
	
	// Test custom device data
	XCTAssertTrue(([[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] != nil), @"The device should have a `custom_data` parent attribute.");
	XCTAssertTrue([[[[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] objectForKey:@"color"] isEqualToString:@"black"], @"Custom data 'color' should be 'black'");
	XCTAssertTrue([[[[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] objectForKey:@"MSRP"] isEqualToNumber:@(499)], @"Custom data 'MSRP' should be '499'");
	XCTAssertTrue([[[[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] objectForKey:@"nsNullCustomData"] isEqual:[NSNull null]], @"Custom data 'nsNullCustomData' should be equal to '[NSNull null]'");
	
	// Remove custom device data
	[[ATConnect sharedConnection] removeCustomDeviceDataWithKey:@"color"];
	XCTAssertTrue([[[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] objectForKey:@"color"] == nil, @"The 'color' custom data was removed, should no longer be in custom_data");
	XCTAssertTrue([[[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] objectForKey:@"MSRP"] != nil, @"The 'MSRP' custom data was not removed, should still be in custom_data");
	[[ATConnect sharedConnection] removeCustomDeviceDataWithKey:@"MSRP"];
	[[ATConnect sharedConnection] removeCustomDeviceDataWithKey:@"nsNullCustomData"];
	XCTAssertTrue([[[device apiJSON] objectForKey:@"device"] objectForKey:@"custom_data"] == nil, @"All custom data keys were removed; device data should no longer have a key for `custom_data`");
}

@end

#import "MailMarker.h"

%hook MailboxPickerController

%new
- (void)ShowBlackList
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"BlackList" message:@"Please input an email address" preferredStyle:UIAlertControllerStyleAlert];
	 
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) 
	{
		UITextField *whitelistField = alertController.textFields.firstObject;
		if ([whitelistField.text length] != 0) 
			[[NSUserDefaults standardUserDefaults] setObject:whitelistField.text forKey:@"blacklist"];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:okAction];
	[alertController addAction:cancelAction];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) 
	{
		textField.placeholder = @"satbirtanda@gmail.com";
		textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"];
	}];

	[self presentViewController:alertController animated:YES completion:nil]; 
}

- (void)viewWillAppear:(BOOL)arg1 
{
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"BlackList" style:UIBarButtonItemStylePlain target:self action:@selector(ShowBlackList)] autorelease];
	%orig; 
}

%end

%hook MailboxContentViewController

- (void)miniMallMessageCountDidChange:(NSConcreteNotification *)arg1 
{
	%orig;
	NSMutableSet *targetMessages = [NSMutableSet setWithCapacity:600]; 
	NSString *blacklist = [[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"];
	MessageMiniMall *mall = [arg1 object];
	NSSet *messages = [mall copyAllMessages]; // Remember to release it later
	for (MFLibraryMessage *message in messages)
	{
		MFMessageInfo *messageInfo = [message copyMessageInfo]; // Remember to release it later
		for (NSString *sender in [message senders]) 
		{ 
			if (!messageInfo.read && [sender rangeOfString:[NSString stringWithFormat:@"<%@>", blacklist]].location != NSNotFound) 
			{
				[targetMessages addObject:message];
			}
			[messageInfo release]; 
		}
	}
	[messages release];
	[mall markMessagesAsViewed:targetMessages]; 
}

%end
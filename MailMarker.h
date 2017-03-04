@interface MailboxPickerController : UITableViewController
@end

@interface NSConcreteNotification : NSNotification 
@end

@interface MessageMiniMall : NSObject
- (void)markMessagesAsViewed:(NSSet *)arg1; 
- (NSSet *)copyAllMessages;
@end

@interface MFMessageInfo : NSObject 
@property (nonatomic) BOOL read; 
@end

@interface MFLibraryMessage : NSObject 
- (NSArray *)senders;
- (MFMessageInfo *)copyMessageInfo; 
@end

@interface MailboxContentViewController: UIViewController
- (void)miniMallMessageCountDidChange:(NSConcreteNotification *)arg1;
@end


@interface NSArray (MBIndexPath)
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;	//  Raises an NSRangeException if the indexPath goes beyond the bounds of the receiver.
- (NSIndexPath *)indexPathOfObject:(id)object;		//  Returns nil if the object does not exist within the receiver.
@end
#import "NSArray+MBNSIndexPath.h"

@interface NSArray (MBIndexPathPrivate)

- (NSUInteger *)createIndexesOfPathToObject:(id)object count:(NSUInteger *)count;	//  Returns a dynamically allocated array which must be freed by the caller. *count must be 0 when passed in.
@end


@implementation NSArray (MBIndexPath)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
	if (indexPath == nil)
		[NSException raise:NSInvalidArgumentException format:@""];
	
	id object = self;
	NSUInteger i;
	for (i = 0; i < [indexPath length]; i++)
	{
		if ([object isKindOfClass:[NSArray class]] == NO || [object count] <= [indexPath indexAtPosition:i])
			[NSException raise:NSRangeException format:@""];
		object = [object objectAtIndex:[indexPath indexAtPosition:i]];
	}
	return object;
}

- (NSIndexPath *)indexPathOfObject:(id)object;
{
	if (object == nil)
		[NSException raise:NSInvalidArgumentException format:@""];
	
	NSUInteger count = 0;
	NSUInteger *indexes = [self createIndexesOfPathToObject:object count:&count];
	
	if (indexes == NULL)
		return nil;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:count];
	free(indexes);
	return indexPath;
}

//  NSArray (MBIndexPathPrivate)
- (NSUInteger *)createIndexesOfPathToObject:(id)object count:(NSUInteger *)count;
{
	if (*count == NSUIntegerMax)
		return NULL;
	(*count)++;
	
	NSUInteger i;
	for (i = 0; i < [self count]; i++)
	{
		if ([[self objectAtIndex:i] isEqual:object])
		{
			NSUInteger *indexes = malloc(*count * sizeof(NSUInteger));
			if (indexes == NULL)
			{
				*count = NSUIntegerMax;
				return NULL;
			}
			indexes[*count - 1] = i;
			return (indexes + *count - 1);
		}
		else if ([[self objectAtIndex:i] isKindOfClass:[NSArray class]])
		{
			NSUInteger *indexes = [[self objectAtIndex:i] createIndexesOfPathToObject:object count:count];
			if (*count == NSUIntegerMax)
				return NULL;
			if (indexes != NULL)
			{
				*(indexes - 1) = i;
				return (indexes - 1);
			}
		}
	}
	
	(*count)--;
	return NULL;
}

@end
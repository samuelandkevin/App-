

#import "NSArray+MyLog.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
	NSMutableString *str = [NSMutableString stringWithFormat:@"%ld (\n", (unsigned long)self.count];

	for (id obj in self)
	{
		[str appendFormat:@"\t%@, \n", obj];
	}

	[str appendString:@")"];

	return str;
}

@end

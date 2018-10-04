

#import "NSDictionary+MyLog.h"

@implementation NSDictionary (MyLog)

- (NSString *)descriptionWithLocale:(id)locale
{
	NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];

	for (NSString *key in self)
	{
		id value = self[key];
		[str appendFormat:@"\t \"%@\" = %@,\n", key, value];
	}

	[str appendString:@"}"];

	return str;
}

@end



#import <Foundation/Foundation.h>
#import "NSString+HTML.h"
/**
 * @class YCAbstractNetworkService
 * @author Jon Woodhead
 * @date 18/04/2014
 * @version 1.0
 *  @discussion The underlying service that communicates with the external server. Contains much of the boiler plate code required. Used by YCCoreRecipeListService and YCSubmitRecipeService
 */
@interface YCAbstractNetworkService : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate>

@property (nonatomic,strong) NSString *currentString;
///A boolean to indicate whether the web service successfully returned a valid xml response
@property BOOL isSuccess;
@property (nonatomic,strong)  NSURLSessionTask *task;
/**
 * class method to return address where all webservices are based
 * @return web address (probably http://www.tourbeagle.com/YC)
 */
+(NSString*)webServiceAddress;
/**
 begin the data retireval process
 @param url the NSURL object
 */
-(void)startWithUrl:(NSURL*)url;
/** 
 process to parse the xml returned by the back end
 This is made seperately available to aid testing
 @param data - the data returned by the back end
 */
-(void)processResults:(NSData*)data;
/** 
 This is a dummy method that will run immediately before -(void)finish
 * in this class it does nothing but allows the user to add additional
 * processing to the results by overriding it before returning the results.
 */
-(void)sortResults;
/** 
 the final method to run when parsing and sorting data is complete
 This would normally be overridden to run an appropriate completion block
 */
-(void)finish;

/**
 cancel the current data enquiry
 */
-(void)cancel;
/**
 * strips out characters that will confuse the web service eg apostrophes and &
 @ param inputString
 @returns the replacement string
 */
 
-(NSString*)stringForWebService:(NSString*)inputString;
@end

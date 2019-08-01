// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "AKFError.h"

NS_ASSUME_NONNULL_BEGIN

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/**
 The AccountKit error domain for server errors (underlying errors).
 */
FOUNDATION_EXPORT NSErrorDomain const AKFServerErrorDomain
NS_SWIFT_NAME(ServerErrorDomain);

#else

/**
  The AccountKit error domain for server errors (underlying errors).
 */
FOUNDATION_EXPORT NSString *const AKFServerErrorDomain
NS_SWIFT_NAME(ServerErrorDomain);

#endif

#ifndef NS_ERROR_ENUM
#define NS_ERROR_ENUM(_domain, _name) \
enum _name: NSInteger _name; \
enum __attribute__((ns_error_domain(_domain))) _name: NSInteger
#endif

/**
 AKFServerErrorCode

 Detail error codes for server errors.
 */
typedef NS_ERROR_ENUM(AKFServerErrorDomain, AKFServerError)
{
  /**
   An invalid parameter value was found.


   The SDK does not know how to handle this parameter value from the server.
   */
  AKFServerErrorInvalidParameterValue = 201,
} NS_SWIFT_NAME(ServerError);

/**
 AKFLoginRequestError

 Detail error codes for login request invalidated errors.
 */
typedef NS_ERROR_ENUM(AKFErrorDomain, AKFLoginRequestError)
{
  /**
   The request has expired without completing.
   */
  AKFLoginRequestErrorExpired = 301,
} NS_SWIFT_NAME(LoginRequestError);

/**
 AKFInvalidParameterError

  Detail error codes for invalid parameter errors.
 */
typedef NS_ERROR_ENUM(AKFErrorDomain, AKFParameterError)
{
  /**
    The email address value is invalid.
   */
  AKFParameterErrorEmailAddress = 401,

  /**
    The phone number value is invalid.
   */
  AKFParameterErrorPhoneNumber = 402,

  /**
    The value is not of the appropriate type for NSCoding.
   */
  AKFParameterErrorCodingValue = 403,

  /**
    No valid access token is available.
   */
  AKFParameterErrorAccessToken = 404,

  /**
    The key for account preferences is invalid.
   */
  AKFParameterErrorAccountPreferenceKey = 405,

  /**
    The value for account preferences is invalid.
   */
  AKFParameterErrorAccountPreferenceValue = 406,

  /**
    The operation was not successful.
   */
  AKFParameterErrorOperationNotSuccessful = 407,

  /**
    The provided UIManager is not valid
   */
  AKFParameterErrorUIManager = 408,
} NS_SWIFT_NAME(ParameterError);

/**
 AKFServerResponseErrorCode

  Detail error codes for server response errors.
 */
typedef NS_ERROR_ENUM(AKFErrorDomain, AKFServerResponseError)
{
  AKFServerResponseErrorInvalidConfirmationCode = 15003,
} NS_SWIFT_NAME(ServerResponseError);

NS_ASSUME_NONNULL_END

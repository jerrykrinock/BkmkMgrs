
/***** Constants for licensing domain APP FAMILY (BkmkMgrs) *****/

// Note: Time zone for this is UTC offset 0 (UTC)
// #define HARD_EXPIRATION_STRING @"2022-11-30 23:59:59"
// Comment out the above line for a normal production release
#ifdef HARD_EXPIRATION_STRING
#warning This app can be freely used without a license until HARD_EXPIRATION_STRING.
NSString* const constLicensingParmsHardExpirationString = HARD_EXPIRATION_STRING ;
#else
NSString* const constLicensingParmsHardExpirationString = nil ;
#endif

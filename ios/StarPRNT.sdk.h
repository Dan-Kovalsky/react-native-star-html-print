//////////////////////////////////////////////////////////////////
/// FORWARD DELCARATION OF ALL STARPRNT NEEDED FUNCTIONALITIES ///
//////////////////////////////////////////////////////////////////
@interface ISCBBuilder : NSObject
- (void)beginDocument;
- (void)endDocument;
- (void)appendBitmap:(UIImage *)image
           diffusion:(BOOL)diffusion
               width:(NSInteger)width
           bothScale:(BOOL)bothScale;
- (void)appendCutPaper:(NSInteger)action;
@property (nonatomic, readonly) NSMutableData *commands;
@end

@interface StarIoExt : NSObject
+ (ISCBBuilder *)createCommandBuilder:(NSInteger)emulation;
@end

@interface StarIoExtManager : NSObject
@property (readonly, nonatomic) NSRecursiveLock *lock;
@property (readonly, nonatomic) SMPort *port;
- (id)initWithType:(NSInteger)type portName:(NSString *)portName portSettings:(NSString *)portSettings ioTimeoutMillis:(NSUInteger)ioTimeoutMillis;
- (BOOL)connect;
- (BOOL)disconnect;
@end

@interface SMPort : NSObject
@property(assign, readwrite, nonatomic) u_int32_t endCheckedBlockTimeoutMillis;
- (void)beginCheckedBlock:(void *)starPrinterStatus :(u_int32_t)level;
- (u_int32_t)writePort:(u_int8_t const *)writeBuffer :(u_int32_t)offSet :(u_int32_t)size;
- (void)endCheckedBlock:(void *)starPrinterStatus :(u_int32_t)level;
@end

@interface PortException : NSException
{
}
@end

#ifndef SM_BOOLEAN
#define SM_BOOLEAN u_int32_t
#endif
#define SM_TRUE ((u_int32_t) (1 == 1))
#define SM_FALSE ((u_int32_t) (0 > 1))
#define UCHAR  u_int8_t
#define UINT32 u_int32_t
#define MAX_UINT32 ((UINT32) UINT_MAX)

typedef struct StarPrinterStatus_2_
{
    // printer status 1
    SM_BOOLEAN coverOpen;
    SM_BOOLEAN offline;
    SM_BOOLEAN compulsionSwitch;
    
    // printer status 2
    SM_BOOLEAN overTemp;
    SM_BOOLEAN unrecoverableError;
    SM_BOOLEAN cutterError;
    SM_BOOLEAN mechError;
    SM_BOOLEAN headThermistorError;
    
    // printer status 3
    SM_BOOLEAN receiveBufferOverflow;
    SM_BOOLEAN pageModeCmdError;
    SM_BOOLEAN blackMarkError;
    SM_BOOLEAN presenterPaperJamError;
    SM_BOOLEAN headUpError;
    SM_BOOLEAN voltageError;
    
    // printer status 4
    SM_BOOLEAN receiptBlackMarkDetection;
    SM_BOOLEAN receiptPaperEmpty;
    SM_BOOLEAN receiptPaperNearEmptyInner;
    SM_BOOLEAN receiptPaperNearEmptyOuter;
    
    // printer status 5
    SM_BOOLEAN presenterPaperPresent;
    SM_BOOLEAN peelerPaperPresent;
    SM_BOOLEAN stackerFull;
    SM_BOOLEAN slipTOF;
    SM_BOOLEAN slipCOF;
    SM_BOOLEAN slipBOF;
    SM_BOOLEAN validationPaperPresent;
    SM_BOOLEAN slipPaperPresent;
    
    // printer status 6
    SM_BOOLEAN etbAvailable;
    UCHAR etbCounter;
    
    // printer status 7
    UCHAR presenterState;
    
    // raw
    UINT32 rawLength;
    UCHAR raw[63];
} StarPrinterStatus_2;

//////////////////////////////////////////////////////////////////
/// FORWARD DELCARATION OF ALL STARPRNT NEEDED FUNCTIONALITIES ///
//                            END                              ///
//////////////////////////////////////////////////////////////////

{
  Описание функций и структур Native API для Delphi by Ms-Rem and Jonny210.
  Только 100% проверенные функции.
  Last update: 19.04.2005 
}

unit NativeAPI;

interface

uses
    windows;

type
    NTStatus = cardinal;
    PVOID = pointer;
    USHORT = word;
    UCHAR = byte;
    PWSTR = PWideChar;

const
    NTDLL = 'ntdll.dll';
    FILE_ANY_ACCESS = $0000; // any type
    FILE_READ_ACCESS = $0001; // file & pipe
    FILE_READ_DATA = $0001; // file & pipe
    FILE_WRITE_ACCESS = $0002; // file & pipe
    FILE_WRITE_DATA = $0002; // file & pipe
    FILE_CREATE_PIPE_INSTANCE = $0004; // named pipe
    FILE_READ_ATTRIBUTES = $0080; // all types
    FILE_WRITE_ATTRIBUTES = $0100; // all types
    STANDARD_RIGHTS_ALL = $001F0000;
    FILE_ALL_ACCESS = FILE_READ_ACCESS or
        FILE_WRITE_ACCESS or
        FILE_CREATE_PIPE_INSTANCE or
        FILE_READ_ATTRIBUTES or
        FILE_WRITE_ATTRIBUTES or
        STANDARD_RIGHTS_ALL;

const  //Статус константы
    STATUS_SUCCESS = NTStatus($00000000);
    STATUS_ACCESS_DENIED = NTStatus($C0000022);
    STATUS_INFO_LENGTH_MISMATCH = NTStatus($C0000004);
    SEVERITY_ERROR = NTStatus($C0000000);

const// SYSTEM_INFORMATION_CLASS 
    SystemBasicInformation = 0;
    SystemProcessorInformation = 1;
    SystemPerformanceInformation = 2;
    SystemTimeOfDayInformation = 3;
    SystemNotImplemented1 = 4;
    SystemProcessesAndThreadsInformation = 5;
    SystemCallCounts = 6;
    SystemConfigurationInformation = 7;
    SystemProcessorTimes = 8;
    SystemGlobalFlag = 9;
    SystemNotImplemented2 = 10;
    SystemModuleInformation = 11;
    SystemLockInformation = 12;
    SystemNotImplemented3 = 13;
    SystemNotImplemented4 = 14;
    SystemNotImplemented5 = 15;
    SystemHandleInformation = 16;
    SystemObjectInformation = 17;
    SystemPagefileInformation = 18;
    SystemInstructionEmulationCounts = 19;
    SystemInvalidInfoClass = 20;
    SystemCacheInformation = 21;
    SystemPoolTagInformation = 22;
    SystemProcessorStatistics = 23;
    SystemDpcInformation = 24;
    SystemNotImplemented6 = 25;
    SystemLoadImage = 26;
    SystemUnloadImage = 27;
    SystemTimeAdjustment = 28;
    SystemNotImplemented7 = 29;
    SystemNotImplemented8 = 30;
    SystemNotImplemented9 = 31;
    SystemCrashDumpInformation = 32;
    SystemExceptionInformation = 33;
    SystemCrashDumpStateInformation = 34;
    SystemKernelDebuggerInformation = 35;
    SystemContextSwitchInformation = 36;
    SystemRegistryQuotaInformation = 37;
    SystemLoadAndCallImage = 38;
    SystemPrioritySeparation = 39;
    SystemNotImplemented10 = 40;
    SystemNotImplemented11 = 41;
    SystemInvalidInfoClass2 = 42;
    SystemInvalidInfoClass3 = 43;
    SystemTimeZoneInformation = 44;
    SystemLookasideInformation = 45;
    SystemSetTimeSlipEvent = 46;
    SystemCreateSession = 47;
    SystemDeleteSession = 48;
    SystemInvalidInfoClass4 = 49;
    SystemRangeStartInformation = 50;
    SystemVerifierInformation = 51;
    SystemAddVerifier = 52;
    SystemSessionProcessesInformation = 53;


type
    PClientID = ^TClientID;

    TClientID = packed record
        UniqueProcess : cardinal;
        UniqueThread : cardinal;
    end;

    PUnicodeString = ^TUnicodeString;

    TUnicodeString = packed record
        Length : word;
        MaximumLength : word;
        Buffer : PWideChar;
    end;

    PAnsiString = ^TAnsiString;

    TAnsiString = packed record
        Length : word;
        MaximumLength : word;
        Buffer : pchar;
    end;

    TPoolType = (
        NonPagedPool,
        PagedPool,
        NonPagedPoolMustSucceed,
        DontUseThisType,
        NonPagedPoolCacheAligned,
        PagedPoolCacheAligned,
        NonPagedPoolCacheAlignedMustS,
        MaxPoolType,
        NonPagedPoolSession, // !!! NonPagedPoolSession = 32
        PagedPoolSession,
        NonPagedPoolMustSucceedSession,
        DontUseThisTypeSession,
        NonPagedPoolCacheAlignedSession,
        PagedPoolCacheAlignedSession,
        NonPagedPoolCacheAlignedMustSSession
        );

 {                                 //    Value   Query   Set
  TObjectInformationClass = (
    ObjectBasicInformation,        //     0       Y       N
    ObjectNameInformation,         //     1       Y       N
    ObjectTypeInformation,         //     2       Y       N
    ObjectAllTypesInformation,     //     3       Y       N
    ObjectHandleInformation        //     4       Y       Y
  );
  }
  // Information Class 0
    PObjectBasicInformation = ^TObjectBasicInformation;

    TObjectBasicInformation = packed record
        Attributes : ULONG;
        GrantedAccess : ACCESS_MASK;
        HandleCount : ULONG;
        PointerCount : ULONG;
        PagedPoolUsage : ULONG;
        NonPagedPoolUsage : ULONG;
        Reserved : array[0..2] of ULONG;
        NameInformationLength : ULONG;
        TypeInformationLength : ULONG;
        SecurityDescriptorLength : ULONG;
        CreateTime : LARGE_INTEGER;
    end;

  // Information Class 1
    PObjectNameInformation = ^TObjectNameInformation;

    TObjectNameInformation = packed record
        Name : TUnicodeString;
    end;

  // Information Class 2
    PObjectTypeInformation = ^TObjectTypeInformation;

    TObjectTypeInformation = packed record
        Name : TUnicodeString;
        ObjectCount : ULONG;
        HandleCount : ULONG;
        Reserved1 : array[0..3] of ULONG;
        PeakObjectCount : ULONG;
        PeakHandleCount : ULONG;
        Reserved2 : array[0..3] of ULONG;
        InvalidAttributes : ULONG;
        GenericMapping : GENERIC_MAPPING;
        ValidAccess : ULONG;
        Unknown : UCHAR;
        MaintainHandleDatabase : boolean;
        PoolType : TPoolType;
        PagedPoolUsage : ULONG;
        NonPagedPoolUsage : ULONG;
    end;

  // Information Class 3
    PObjectAllTypesInformation = ^TObjectAllTypesInformation;

    TObjectAllTypesInformation = packed record
        NumberOfTypes : ULONG;
        TypeInformation : TObjectTypeInformation;
    end;

  // Information Class 4
    PObjectHandleInformation = ^TObjectHandleInformation;

    TObjectHandleInformation = packed record
        Inherit : boolean;
        ProtectFromClose : boolean;
    end;

    PTHREAD_BASIC_INFORMATION = ^THREAD_BASIC_INFORMATION;

    THREAD_BASIC_INFORMATION = packed record
        ExitStatus : BOOL;
        TebBaseAddress : pointer;
        ClientId : TClientID;
        AffinityMask : DWORD;
        Priority : dword;
        BasePriority : dword;
    end;

    PSYSTEM_HANDLE_INFORMATION = ^SYSTEM_HANDLE_INFORMATION;

    SYSTEM_HANDLE_INFORMATION = packed record
        ProcessId : dword;
        ObjectTypeNumber : byte;
        Flags : byte;
        Handle : word;
        pObject : pointer;
        GrantedAccess : dword;
    end;

    PSYSTEM_HANDLE_INFORMATION_EX = ^SYSTEM_HANDLE_INFORMATION_EX;

    SYSTEM_HANDLE_INFORMATION_EX = packed record
        NumberOfHandles : dword;
        Information : array [0..0] of SYSTEM_HANDLE_INFORMATION;
    end;

    PSYSTEM_LOAD_IMAGE = ^SYSTEM_LOAD_IMAGE;

    SYSTEM_LOAD_IMAGE = packed record
        ModuleName : TUnicodeString;
        ModuleBase : pointer;
        Unknown : pointer;
        EntryPoint : pointer;
        ExportDirectory : pointer;
    end;

    PVM_COUNTERS = ^VM_COUNTERS;

    VM_COUNTERS = packed record
        PeakVirtualSize,
        VirtualSize,
        PageFaultCount,
        PeakWorkingSetSize,
        WorkingSetSize,
        QuotaPeakPagedPoolUsage,
        QuotaPagedPoolUsage,
        QuotaPeakNonPagedPoolUsage,
        QuotaNonPagedPoolUsage,
        PagefileUsage,
        PeakPagefileUsage : dword;
    end;

    PIO_COUNTERS = ^IO_COUNTERS;

    IO_COUNTERS = packed record
        ReadOperationCount,
        WriteOperationCount,
        OtherOperationCount,
        ReadTransferCount,
        WriteTransferCount,
        OtherTransferCount : LARGE_INTEGER;
    end;


    PSYSTEM_THREADS = ^SYSTEM_THREADS;

    SYSTEM_THREADS = packed record
        KernelTime,
        UserTime,
        CreateTime : LARGE_INTEGER;
        WaitTime : dword;
        StartAddress : pointer;
        ClientId : TClientId;
        Priority,
        BasePriority,
        ContextSwitchCount : dword;
        State : dword;
        WaitReason : dword;
    end;


    PSYSTEM_PROCESSES = ^SYSTEM_PROCESSES;

    SYSTEM_PROCESSES = packed record
        NextEntryDelta,
        ThreadCount : dword;
        Reserved1 : array [0..5] of dword;
        CreateTime,
        UserTime,
        KernelTime : LARGE_INTEGER;
        ProcessName : TUnicodeString;
        BasePriority : dword;
        ProcessId,
        InheritedFromProcessId,
        HandleCount : dword;
        Reserved2 : array [0..1] of dword;
        VmCounters : VM_COUNTERS;
        IoCounters : IO_COUNTERS; // Windows 2000 only
        Threads : array [0..0] of SYSTEM_THREADS;
    end;

    PObjectAttributes = ^TObjectAttributes;

    TObjectAttributes = packed record
        Length : DWORD;
        RootDirectory : THandle;
        ObjectName : PUnicodeString;
        Attributes : DWORD;
        SecurityDescriptor : Pointer;
        SecurityQualityOfService : Pointer;
    end;


    PPROCESS_BASIC_INFORMATION = ^_PROCESS_BASIC_INFORMATION;

    _PROCESS_BASIC_INFORMATION = packed record
        ExitStatus : BOOL;
        PebBaseAddress : pointer;
        AffinityMask : PULONG;
        BasePriority : dword;
        UniqueProcessId : ULONG;
        InheritedFromUniqueProcessId : ULONG;
    end;

//LPC structures

    PPORT_MESSAGE = ^_PORT_MESSAGE;

    _PORT_MESSAGE = packed record
        DataSize,
        MessageSize,
        MessageType,
        VirtualRangesOffset : dword;
        ClientId : TClientID;
        MessageId,
        SectionSize : dword;
        Data : array[0..0] of dword;
    end;

    PSECURITY_QUALITY_OF_SERVICE = ^_SECURITY_QUALITY_OF_SERVICE;

    _SECURITY_QUALITY_OF_SERVICE = packed record
        Length : dword;
        ImpersonationLevel : TSecurityImpersonationLevel;
        ContextTrackingMode : bool;
        EffectiveOnly : bool;
    end;

    PPORT_SECTION_WRITE = ^_PORT_SECTION_WRITE;

    _PORT_SECTION_WRITE = packed record
        Length : dword;
        SectionHandle : THandle;
        SectionOffset,
        ViewSize : dword;
        ViewBase : pointer;
        TargetViewBase : pointer;
    end;

    PPORT_SECTION_READ = ^_PORT_SECTION_READ;

    _PORT_SECTION_READ = packed record
        Length,
        ViewSize,
        ViewBase : dword;
    end;

    PIO_STATUS_BLOCK = ^IO_STATUS_BLOCK;

    IO_STATUS_BLOCK = packed record //        ; sizeof = 08h
        Status : DWORD;//        ?    ; 0000h  NTSTATUS
        Information : DWORD;
    end;

    PFILE_FULL_EA_INFORMATION = ^FILE_FULL_EA_INFORMATION;

    FILE_FULL_EA_INFORMATION = packed record
        NextEntryOffset : dword;
        Flags : byte;
        EaNameLength : byte;
        EaValueLength : word;
        EaName : array [0..0] of char;
    end;


const
    LOCK_VM_IN_WSL = $01;
    LOCK_VM_IN_RAM = $02;


////////////////////////// Ntdll.dll Functions ///////////////////////

function ZwCreateThread(ThreadHandle : pdword; DesiredAccess : ACCESS_MASK; ObjectAttributes : pointer; ProcessHandle : THandle; ClientId : PClientID; ThreadContext : pointer; UserStack : pointer; CreateSuspended : boolean) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwResumeThread(ThreadHandle : dword; PreviousSuspendCount : pdword) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwQueryInformationThread(ThreadHandle : dword; ThreadInformationClass : dword; ThreadInformation : pointer; ThreadInformationLength : dword; ReturnLength : pdword) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwOpenProcess(phProcess : PDWORD; AccessMask : DWORD; ObjectAttributes : PObjectAttributes; ClientID : PClientID) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwOpenThread(ThreadHandle : PHANDLE; DesiredAccess : ACCESS_MASK; ObjectAttributes : PObjectAttributes; ClientId : PClientID) : NTStatus; stdcall; external 'ntdll.dll';

procedure ZwReadVirtualMemory(ProcessHandle : THANDLE; BaseAddress : POINTER; var Buffer : pointer; BufferLength : ULONG; var ReturnLength : PULONG); stdcall; external 'ntdll.dll';

function ZwQueryInformationProcess(ProcessHandle : THANDLE; ProcessInformationClass : DWORD; ProcessInformation : pointer; ProcessInformationLength : ULONG; ReturnLength : PULONG) : NTStatus; stdcall;
    external 'ntdll.dll';

function ZwWriteVirtualMemory(ProcessHandle : THANDLE; BaseAddress : pointer; Buffer : pointer; BufferLength : dword; ReturnLength : PULONG) : NTStatus; stdcall; external 'ntdll.dll';

function ZwProtectVirtualMemory(ProcessHandle : THANDLE; BaseAddress : pointer; ProtectSize : PULONG; NewProtect : dword; OldProtect : pulong) : NTStatus; stdcall; external 'ntdll.dll';

function ZwQuerySystemInformation(ASystemInformationClass : dword; ASystemInformation : Pointer; ASystemInformationLength : dword; AReturnLength : PCardinal) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwTerminateProcess(ProcessHandle : dword; ExitStatus : dword) : NTStatus; stdcall; external 'ntdll.dll';

function ZwAllocateVirtualMemory(ProcessHandle : THANDLE; BaseAddress : pointer; ZeroBits : dword; AllocationSize : pdword; AllocationType : dword; Protect : dword) : NTStatus; stdcall; external 'ntdll.dll';

procedure KiFastSystemCall; stdcall; external 'ntdll.dll';

function ZwClose(Handle : dword) : NTStatus; stdcall; external 'ntdll.dll';

function ZwOpenSection(SectionHandle : PHandle; AccessMask : DWORD; ObjectAttributes : PObjectAttributes) : DWORD;
    stdcall; external 'NTDLL.DLL';

procedure RtlInitUnicodeString(DestinationString : PUnicodeString; SourceString : PWideChar);
    stdcall; external 'ntdll.dll';

procedure RtlInitAnsiString(DestinationString : PAnsiString; SourceString : pchar);
    stdcall; external 'ntdll.dll';

function RtlAnsiStringToUnicodeString(DestinationString : PUnicodeString; SourceString : PAnsiString; AllocateDestinationString : boolean) : NTSTATUS; stdcall external 'ntdll.dll';


function RtlUnicodeStringToAnsiString(DestinationString : PAnsiString; SourceString : PUnicodeString; AllocateDestinationString : boolean) : NTSTATUS; stdcall external 'ntdll.dll';


procedure RtlFreeAnsiString(ansistring : PAnsiString); stdcall external 'ntdll.dll';


procedure RtlFreeUnicodeString(UnicodeString : PUnicodeString); stdcall external 'ntdll.dll';


function RtlAppendUnicodeStringToString(Destination : PUnicodeString; Source : PUnicodeString) : NTSTATUS; stdcall external NTDLL;


function RtlAppendUnicodeToString(Destination : PUnicodeString; Source : PWideChar) : NTSTATUS; stdcall external NTDLL;


function ZwMapViewOfSection(SectionHandle : dword; ProcessHandle : dword; BaseAddress : PPointer; ZeroBits, CommitSize : dword; SectionOffset : PInt64; ViewSize : pdword; InheritDisposition : dword; AllocationType, Protect : dword) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwUnmapViewOfSection(ProcessHandle : dword; BaseAddress : pointer) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwCreateNamedPipeFile(FileHandle : PHandle; DesiredAccess : ACCESS_MASK; ObjectAttributes : POBJECTATTRIBUTES; IoStatusBlock : pointer; ShareAccess, CreateDisposition, CreateOptions : dword; TypeMessage, ReadmodeMessage, Nonblocking : boolean; MaxInstances, InBufferSize, OutBufferSize : dword; DefaultTimeout : PDword) : NTStatus;
    stdcall; external 'ntdll.dll';

//LPC functions
function ZwCreatePort(PortHandle : PDWORD; ObjectAttributes : PObjectAttributes; MaxDataSize, MaxMessageSize, Reserved : dword) : NTStatus; stdcall; external 'ntdll.dll';

function ZwQueryDirectoryFile(FileHandle : dword; Event : dword; ApcRoutine : pointer; ApcContext : pointer; IoStatusBlock : pointer; FileInformation : pointer; FileInformationLength : dword; FileInformationClass : dword; ReturnSingleEntry : bool; FileName : PUnicodeString; RestartScan : bool) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwConnectPort(PortHandle : PDWORD; PortName : PUnicodeString; SecurityQos : PSECURITY_QUALITY_OF_SERVICE; WriteSection : PPORT_SECTION_WRITE; ReadSection : PPORT_SECTION_READ; MaxMessageSize : PULONG; ConnectData : pointer; ConnectDataLength : PULONG) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwListenPort(PortHandle : THandle; var Msg : PPORT_MESSAGE) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwRequestWaitReplyPort(PortHandle : THandle; RequestMessage : PPORT_MESSAGE; var ReplyMessage : PPORT_MESSAGE) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwAcceptConnectPort(PortHandle : PHANDLE; PortIdentifier : dword; PortMessage : PPORT_MESSAGE; Accept : bool; WriteSection : PPORT_SECTION_WRITE; ReadSection : PPORT_SECTION_READ) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwCompleteConnectPort(PortHandle : THandle) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwRequestPort(PortHandle : THandle; RequestMessage : PPORT_MESSAGE) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwReplyPort(PortHandle : THandle; RequestMessage : PPORT_MESSAGE) : NTStatus;
    stdcall; external 'ntdll.dll';


function ZwSetSystemInformation(SystemInformationClass : dword; SystemInformation : pointer; SystemInformationLength : dword) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwLoadDriver(DriverServiceName : PUnicodeString) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwUnloadDriver(DriverServiceName : PUnicodeString) : NTStatus;
    stdcall; external 'ntdll.dll';

function DbgPrint(const Format : PAnsiChar) : NTStatus; cdecl; external NTDLL;


//**** Registry ******

function ZwCreateKey(KeyHandle : pdword; DesiredAccess : ACCESS_MASK; ObjectAttributes : PObjectAttributes; TitleIndex : ULONG; ObjectClass : PUnicodeString; CreateOptions : ULONG; Disposition : PULONG) : NTSTATUS; stdcall; external 'ntdll.dll';

function ZwDeleteKey(KeyHandle : THandle) : NTSTATUS;
    stdcall; external 'ntdll.dll'


function LdrLoadDll(szcwPath : PWideChar; pdwLdrErr : dword; pUniModuleName : PUnicodeString; pResultInstance : PDWORD) : NTSTATUS;
    stdcall; external 'ntdll.dll';

function LdrGetProcedureAddress(hModule : dword; dOrdinal : DWORD; psName : PUnicodeString; ppProcedure : ppointer) : NTStatus;
    stdcall; external 'ntdll.dll';

function ZwLockVirtualMemory(ProcessHandle : dword; BaseAddress : ppointer; LockSize : pdword; LockType : dword) : NTStatus;
    stdcall; external 'ntdll.dll';

function DbgUiDebugActiveProcess(pHandle : dword) : NTStatus; stdcall; external 'ntdll.dll';
function DbgUiConnectToDbg() : NTStatus; stdcall; external 'ntdll.dll';

function ZwQueryEaFile(FileHandle : dword; IoStatusBlock : PIO_STATUS_BLOCK; Buffer : pointer; BufferLength : dword; ReturnSingleEntry : bool; EaList : pointer;// OPTIONAL,
    EaListLength : dword; EaIndex : pdword;// OPTIONAL,
    RestartScan : bool) : NTStatus;
    stdcall; external 'ntdll.dll';


type
    PSYSTEM_MODULE_INFORMATION = ^SYSTEM_MODULE_INFORMATION;

    SYSTEM_MODULE_INFORMATION = packed record // Information Class 11
        Reserved : array[0..1] of ULONG;
        Base : PVOID;
        Size : ULONG;
        Flags : ULONG;
        Index : USHORT;
        Unknown : USHORT;
        LoadCount : USHORT;
        ModuleNameOffset : USHORT;
        ImageName : array [0..255] of char;
    end;

    PSYSTEM_MODULE_INFORMATION_EX = ^SYSTEM_MODULE_INFORMATION_EX;

    SYSTEM_MODULE_INFORMATION_EX = packed record
        ModulesCount : dword;
        Modules : array[0..0] of SYSTEM_MODULE_INFORMATION;
    end;

const
    THREAD_BASIC_INFO = $0;
    THREAD_QUERY_INFORMATION = $40;
    ProcessBasicInformation = 0;
    OBJ_CASE_INSENSITIVE = $00000040;
    OBJ_KERNEL_HANDLE = $00000200;

//LPC constants
    LPC_NEW_MESSAGE = 1;
    LPC_REQUEST = 2;
    LPC_REPLY = 3;
    LPC_DATAGRAM = 4;
    LPC_LOST_REPLY = 5;
    LPC_PORT_CLOSED = 6;
    LPC_CLIENT_DIED = 7;
    LPC_EXCEPTION = 8;
    LPC_DEBUG_EVENT = 9;
    LPC_ERROR_EVENT = 10;
    LPC_CONNECTION_REQUEST = 11;

procedure InitializeObjectAttributes(InitializedAttributes : PObjectAttributes; pObjectName : PUnicodeString; const uAttributes : ULONG; const hRootDirectory : THandle; pSecurityDescriptor : PSECURITY_DESCRIPTOR);

function GetInfoTable(ATableType : dword) : Pointer;


implementation

{ инициализация структуры TObjectAttributes }
procedure InitializeObjectAttributes(InitializedAttributes : PObjectAttributes; pObjectName : PUnicodeString; const uAttributes : ULONG; const hRootDirectory : THandle; pSecurityDescriptor : PSECURITY_DESCRIPTOR);
begin
    with InitializedAttributes^ do
    begin
        Length := SizeOf(TObjectAttributes);
        ObjectName := pObjectName;
        Attributes := uAttributes;
        RootDirectory := hRootDirectory;
        SecurityDescriptor := pSecurityDescriptor;
        SecurityQualityOfService := nil;
    end;
end;

{ Получение буфера с системной информацией }
function GetInfoTable(ATableType : dword) : Pointer;
var
    mSize : dword;
    mPtr : pointer;
    St : NTStatus;
begin
    Result := nil;
    mSize := $4000; //начальный размер буффера
    repeat
        mPtr := VirtualAlloc(nil, mSize, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE);
        if mPtr = nil then
        begin
            Exit;
        end;
        St := ZwQuerySystemInformation(ATableType, mPtr, mSize, nil);
        if St = STATUS_INFO_LENGTH_MISMATCH then
        begin //надо больше памяти
            VirtualFree(mPtr, 0, MEM_RELEASE);
            mSize := mSize * 2;
        end;
    until St <> STATUS_INFO_LENGTH_MISMATCH;
    if St = STATUS_SUCCESS then
    begin
        Result := mPtr;
    end
    else
    begin
        VirtualFree(mPtr, 0, MEM_RELEASE);
    end;
end;


end.

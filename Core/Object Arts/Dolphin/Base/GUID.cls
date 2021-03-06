﻿"Filed out from Dolphin Smalltalk 7"!

Object variableByteSubclass: #GUID
	instanceVariableNames: ''
	classVariableNames: 'Null'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GUID guid: (GUID fromString: '{87b4c48f-026e-11d3-9fd7-00a0cc3e4a32}')!
GUID comment: 'GUID is the class of 128-bit Globally Unique Identifiers (guids) which are used wherever a unique identifier is required in COM, for example to identify specific coclasses and interfaces.

You can easily allocate a new GUID by sending #newUnique to this class. Note that this process is very fast, so there is no particular reason not to use GUIDs for other purposes requiring unique identifiers such as records in a database.

Note: In versions of Dolphin prior to 2.2 GUID was a subclass of ExternalStructure. Although logically GUID belongs under ExternalStructure, it was move for reasons of space efficiency (every class now has a unique GUID).

Instance Variables:
	None (byte class)

Class Variables:
	Null	- The null <GUID>.'!
!GUID categoriesForClass!External-Data-Structured-COM! !
!GUID methodsFor!

_collate: comperand
	"Private - Answer the ordering relationship between the receiver
	and the argument, comperand."

	| status answer |
	status := ByteArray newFixed: 4.
	answer := RPCLibrary default uuidCompare: self uuid2: comperand status: status.
	status := status dwordAtOffset: 0.
	status == 0 ifFalse: [RPCError signalWith: status].
	^answer!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand."

	^self species = comperand species and: [(self _collate: comperand) == 0]!

asByteArray
	"Answer the raw contents of the receiver as a byte array."

	^self yourAddress asExternalAddress copyFrom: 1 to: self size!

asInteger
	"Answer the 128-bit integer value of the receiver."

	| answer |
	answer := ByteArray new: 16.
	self 
		replaceBytesOf: answer
		from: 1
		to: 16
		startingAt: 1.
	answer isImmutable: true.
	^answer becomeA: LargeInteger!

asObject
	"Answer the <Object> value represented by the receiver."

	^self!

asString
	"Answer a string representation of the receiver.
	Implementation Note: We want to use the standard COM string
	representation, so we need to add curly brackets. We could use the 
	COM function, but that would mean creating a dependency on 
	OLELibrary."

	| sz |
	sz := self stringSize.
	^(String new: sz)
		at: 1 put: ${;
		replaceFrom: 2
			to: sz - 1
			with: self idlString
			startingAt: 1;
		at: sz put: $};
		yourself!

displayOn: target
	"Append an 'end-user suitable' textual representation of the receiver to the
	<puttableStream> argument, target.
	GUIDs are a fairly technical concept, but they do appear in the registry in a
	certain format, which we use here."

	target nextPutAll: self asString!

hash
	"Hash the bytes of the object using the standard byte hashing
	primitive (which should not fail)."

	| hash |
	<primitive: 106>
	hash := 2166136261.
	"FNV1a"
	1 to: self basicSize
		do: [:i | hash := (hash bitXor: (self basicAt: i)) * 16777619 bitAnd: 16rFFFFFFFF].
	"Fold to 30 bits so is always positive SmallInteger"
	^(hash bitShift: -30) bitXor: (hash bitAnd: 16r3FFFFFFF)!

idlString
	"Answer the IDL string representation of the receiver.
		self newUnique idlString
	"

	| pSz answer status |
	pSz := ExternalAddress new.
	(status := RPCLibrary default uuidToString: self stringUuid: pSz) == 0 ifFalse: [RPCError signal: status].
	answer := AnsiString fromAddress: pSz.
	RPCLibrary default rpcStringFree: pSz.
	^answer
!

isNull
	"Answer whether the receiver is a null external data item
	(that is, a null pointer, or a nilled out structure)."

	^self = self class null!

notNull
	"Answer whether the receiver is a null external data item (that is, a null pointer, or a
	nilled out structure)."

	^self isNull not!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: self;
		nextPut: $)!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:

	Primitive Failure Reasons:
		0 	- fromStart is not a SmallInteger.
		1	- stop is not a SmallInteger.
		2	- start is not a SmallInteger.
		3	- aByteObject is not a byte object
		4	- 'from' or 'to' interval is out-of-bounds
	"

	| fromOffset |
	<primitive: 142>
	fromOffset := fromStart - start.
	stop to: start by: -1 do: [:i | aByteObject at: i put: (self basicAt: i + fromOffset)].
	^aByteObject!

species
	"Answer the preferred class of the receiver - not always the same as the
	answer to #class (in this case the species of GUID and its subclasses 
	is always GUID)."

	^GUID!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when evaluated will answer a <GUID> equivalent to the receiver."

	aStream
		nextPut: $(;
		print: self class;
		space;
		nextPutAll: #fromString:;
		space;
		print: self asString;
		nextPut: $)!

stringSize
	"Answer the number of characters in a GUID string."

	^38!

value: guidBytes
	"Set the raw binary value of the receiver from those of the argument."

	guidBytes replaceBytesOf: self from: 1 to: self class byteSize startingAt: 1! !
!GUID categoriesFor: #_collate:!comparing!private! !
!GUID categoriesFor: #=!comparing!public! !
!GUID categoriesFor: #asByteArray!converting!public! !
!GUID categoriesFor: #asInteger!converting!public! !
!GUID categoriesFor: #asObject!accessing!public! !
!GUID categoriesFor: #asString!converting!public! !
!GUID categoriesFor: #displayOn:!printing!public! !
!GUID categoriesFor: #hash!comparing!public! !
!GUID categoriesFor: #idlString!converting!public! !
!GUID categoriesFor: #isNull!public!testing! !
!GUID categoriesFor: #notNull!public!testing! !
!GUID categoriesFor: #printOn:!development!printing!public! !
!GUID categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
!GUID categoriesFor: #species!accessing!public! !
!GUID categoriesFor: #storeOn:!printing!public! !
!GUID categoriesFor: #stringSize!constants!public! !
!GUID categoriesFor: #value:!accessing!public! !

!GUID class methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	Implementation Note: The receiver is actually defined as a structure
	of the following form:
		typedef struct _GUID {
		    unsigned long  Data1;
		    unsigned short Data2;
		    unsigned short Data3;
		    unsigned char  Data4[ 8 ];
		} GUID;
	This means it's maximum alignment requirement is for a 32-bit integer,
	i.e. 4 rather than 16.
	"

	^4!

atAddress: anAddress
	"Answer a new instance of the receiver instantiated from the
	data at the specified address. Normally  this will be a 'reference' 
	instance, that points at the data embedded	at the specified address. 
	However in the case of objects that always have reference form
	(e.g. COM interface pointers, BSTRs, etc) this will be a copy
	of the pointer at that address. This is particularly useful for accessing
	elements of arrays."

	^self fromAddress: anAddress!

basicByteSize
	^16!

byteSize
	"Answer the size in bytes of this structure"

	^self basicByteSize!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap
	which resides at the specified address. Note that this is not about freeing
	the specified memory block, but any resources which it references."!

defineFields
	"Define the fields of the GUID structure.
		GUID defineTemplate
	
		typedef 		struct tagGUID {
			unsigned long Data1;
			unsigned short Data2;
			unsigned short Data3;
			char Data4[8];
		} GUID;

	"

	"This method only present to prevent auto-generation from stdole type library

	self
		defineField: #Data1 type: DWORDField new offset: 0;
		defineField: #Data2 type: WORDField new offset: 4;
		defineField: #Data3 type: WORDField new offset: 6;
		defineField: #Data4 type: (ArrayField type: ByteArray length: 8) offset: 8.
	self byteSize: 16"


!

elementSize
	"Private - Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^self byteSize!

fromAddress: ptr
	"Answer a new instance of the receiver with contents copied from
	the  GUID pointed at by ptr"

	^ptr asExternalAddress
		replaceBytesOf: self newNull
		from: 1 to: 16 startingAt: 1!

fromBytes: guidBytes
	"Answer a new instance of the receiver which is a copy of the specified bytes."

	^guidBytes replaceBytesOf: self newNull from: 1 to: self byteSize startingAt: 1
!

fromIdlString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString,
	which is in IDL format."

	| answer status |
	answer := self newNull.
	(status := RPCLibrary default uuidFromString: aString uuid: answer) == 0
		ifFalse: [RPCError signalWith: status].
	^answer!

fromString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString,
	which is in Microsoft(tm) GUID format.
	Implementation Note: Subclasses override this because OLE defines more specific
	functions for that purpose, which we use to be good boys, even though it appears not
	to be necessary (i.e. if we drop down a level and use the underlying
	RPC library function, it works anyway)."

	| answer status |
	answer := self newNull.
	(status := RPCLibrary default uuidFromString: (aString copyFrom: 2 to: aString size - 1) uuid: answer) == 0
		ifFalse: [RPCError signalWith: status].
	^answer!

init: addressOrBytes
	"Initialize an instance of the structure which instances of the receiver wrap
	which resides at the specified address."!

initialize
	"Private - Initialize the receiver's class variables.
		GUID initialize
	"
	self extraInstanceSpec: self byteSize!

new
	"Answer a new, null, instance of the receiver."

	^self new: self byteSize!

newBuffer
	"Answer a new instance containing its own buffer."

	^self newNull
!

newNull
	"Answer a new, null, instance of the receiver."

	^self new: self byteSize!

newUnique
	"Answer a new instance of the receiver generated using the standard
	algorithm (i.e. the answer should be unique)."

	| answer |
	answer := self newNull.
	RPCLibrary default uuidCreate: answer.
	^answer!

null
	"Answer a null instance of the receiver."

	Null isNil ifTrue: [Null := self newNull].
	^Null!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized class vars in preparation for image stripping."

	self uninitialize!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	Null := nil.
	VMLibrary default registryAt: #GUID put: nil! !
!GUID class categoriesFor: #alignment!constants!private! !
!GUID class categoriesFor: #atAddress:!instance creation!public! !
!GUID class categoriesFor: #basicByteSize!public! !
!GUID class categoriesFor: #byteSize!constants!public! !
!GUID class categoriesFor: #clear:!public!realizing/unrealizing! !
!GUID class categoriesFor: #defineFields!public!template definition! !
!GUID class categoriesFor: #elementSize!accessing!private! !
!GUID class categoriesFor: #fromAddress:!instance creation!public! !
!GUID class categoriesFor: #fromBytes:!instance creation!public! !
!GUID class categoriesFor: #fromIdlString:!instance creation!public! !
!GUID class categoriesFor: #fromString:!instance creation!public! !
!GUID class categoriesFor: #init:!initializing!public! !
!GUID class categoriesFor: #initialize!development!initializing!private! !
!GUID class categoriesFor: #new!instance creation!public! !
!GUID class categoriesFor: #newBuffer!instance creation!public! !
!GUID class categoriesFor: #newNull!instance creation!public! !
!GUID class categoriesFor: #newUnique!instance creation!public! !
!GUID class categoriesFor: #null!constants!public! !
!GUID class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!GUID class categoriesFor: #uninitialize!class hierarchy-removing!private! !

GUID class methodProtocol: #'externalStructure class' attributes: #(#readOnly) selectors: #(#alignment #byteSize #clear: #elementSize #fromAddress: #fromBytes: #init: #newBuffer)!


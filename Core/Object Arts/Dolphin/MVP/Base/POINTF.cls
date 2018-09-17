﻿"Filed out from Dolphin Smalltalk 7"!

ExternalPoint subclass: #POINTF
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
POINTF guid: (GUID fromString: '{c6f719de-eec5-45f6-bd44-71200f76bd34}')!
POINTF comment: '`POINTF` is an `ExternalStructure` class to wrap the struct of the same name.

`POINTF` is a cartesian coordinate with single precision floating point x and y values.'!
!POINTF categoriesForClass!External-Data-Structured! !
!POINTF methodsFor!

x
	"Answer the receiver's x field as a Smalltalk object."

	^(bytes floatAtOffset: 0)!

x: anObject
	"Set the receiver's x field to the value of anObject."

	bytes floatAtOffset: 0 put: anObject!

y
	"Answer the receiver's y field as a Smalltalk object."

	^(bytes floatAtOffset: 4)!

y: anObject
	"Set the receiver's y field to the value of anObject."

	bytes floatAtOffset: 4 put: anObject! !
!POINTF categoriesFor: #x!**compiled accessors**!public! !
!POINTF categoriesFor: #x:!**compiled accessors**!public! !
!POINTF categoriesFor: #y!**compiled accessors**!public! !
!POINTF categoriesFor: #y:!**compiled accessors**!public! !

!POINTF class methodsFor!

defineFields
	"Define the fields of the POINTF structure.
		POINTF compileDefinition
	
		typedef 		struct tagPOINTF {
			single x;
			single y;
		} POINTF;

	"

	self
		defineField: #x type: FLOATField new;
		defineField: #y type: FLOATField new!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments.
	Implementation Note: For performance reasons avoid going through
	all the <ExternalStructure> framework methods."

	^self basicNew 
		bytes: ((ByteArray newFixed: 8)
				floatAtOffset: 0 put: x;
				floatAtOffset: 4 put: y;
				yourself)
! !
!POINTF class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!POINTF class categoriesFor: #x:y:!instance creation!public! !

﻿"Filed out from Dolphin Smalltalk 7"!

ExternalField subclass: #FillerField
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FillerField guid: (GUID fromString: '{87b4c4db-026e-11d3-9fd7-00a0cc3e4a32}')!
FillerField comment: 'FillerField is an <ExternalField> type for describing spacing or padding in <ExternalStructure>s. Note that it is not normally necessary to account for padding added for memory alignment reasons - the infrastructure for defining structures is able to calculate the correct field offsets taking account of various padding algorithms. Sometimes however custom padding may be required, or <FillerField>s can be used to describe fields where there is never any need to get or set the value (although in that case it is better to use the correct <ExternalField> type and mark the instance as a filler).'!
!FillerField categoriesForClass!External-Data-Types! !
!FillerField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	FillerFields pad to a specified number of bytes, so no further alignment
	is required."

	^1!

byteSize
	"Private - Answer the byte size of the filler data the receiver represents"

	^byteSize!

byteSize: anInteger
	"Private - Set the byte size of the filler data the receiver represents"

	byteSize := anInteger!

canGenerateAccessors
	^false!

initialize
	"Private - Initialize the receiver."
	
	super initialize.
	self beInaccessible!

readFrom: anExternalStructure
	"Private - Answer an object of the the type the receiver represents at the receiver's
	offset in the <ExternalStructure> argument."

	^self shouldNotImplement!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the appropriate offset and in the 
	appropriate format for the receiver"

	^self shouldNotImplement! !
!FillerField categoriesFor: #alignment!constants!public! !
!FillerField categoriesFor: #byteSize!accessing!private! !
!FillerField categoriesFor: #byteSize:!accessing!private! !
!FillerField categoriesFor: #canGenerateAccessors!private!testing! !
!FillerField categoriesFor: #initialize!initializing!private! !
!FillerField categoriesFor: #readFrom:!indirect accessing!private! !
!FillerField categoriesFor: #writeInto:value:!indirect accessing!private! !

!FillerField class methodsFor!

byteSize: anInteger
	"Answer a FillerField of the specified number of bytes"

	^(self new) byteSize: anInteger; yourself! !
!FillerField class categoriesFor: #byteSize:!instance creation!public! !


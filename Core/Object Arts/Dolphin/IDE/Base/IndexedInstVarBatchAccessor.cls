﻿"Filed out from Dolphin Smalltalk 7"!

BatchAspectAccessor subclass: #IndexedInstVarBatchAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IndexedInstVarBatchAccessor guid: (GUID fromString: '{234eecdb-d11a-49c1-9c57-68f684cc8b21}')!
IndexedInstVarBatchAccessor comment: 'Part of the InstVarInspector framework. IndexedInstVarBatchAccessors are used to give access to a group of <IndexedInstVarAccessors> for indexed slots of an object. Batching the accessors up in this way allows the InstVarInspector to only display a certain number of elements at a time. This can substantially improve performance when displaying large indexed objects.'!
!IndexedInstVarBatchAccessor categoriesForClass!MVP-Models! !
!IndexedInstVarBatchAccessor methodsFor!

aspectClass
	^InstVarAspect!

getBatchAccessors
	"Answer an <OrderedCollection> of the IndexedInstVarAccessors represented by the receiver"

	| accessors subj offset start end |
	subj := self subject.
	offset := subj class instSize.
	start := self startKey.
	end := start + self batchSize - 1 min: subj basicSize.
	accessors := OrderedCollection new: end - start + 1.
	start to: end
		do: 
			[:n | 
			| item |
			item := subj basicAt: n.
			accessors add: ((item newAspect: n + offset class: self aspectClass) accessorFor: self subject)].
	(self nextBatch: end+1) ifNotNil: [:nextBatch | accessors add: nextBatch].
	^accessors!

keys
	^1 to: self subject basicSize!

subjectIncludesKey: nextKey
	^nextKey <= self subject basicSize! !
!IndexedInstVarBatchAccessor categoriesFor: #aspectClass!public! !
!IndexedInstVarBatchAccessor categoriesFor: #getBatchAccessors!accessing!public! !
!IndexedInstVarBatchAccessor categoriesFor: #keys!accessing!public! !
!IndexedInstVarBatchAccessor categoriesFor: #subjectIncludesKey:!accessing!private! !

!IndexedInstVarBatchAccessor class methodsFor!

subject: anObject batchSize: sizeInteger
	"Answers an instance of the receiver that is an interface onto a range of
	keyed elements of the subject <Object>, anObject."

	^self 
		subject: anObject
		keys: (1 to: anObject basicSize)
		startingAt: 1
		batchSize: sizeInteger! !
!IndexedInstVarBatchAccessor class categoriesFor: #subject:batchSize:!instance creation!public! !


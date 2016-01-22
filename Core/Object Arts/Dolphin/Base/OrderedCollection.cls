"Filed out from Dolphin Smalltalk X6"!

SequencedGrowableCollection variableSubclass: #OrderedCollection
	instanceVariableNames: 'firstIndex lastIndex '
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OrderedCollection guid: (GUID fromString: '{87B4C523-026E-11D3-9FD7-00A0CC3E4A32}')!
OrderedCollection comment: 'OrderedCollections store an ordered, contiguous sequence of elements. They are much like resizable arrays'!
!OrderedCollection categoriesForClass!Collections-Sequenceable! !
!OrderedCollection methodsFor!

add: newElement afterIndex: index
	"Add newElement to the receiver immediately after the element currently at the
	specified <integer> index. index must be between 0 and the receiver's current 
	size (if not raise an exception). Answer newElement."

	| basicIndex |
	basicIndex := index + firstIndex.
	(basicIndex > (lastIndex + 1) or: [basicIndex < firstIndex]) ifTrue: [^self errorSubscriptBounds: index].
	lastIndex == self basicSize ifTrue: [ 
		self makeRoomAtEndFor: 1.
		basicIndex := index + firstIndex].
	"Slide the elements down the collection toward the new end to make room for the insertion"
	lastIndex to: basicIndex by: -1 do: [:i | self basicAt: i + 1 put: (self basicAt: i)].
	lastIndex := lastIndex + 1.
	^self basicAt: basicIndex put: newElement!

addAllFirst: aCollection 
	"Prepend all elements of the <collection> argument to the receiver,
	in the order that they appear in the argument, as determined by
	its implementation of #do:. Answer the new elements."

	"Implementation Note: Override for better performance by
	opening up a space at the front in one operation."

	| extra |
	extra := aCollection size.
	firstIndex <= extra ifTrue: [self makeRoomAtFirstFor: extra - firstIndex + 1].
	firstIndex := firstIndex - extra.
	aCollection inject: firstIndex
		into: 
			[:i :e | 
			self basicAt: i put: e.
			i + 1].
	^aCollection!

addAllLast: newElements
	"Append the elements of the <sequencedCollection>, newElements, to the receiver,
	in the order that they appear in newElements (as defined by its implementation
	of #do:). Answer newElements."

	| size |
	size := newElements size.
	self basicSize - lastIndex < size ifTrue: [self makeRoomAtEndFor: size].
	newElements 
		do: [:each | self basicAt: (lastIndex := lastIndex + 1) put: each].
	^newElements!

addAnsweringIndex: newObject
	"Append newObject as the last element of the receiver. 
	Answer the index at which the object was added."

	self addLast: newObject.
	^lastIndex - firstIndex + 1!

addFirst: newElement
	"Insert newElement as the first element of the receiver.
	Implementation Note: Override for performance."

	firstIndex == 1 ifTrue: [self makeRoomAtFirstFor: self growSize].
	firstIndex := firstIndex - 1.
	^self basicAt: firstIndex put: newElement
!

addLast: newObject
	"Append newObject as the last element of the receiver. Answer newObject.
	Implementation Note: Override for performance."

	lastIndex == self basicSize ifTrue: [self makeRoomAtEndFor: 1].
	lastIndex := lastIndex + 1.
	^self basicAt: lastIndex put: newObject!

asOrderedCollection
	"Answer an OrderedCollection containing the same elements as the receiver.
	No conversion is required in this case."

	^self!

at: index
	"Answer the element at the specified <integer> index of the receiver."

	| basicIndex |
	^(index < 1 or: [ (basicIndex := index + firstIndex - 1) > lastIndex ])
		ifTrue: [self errorSubscriptBounds: index]
		ifFalse: [self basicAt: basicIndex]!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	| basicIndex |
	^(index < 1 or: [ (basicIndex := index + firstIndex - 1) > lastIndex ])
		ifTrue: [exceptionBlock value]
		ifFalse: [self basicAt: basicIndex]!

at: index put: storee
	"Replace the element at the <integer> index of the receiver with
	the <Object> argument, storee.
	Report an error if there is no such element."

	| basicIndex |
	^(index < 1 or: [(basicIndex := index + firstIndex - 1) > lastIndex])
		ifTrue: [self errorSubscriptBounds: index]
		ifFalse: [self basicAt: basicIndex put: storee]!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement added in the correct position
	as defined by the receiver's sort order."

	^self copy
		add: newElement;
		yourself!

copyWithout: oldElement
	"Answer a <sequencedReadableCollection> which is a copy of the receiver, but in
	which all occurrences of the <Object> oldElement have been removed."

	| answer |
	answer := self copyEmpty.
	self do: [:element | element = oldElement ifFalse: [answer add: element]].
	^answer!

do: operation 
	"Evaluate monadic value argument, operation, for each of the element of the 
	receiver. Answers the receiver."

	"Implementation Note: Override to avoid error checking in #at: for better performance."

	firstIndex to: lastIndex do: [:i | operation value: (self basicAt: i)]!

firstIndex: first lastIndex: last
	"Private - Initialize the receiver's first and last indices."

	firstIndex := first.
	lastIndex := last
!

includes: target
	"Answer whether the argument, target, is one of the elements of the receiver.
	Implementation Note: Override superclass to provide a more efficient implementation."

	firstIndex to: lastIndex do: [:i | (self basicAt: i) = target ifTrue: [^true]].
	^false!

initialize
	"Initialize the receiver after creation"

	firstIndex := 1.
	lastIndex := 0
!

insert: newElement before: anInteger 
	"Private - Insert the argument, newElement, into the receiver at the basic index
	specified by the argument, anInteger, shuffling any subsequent elements down.
	index must be between 0 and the receiver's current basic size (if not an exception
	is raised), however no check is made to ensure that it lies within the current
	first and last indices. Answer the index at which the element was actually
	inserted."

	| basicIndex |
	basicIndex := lastIndex == self basicSize 
				ifTrue: 
					[| offset |
					offset := anInteger - firstIndex.
					self makeRoomAtEndFor: 1.
					firstIndex + offset]
				ifFalse: [anInteger].

	"Slide the elements down the collection toward the new end to make room for the insertion"
	lastIndex to: basicIndex
		by: -1
		do: [:i | self basicAt: i + 1 put: (self basicAt: i)].
	lastIndex := lastIndex + 1.
	self basicAt: basicIndex put: newElement.
	^basicIndex - firstIndex + 1!

isEmpty
	"Answer whether the receiver contains no elements. 
	Implementation Note: Override superclass to provide a more efficient implementation."

	^firstIndex > lastIndex!

makeRoomAtEndFor: anInteger
	"Private - Make room at the end of the receiver to accomodate at least anInteger
	more elements. If there is insufficient free space in the receiver, then it is expanded 
	to accomodate	more elements."

	| shift capacity |
	capacity := self basicSize.
	(capacity - self size) < anInteger ifTrue: [
		"Too full, increase the receivers capacity. We don't bother shifting" 
		^self resize: capacity + (anInteger roundUpTo: self growSize)].
	shift := 1 - firstIndex.	"N.B. shift < 0"

	"Move tail of collection towards head"
	firstIndex to: lastIndex do: [:i | self basicAt: i + shift put: (self basicAt: i)].
	"Nil out old slots"
	lastIndex + shift + 1 to: lastIndex do: [:i | self basicAt: i put: nil].
	firstIndex := 1.
	lastIndex := lastIndex + shift!

makeRoomAtFirstFor: anInteger
	"Private - Make room at the start of the receiver to accomodate anInteger elements."

	| newOrderedCollection |
	newOrderedCollection := self class new: self basicSize + anInteger.
	firstIndex to: lastIndex do: [:i | newOrderedCollection basicAt: anInteger + i put: (self basicAt: i)].
	newOrderedCollection 
		firstIndex: anInteger + firstIndex
		lastIndex: anInteger + lastIndex.
	^self become: newOrderedCollection!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Override the inherited implementation to make use of the primitive as the receiver's elements
	are contiguous between the first and last indices."

	| index offset |
	offset := firstIndex - 1.
	index := self basicIdentityIndexOf: anElement from: start+offset to: stop+offset.
	^index == 0
		ifTrue: [0]
		ifFalse: [index - offset]!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the superclass to provide a more efficient
	inlined implementation (important for serial searches)."

	start to: stop do: [:i | (self basicAt: i+firstIndex-1) = anElement ifTrue: [^i]].
	^0!

removeAll
	"Empty the receiver of all contents"

	#todo "Implement more efficient mechanism (need a basic block write operation)".
	firstIndex to: lastIndex do: [:i | self basicAt: i put: nil].
	firstIndex := 1.
	lastIndex := 0!

removeAtIndex: index
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise an BoundsError if there is no element with that index."

	| element basicIndex |
	element := self at: index.
	(basicIndex := index + firstIndex - 1) == firstIndex
		ifTrue: [
			self basicAt: firstIndex put: nil.
			firstIndex := firstIndex + 1]
		ifFalse: [
			basicIndex + 1 to: lastIndex do: [:i | self basicAt: i - 1 put: (self basicAt: i)].
			self basicAt: lastIndex put: nil.
			lastIndex := lastIndex - 1].
	^element!

resize: anInteger
	"Private - Override back to the basic implementation as our elements are contiguously located.
	This changes the capacity of the receiver, but has no other effect."

	<primitive: 101>
	^super resize: anInteger!

reverseDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument against each of the element of the receiver in reverse
	order, from end to start. Answer the receiver."

	"Implementation Note: Override to avoid error checking in #at: for better performance."

	lastIndex to: firstIndex
		by: -1
		do: [:i | aMonadicValuable value: (self basicAt: i)]!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements.
	Answer a new Collection like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	| newCollection |
	newCollection := self copyEmpty.
	self do: [:each | (discriminator value: each) ifTrue: [newCollection add: each]].
	^newCollection!

setSize: anInteger
	| newLast |
	newLast := firstIndex + anInteger - 1.
	"Nil out any slots after the new last index"
	newLast + 1 to: lastIndex do: [:each | self basicAt: each put: nil].
	"Resize if necessary"
	newLast > self basicSize ifTrue: [self makeRoomAtEndFor: newLast - lastIndex].
	"Making room may have shifted elements down so must recalc."
	lastIndex := firstIndex + anInteger - 1.!

size
	"Answer the number of elements in the receiver."

	^lastIndex - firstIndex + 1
!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"
	
	aSortAlgorithm 
		sort: self
		from: firstIndex
		to: lastIndex!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self as: (STBCollectionProxy forCollection: self)!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable 
	"Private - Evaluate the <dyadicValuable> argument for each element of the receiver
	between the specified <integer> indices, inclusive, with the element and its index as
	respectively the second and first arguments. No bounds checks are performed."

	startInteger to: stopInteger
		do: [:i | aDyadicValuable value: i value: (self basicAt: i + firstIndex - 1)]! !
!OrderedCollection categoriesFor: #add:afterIndex:!adding!public! !
!OrderedCollection categoriesFor: #addAllFirst:!adding!public! !
!OrderedCollection categoriesFor: #addAllLast:!adding!public! !
!OrderedCollection categoriesFor: #addAnsweringIndex:!adding!public! !
!OrderedCollection categoriesFor: #addFirst:!adding!public! !
!OrderedCollection categoriesFor: #addLast:!adding!public! !
!OrderedCollection categoriesFor: #asOrderedCollection!converting!public! !
!OrderedCollection categoriesFor: #at:!accessing!public! !
!OrderedCollection categoriesFor: #at:ifAbsent:!accessing!public! !
!OrderedCollection categoriesFor: #at:put:!accessing!public! !
!OrderedCollection categoriesFor: #copyWith:!copying!public! !
!OrderedCollection categoriesFor: #copyWithout:!copying!public! !
!OrderedCollection categoriesFor: #do:!enumerating!public! !
!OrderedCollection categoriesFor: #firstIndex:lastIndex:!accessing!private! !
!OrderedCollection categoriesFor: #includes:!public!searching! !
!OrderedCollection categoriesFor: #initialize!initializing!public! !
!OrderedCollection categoriesFor: #insert:before:!adding!private! !
!OrderedCollection categoriesFor: #isEmpty!public!testing! !
!OrderedCollection categoriesFor: #makeRoomAtEndFor:!adding!private! !
!OrderedCollection categoriesFor: #makeRoomAtFirstFor:!adding!private! !
!OrderedCollection categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!OrderedCollection categoriesFor: #nextIndexOf:from:to:!public!searching! !
!OrderedCollection categoriesFor: #removeAll!public!removing! !
!OrderedCollection categoriesFor: #removeAtIndex:!public!removing! !
!OrderedCollection categoriesFor: #resize:!mutating!private! !
!OrderedCollection categoriesFor: #reverseDo:!enumerating!public! !
!OrderedCollection categoriesFor: #select:!enumerating!public! !
!OrderedCollection categoriesFor: #setSize:!accessing!public! !
!OrderedCollection categoriesFor: #size!accessing!public! !
!OrderedCollection categoriesFor: #sortUsing:!public!sorting! !
!OrderedCollection categoriesFor: #stbSaveOn:!binary filing!public! !
!OrderedCollection categoriesFor: #uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !

!OrderedCollection class methodsFor!

new
	"Answer a new instance of the receiver with sufficient capacity (initially)
	for the default number of elements."

	^self new: 5!

new: count
	"Answer a new instance of the receiver with sufficient initial capacity
	to hold the number of elements specified by the <integer> argument,
	count. The instance is initally empty (i.e.it reports 0 when sent #size)."

	^(self basicNew: count) initialize!

ofSize: count
	"Private - Answer a new instance of the receiver with the number of
	nil elements specified by the <integer> argument, count.

	This method differs from OrderedCollection>>new:, as that
	method answers an <OrderedCollection> with the capacity for
	anInteger elements, but which is initially empty (i.e. it
	reports a size of 0)."

	^(self basicNew: count)
		firstIndex: 1
		lastIndex: count! !
!OrderedCollection class categoriesFor: #new!instance creation!public! !
!OrderedCollection class categoriesFor: #new:!instance creation!public! !
!OrderedCollection class categoriesFor: #ofSize:!instance creation!private! !

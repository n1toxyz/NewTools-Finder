"
I represent a selector as a ̀FinderResult̀.
"
Class {
	#name : #StFinderSelectorResult,
	#superclass : #StFinderResult,
	#category : #'NewTools-Finder-Result'
}

{ #category : #action }
StFinderSelectorResult >> browseAction [

	self hasBrowseAction ifFalse: [ ^ self ].

	Smalltalk tools browser openOnClass: self parent content selector: self content
]

{ #category : #testing }
StFinderSelectorResult >> hasBrowseAction [

	^ self hasClassParent
]

{ #category : #testing }
StFinderSelectorResult >> hasClassParent [

	^ self parent notNil and: [ self parent isClassResult ]
]

{ #category : #testing }
StFinderSelectorResult >> hasHierarchyAction [

	^ self hasClassParent
]

{ #category : #testing }
StFinderSelectorResult >> hasImplementersAction [

	^ true
]

{ #category : #testing }
StFinderSelectorResult >> hasInheritanceAction [

	^ self hasClassParent
]

{ #category : #testing }
StFinderSelectorResult >> hasSendersAction [

	^ true
]

{ #category : #testing }
StFinderSelectorResult >> hasVersionsAction [

	^ self parent notNil and: [ self parent isClassResult ]
]

{ #category : #action }
StFinderSelectorResult >> hierarchyAction [

	self hasHierarchyAction ifFalse: [ ^ self ].

	SystemNavigation new
		browseHierarchy: self parent content
		selector: self content
]

{ #category : #action }
StFinderSelectorResult >> implementersAction [

	SystemNavigation new browseAllImplementorsOf: content
]

{ #category : #action }
StFinderSelectorResult >> inheritanceAction [

	self hasInheritanceAction ifFalse: [ ^ self ].

	SystemNavigation new
		methodHierarchyBrowserForClass: self parent content
		selector: self content
]

{ #category : #testing }
StFinderSelectorResult >> isSelectorResult [

	^ true
]

{ #category : #action }
StFinderSelectorResult >> sendersAction [

	SystemNavigation new
		browseSendersOf: content
		name: 'Senders of ' , content asString
		autoSelect: content asString
]

{ #category : #action }
StFinderSelectorResult >> versionsAction [

	Smalltalk tools versionBrowser
		browseVersionsForClass: self parent content
		selector: self content
]

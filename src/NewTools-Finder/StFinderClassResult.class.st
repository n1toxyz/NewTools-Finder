"
I represent a class as a ̀FinderResult̀.
"
Class {
	#name : #StFinderClassResult,
	#superclass : #StFinderResult,
	#category : #'NewTools-Finder-Result'
}

{ #category : #action }
StFinderClassResult >> browseAction [

	content browse
]

{ #category : #testing }
StFinderClassResult >> hasBrowseAction [

	^ true
]

{ #category : #testing }
StFinderClassResult >> hasHierarchyAction [

	^ true
]

{ #category : #testing }
StFinderClassResult >> hasInheritanceAction [

	^ self hasSelectorParent
]

{ #category : #testing }
StFinderClassResult >> hasSelectorParent [

	^ self parent notNil and: [ self parent isSelectorResult ]
]

{ #category : #testing }
StFinderClassResult >> hasVersionsAction [

	^ self hasSelectorParent
]

{ #category : #action }
StFinderClassResult >> hierarchyAction [

	self hasSelectorParent ifTrue: [
		SystemNavigation new
			browseHierarchy: content
			selector: self parent content.
		^ self ].

	SystemNavigation new browseHierarchy: content
]

{ #category : #action }
StFinderClassResult >> inheritanceAction [

	self hasInheritanceAction ifFalse: [ ^ self ].

	SystemNavigation new
		methodHierarchyBrowserForClass: self content
		selector: self parent content
]

{ #category : #testing }
StFinderClassResult >> isClassResult [

	^ true
]

{ #category : #action }
StFinderClassResult >> versionsAction [

	self hasVersionsAction ifFalse: [ ^ self ].

	Smalltalk tools versionBrowser
		browseVersionsForClass: self content
		selector: self parent content
]
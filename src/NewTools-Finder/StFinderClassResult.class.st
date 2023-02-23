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
	"Opens the system browser on its content. If it has a `StFinderSelectorResult` as a parent,
	then opens the system browser on its content with the selector from its parent focused."

	self hasSelectorParent
		ifTrue: [
			self browser
				openOnClass: self content
				selector: self parent content ]
		ifFalse: [ content browse ]
]

{ #category : #displaying }
StFinderClassResult >> displayIcon [

	self content isTrait ifTrue: [ ^ self iconNamed: #trait ].
	(self content inheritsFrom: Exception) ifTrue: [ ^ self iconNamed: #exception ].
	self content isAbstract ifTrue: [ ^ self iconNamed: #classAbstract ].
	^ self iconNamed: #class
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
		self navigation
			browseHierarchy: content
			selector: self parent content.
		^ self ].

	self navigation browseHierarchy: content
]

{ #category : #action }
StFinderClassResult >> inheritanceAction [

	self hasInheritanceAction ifFalse: [ ^ self ].
	self systemNavigation
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

	self versionBrowser
		browseVersionsForClass: self content
		selector: self parent content
]

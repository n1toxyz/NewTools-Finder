"
I represent a result in the ̀Finder̀ tool.

I am a composite object and subclasses of me reperesent different kinds of results.

I have a content, which is the actual result, and define a specified set of actions
for it.
"
Class {
	#name : #StFinderResult,
	#superclass : #Object,
	#instVars : [
		'content',
		'parent',
		'children'
	],
	#category : #'NewTools-Finder-Result'
}

{ #category : #adding }
StFinderResult >> addChild: aFinderResult [

	aFinderResult parent: self.
	children add: aFinderResult
]

{ #category : #action }
StFinderResult >> browseAction [
	"Default does nothing. Subclasses may implement their own action for browsing."
]

{ #category : #accessing }
StFinderResult >> children [

	^ children
]

{ #category : #accessing }
StFinderResult >> children: anObject [

	children := anObject
]

{ #category : #accessing }
StFinderResult >> content [

	^ content
]

{ #category : #accessing }
StFinderResult >> content: anObject [

	content := anObject
]

{ #category : #displaying }
StFinderResult >> displayString [

	^ content asString
]

{ #category : #testing }
StFinderResult >> hasBrowseAction [

	^ false
]

{ #category : #testing }
StFinderResult >> hasHierarchyAction [

	^ false
]

{ #category : #testing }
StFinderResult >> hasImplementersAction [

	^ false
]

{ #category : #testing }
StFinderResult >> hasInheritanceAction [

	^ false
]

{ #category : #testing }
StFinderResult >> hasSendersAction [

	^ false
]

{ #category : #testing }
StFinderResult >> hasVersionsAction [

	^ false
]

{ #category : #action }
StFinderResult >> hierarchyAction [
	"Default does nothing. Subclasses may implement their own action for hieracchy."
]

{ #category : #action }
StFinderResult >> implementersAction [
	"Default does nothing. Subclasses may implement their own action for implementers."
]

{ #category : #action }
StFinderResult >> inheritanceAction [
	"Default does nothing. Subclasses may implement their own action for inheritance."
]

{ #category : #initialization }
StFinderResult >> initialize [

	children := OrderedCollection new
]

{ #category : #testing }
StFinderResult >> isClassResult [

	^ false
]

{ #category : #testing }
StFinderResult >> isSelectorResult [

	^ false
]

{ #category : #accessing }
StFinderResult >> parent [

	^ parent
]

{ #category : #accessing }
StFinderResult >> parent: anObject [

	parent := anObject
]

{ #category : #action }
StFinderResult >> sendersAction [
	"Default does nothing. Subclasses may implement their own action for senders."
]

{ #category : #action }
StFinderResult >> versionsAction [
	"Default does nothing. Subclasses may implement their own action for versions."
]

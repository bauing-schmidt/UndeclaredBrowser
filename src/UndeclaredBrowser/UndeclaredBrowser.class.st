"
A very simple tool to detect source of Undeclared variables

```smalltalk
UndeclaredBrowser new open
```
"
Class {
	#name : #UndeclaredBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'undeclared',
		'undeclaredList',
		'methodsList',
		'codePresenter'
	],
	#category : #UndeclaredBrowser
}

{ #category : #'instance creation' }
UndeclaredBrowser class >> open [ 

	<script>
	self new open
]

{ #category : #'accessing - model' }
UndeclaredBrowser >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  add: (SpPanedLayout newLeftToRight
		positionOfSlider: 0.3;
				   add: undeclaredList;
				   add: methodsList;
				   yourself);
		  add: codePresenter;
		  yourself
]

{ #category : #'accessing - model' }
UndeclaredBrowser >> initialExtent [

	^ 900 @ 600
]

{ #category : #'accessing - model' }
UndeclaredBrowser >> initializePresenters [

	"self new openWithSpec"

	| undeclaredAssocs index |
	undeclaredAssocs := Undeclared associations.
	undeclared := Array new: undeclaredAssocs size.

	"not ideal processing because of the progress bar"
	index := 1.
	undeclaredAssocs
		do: [ :assoc | 
			undeclared at: index put: assoc key -> (assoc pointersTo
					 select: [ :each | each isKindOf: CompiledCode ]
					 thenCollect: [ :each | each method ]).
			index := index + 1 ]
		displayingProgress: 'Collectiong references'.

	undeclaredList := self newTable.
	methodsList := self newTable.
	codePresenter := self newCode.

	undeclaredList addColumn:
		(SpStringTableColumn title: 'Symbol' evaluated: #key).
	undeclaredList items: undeclared.

	methodsList addColumn:
		(SpStringTableColumn title: 'Method' evaluated: [ :cm | cm name ]).
	methodsList addColumn: (SpStringTableColumn
			 title: 'Package'
			 evaluated: [ :cm | cm package name ]).
	methodsList addColumn: (SpLinkTableColumn
			 title: 'Browse'
			 evaluated: [ :cm | 'browse' ]
			 action: [ :cm | cm browse ]).

	undeclaredList
		transmitTo: methodsList
		transform: [ :assoc | assoc value ].

	methodsList
		transmitTo: codePresenter
		transform: [ :method | method ifNil: [ '' ] ifNotNil: #sourceCode ]
		postTransmission: [ :destination :origin :transmited | 
			transmited ifNotNil: [ destination beForMethod: transmited ] ]
]

{ #category : #'accessing - model' }
UndeclaredBrowser >> title [

	^ 'Undeclared browser'
]

Class {
	#name : #BaselineOfUndeclaredBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfUndeclaredBrowser
}

{ #category : #baselines }
BaselineOfUndeclaredBrowser >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec package: 'UndeclaredBrowser' ]
]

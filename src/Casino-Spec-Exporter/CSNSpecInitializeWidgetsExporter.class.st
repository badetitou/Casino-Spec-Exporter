"
Only use to create the initializeWidgets method
"
Class {
	#name : #CSNSpecInitializeWidgetsExporter,
	#superclass : #BLModelExporter,
	#instVars : [
		'mainExporter'
	],
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> exportInitializeWidgetOfBusinessPage: aBLBuisinessPage inClass: aClass [
	aClass compile: 'initializeWidgets
	', ((self recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage) flatCollect: [:widget | (self visit: widget), '.', String crlf, String tab])
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> exportInitializeWidgetOfPage: aBLPage inClass: aClass [
	aClass compile: 'initializeWidgets
	', ((self recursiveLocalWidgetOfPage: aBLPage) flatCollect: [:widget | (self visit: widget), '.', String crlf, String tab])
]

{ #category : #accessing }
CSNSpecInitializeWidgetsExporter >> mainExporter [
	^ mainExporter
]

{ #category : #accessing }
CSNSpecInitializeWidgetsExporter >> mainExporter: anObject [
	mainExporter := anObject
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage [
	^ (aBLBuisinessPage widgets collect: #localWidgets) flattened
		reject: [ :widget | widget isKindOf: BLUIPanel ]
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: BLUIPanel ]
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> visitBLPageMetier: aBLBusinessPage [
	^ aBLBusinessPage name uncapitalized , ' := (self instantiate: '
		,self mainExporter prefix, aBLBusinessPage name capitalized , ')'
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputButton: aBLUIInputButton [
	^ aBLUIInputButton name, ' := self newButton'.
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputCheckbox: aBLUIInputCheckbox [
	^ aBLUIInputCheckbox name , ' := self newCheckBox'
]

{ #category : #'as yet unclassified' }
CSNSpecInitializeWidgetsExporter >> visitBLWidget: aBLWidget [
	^ ' "not handle --> " ', (aBLWidget name).
]

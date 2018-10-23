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

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLAttribute: aBLAttribute [
	^ ''
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLPageMetier: aBLBusinessPage [
	^ aBLBusinessPage name uncapitalized , ' := (self instantiate: '
		,self mainExporter prefix, aBLBusinessPage name capitalized , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIDisabled: aBLUIDisabled [
	^ 'disable;'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputButton: aBLUIInputButton [
	^ aBLUIInputButton name , ' := self newButton '
		,
			(aBLUIInputButton attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputCheckbox: aBLUIInputCheckbox [
	^ aBLUIInputCheckbox name , ' := self newCheckBox '
		,
			(aBLUIInputCheckbox attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputPassword: aBLUIInputPassword [
	^ aBLUIInputPassword name
		,
			' := self newTextInput 
		encrypted: true;'
		,
			(aBLUIInputPassword attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputText: aBLUIInputText [
	^ aBLUIInputText name , ' := self newTextInput '
		,
			(aBLUIInputText attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUILabel: aBLUILabel [
	^ 'label: ' , aBLUILabel text , ';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIParagraph: aBLUIParagraph [
	^ aBLUIParagraph name , ' := self newLabel '
		,
			(aBLUIParagraph attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIPlaceholder: aBLUIPlaceholder [
	^ 'ghostText: ' , aBLUIPlaceholder text , ';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUITitle: aBLUITitle [
	^ 'help: ' , aBLUITitle text , ';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIValue: aBLUIValue [
	^ 'text: ' , aBLUIValue text , ';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLWidget: aBLWidget [
	^ ' "not handle --> " ', (aBLWidget name).
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitMooseModel: aMooseModel [
	self shouldNotImplement 
]

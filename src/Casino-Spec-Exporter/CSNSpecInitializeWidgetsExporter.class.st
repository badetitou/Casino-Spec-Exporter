"
Only use to create the initializeWidgets method
"
Class {
	#name : #CSNSpecInitializeWidgetsExporter,
	#superclass : #CSNModelExporter,
	#instVars : [
		'mainExporter'
	],
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #accessing }
CSNSpecInitializeWidgetsExporter >> computeWidgetName: aWidget [
	^ self mainExporter computeAcceptedNameForVariableFrom: aWidget name
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> exportInitializeWidgetOfBusinessPage: aBLBuisinessPage inClass: aClass [
	aClass compile: 'initializeWidgets
	', ((self recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage) flatCollect: [:widget | (self visit: widget), '.', String crlf, String tab])
]

{ #category : #visiting }
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

{ #category : #'private - utilities' }
CSNSpecInitializeWidgetsExporter >> protectString: aString [
	^ self mainExporter protectString: aString
]

{ #category : #accessing }
CSNSpecInitializeWidgetsExporter >> recursiveLocalWidgetOfBLBusinessPage: aBLBusinessPage [
	^ (aBLBusinessPage widgets collect: #localWidgets) flattened
		reject: [ :widget | widget isKindOf: CSNUIPanel ]
]

{ #category : #accessing }
CSNSpecInitializeWidgetsExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: CSNUIPanel ]
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNAttribute: aCSNAttribute [
	^ ''
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNBusinessPage: aCSNBusinessPage [
	^ aCSNBusinessPage name uncapitalized , ' := (self instantiate: '
		, self mainExporter prefix , (aCSNBusinessPage name capitalized, aCSNBusinessPage mooseID asString) , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNContainer: aCSNContainer [
	^ (self computeWidgetName: aCSNContainer)
		, ' := (self instantiate: NullPresenter)'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNPage: aCSNPage [
	^ aCSNPage name uncapitalized , ' := (self instantiate: ' , self mainExporter prefix , aCSNPage name capitalized , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIButton: aCSNUIButton [
	^ (self computeWidgetName: aCSNUIButton) , ' := self newButton '
		,
			(aCSNUIButton attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIDisabled: aCSNUIDisabled [
	^ 'disable;'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIInput: aCSNUIInput [
	^ (self computeWidgetName: aCSNUIInput) , ' := self newTextInput '
		, (aCSNUIInput attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIInputCheckbox: aCSNUIInputCheckbox [
	^ (self computeWidgetName: aCSNUIInputCheckbox) , ' := self newCheckBox '
		, (aCSNUIInputCheckbox attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIInputPassword: aCSNUIInputPassword [
	^ (self computeWidgetName: aCSNUIInputPassword)
		,
			' := self newTextInput 
		encrypted: true;' , (aCSNUIInputPassword attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIInputText: aCSNUIInputText [
	^ (self computeWidgetName: aCSNUIInputText) , ' := self newTextInput '
		, (aCSNUIInputText attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUILabel: aCSNUILabel [
	^ 'label: ''' , (self protectString: aCSNUILabel attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUILink: aCSNUILink [
	^ (self computeWidgetName: aCSNUILink) , ' := self newLabel '
		, (aCSNUILink attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIList: aCSNUIList [
	^ (self computeWidgetName: aCSNUIList) , ' := self newList '
		, (aCSNUIList attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIParagraph: aCSNUIParagraph [
	^ (self computeWidgetName: aCSNUIParagraph) , ' := self newLabel '
		, (aCSNUIParagraph attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIPlaceholder: aCSNUIPlaceholder [
	^ 'ghostText: ''' , (self protectString: aCSNUIPlaceholder attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUISelect: aCSNUISelect [
	^ (self computeWidgetName: aCSNUISelect) , ' := self newDropList '
		, (aCSNUISelect attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUITextarea: aCSNUITextarea [
	^  (self computeWidgetName: aCSNUITextarea) , ' := self newText '
		, (aCSNUITextarea attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUITitle: aCSNUITitle [
	^ 'help: ''' , (self protectString: aCSNUITitle attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUITree: aCSNUITree [
	^ (self computeWidgetName: aCSNUITree) , ' := self newTree '
		, (aCSNUITree attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNUIValue: aCSNUIValue [
	^ 'text: ''' , (self protectString: aCSNUIValue attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitCSNWidget: aCSNWidget [
	^ ' "not handle -->  ' , (self computeWidgetName: aCSNWidget) , '"'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitMooseModel: aMooseModel [
	self shouldNotImplement 
]

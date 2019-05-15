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
CSNSpecInitializeWidgetsExporter >> visitAttribute: aBLAttribute [
	^ ''
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitMooseModel: aMooseModel [
	self shouldNotImplement 
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitPage: aBLPage [
	^ aBLPage name uncapitalized , ' := (self instantiate: '
		,self mainExporter prefix, aBLPage name capitalized , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitPageMetier: aBLBusinessPage [
	^ aBLBusinessPage name uncapitalized , ' := (self instantiate: '
		, self mainExporter prefix , (aBLBusinessPage name capitalized, aBLBusinessPage mooseID asString) , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIButton: aBLUIButton [
	^ (self computeWidgetName: aBLUIButton) , ' := self newButton '
		,
			(aBLUIButton attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIContainer: aBLUIContainer [
	^ (self computeWidgetName: aBLUIContainer)
		, ' := (self instantiate: NullPresenter)'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIDisabled: aBLUIDisabled [
	^ 'disable;'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIInput: aBLUIInput [
	^ (self computeWidgetName: aBLUIInput) , ' := self newTextInput '
		, (aBLUIInput attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIInputCheckbox: aBLUIInputCheckbox [
	^ (self computeWidgetName: aBLUIInputCheckbox) , ' := self newCheckBox '
		, (aBLUIInputCheckbox attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIInputPassword: aBLUIInputPassword [
	^ (self computeWidgetName: aBLUIInputPassword)
		,
			' := self newTextInput 
		encrypted: true;' , (aBLUIInputPassword attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIInputText: aBLUIInputText [
	^ (self computeWidgetName: aBLUIInputText) , ' := self newTextInput '
		, (aBLUIInputText attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUILabel: aBLUILabel [
	^ 'label: ''' , (self protectString: aBLUILabel attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUILink: aBLUILink [
	^ (self computeWidgetName: aBLUILink) , ' := self newLabel '
		, (aBLUILink attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIList: aBLUIList [
	^ (self computeWidgetName: aBLUIList) , ' := self newList '
		, (aBLUIList attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIParagraph: aBLUIParagraph [
	^ (self computeWidgetName: aBLUIParagraph) , ' := self newLabel '
		, (aBLUIParagraph attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIPlaceholder: aBLUIPlaceholder [
	^ 'ghostText: ''' , (self protectString: aBLUIPlaceholder attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUISelect: aBLUISelect [
	^ (self computeWidgetName: aBLUISelect) , ' := self newDropList '
		, (aBLUISelect attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUITextarea: aBLUITextarea [
	^  (self computeWidgetName: aBLUITextarea) , ' := self newText '
		, (aBLUITextarea attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUITitle: aBLUITitle [
	^ 'help: ''' , (self protectString: aBLUITitle attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUITree: aBLUITree [
	^  (self computeWidgetName: aBLUITree) , ' := self newTree '
		, (aBLUITree attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitUIValue: aBLUIValue [
	^ 'text: ''' , (self protectString: aBLUIValue attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitWidget: aBLWidget [
	^ ' "not handle -->  ' , (self computeWidgetName: aBLWidget) , '"'
]

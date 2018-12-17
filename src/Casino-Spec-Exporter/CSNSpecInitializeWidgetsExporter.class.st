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
		reject: [ :widget | widget isKindOf: BLUIPanel ]
]

{ #category : #accessing }
CSNSpecInitializeWidgetsExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: BLUIPanel ]
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLAttribute: aBLAttribute [
	^ ''
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLPage: aBLPage [
	^ aBLPage name uncapitalized , ' := (self instantiate: '
		,self mainExporter prefix, aBLPage name capitalized , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLPageMetier: aBLBusinessPage [
	^ aBLBusinessPage name uncapitalized , ' := (self instantiate: '
		, self mainExporter prefix , (aBLBusinessPage name capitalized, aBLBusinessPage mooseID asString) , ')'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIButton: aBLUIButton [
	^ (self computeWidgetName: aBLUIButton) , ' := self newButton '
		,
			(aBLUIButton attributes
				flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIContainer: aBLUIContainer [
	^ (self computeWidgetName: aBLUIContainer)
		, ' := (self instantiate: NullPresenter)'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIDisabled: aBLUIDisabled [
	^ 'disable;'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInput: aBLUIInput [
	^ (self computeWidgetName: aBLUIInput) , ' := self newTextInput '
		, (aBLUIInput attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputCheckbox: aBLUIInputCheckbox [
	^ (self computeWidgetName: aBLUIInputCheckbox) , ' := self newCheckBox '
		, (aBLUIInputCheckbox attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputPassword: aBLUIInputPassword [
	^ (self computeWidgetName: aBLUIInputPassword)
		,
			' := self newTextInput 
		encrypted: true;' , (aBLUIInputPassword attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ])
		, 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIInputText: aBLUIInputText [
	^ (self computeWidgetName: aBLUIInputText) , ' := self newTextInput '
		, (aBLUIInputText attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUILabel: aBLUILabel [
	^ 'label: ''' , (self protectString: aBLUILabel attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUILink: aBLUILink [
	^ (self computeWidgetName: aBLUILink) , ' := self newLabel '
		, (aBLUILink attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIList: aBLUIList [
	^ (self computeWidgetName: aBLUIList) , ' := self newList '
		, (aBLUIList attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIParagraph: aBLUIParagraph [
	^ (self computeWidgetName: aBLUIParagraph) , ' := self newLabel '
		, (aBLUIParagraph attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIPlaceholder: aBLUIPlaceholder [
	^ 'ghostText: ''' , (self protectString: aBLUIPlaceholder attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUISelect: aBLUISelect [
	^ (self computeWidgetName: aBLUISelect) , ' := self newDropList '
		, (aBLUISelect attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUITextarea: aBLUITextarea [
	^  (self computeWidgetName: aBLUITextarea) , ' := self newText '
		, (aBLUITextarea attributes flatCollect: [ :attribute | (self visit: attribute) , String crlf , String tab , String tab ]) , 'yourself'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUITitle: aBLUITitle [
	^ 'help: ''' , (self protectString: aBLUITitle attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLUIValue: aBLUIValue [
	^ 'text: ''' , (self protectString: aBLUIValue attributeValue) , ''';'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitBLWidget: aBLWidget [
	^ ' "not handle -->  ' , (self computeWidgetName: aBLWidget) , '"'
]

{ #category : #visiting }
CSNSpecInitializeWidgetsExporter >> visitMooseModel: aMooseModel [
	self shouldNotImplement 
]

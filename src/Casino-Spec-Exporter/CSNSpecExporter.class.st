Class {
	#name : #CSNSpecExporter,
	#superclass : #CSNModelExporter,
	#instVars : [
		'initializeWidgetsExporter'
	],
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #'private - utilities' }
CSNSpecExporter >> computeAcceptedNameForClassFrom: aString [
	^ (aString capitalized copyReplaceAll: ' ' with: '') copyReplaceAll: '-' with: '_' 
]

{ #category : #'private - utilities' }
CSNSpecExporter >> computeAcceptedNameForVariableFrom: aString [
	^ (aString uncapitalized copyReplaceAll: '(' with: '') copyReplaceAll: ')' with: ''
]

{ #category : #visiting }
CSNSpecExporter >> createAccessorForVariable: each inClass: class [
	"generate the getter and the setter"

	"getter"

	class compile: '' , each , String crlf , String tab , '^ ' , each.
	"setter"
	class compile: '' , each, ': anObject' , String crlf , String tab , each, ' := anObject'.
]

{ #category : #visiting }
CSNSpecExporter >> exportedPackageName [
	^ 'Casino-Exported'
]

{ #category : #visiting }
CSNSpecExporter >> prefix [
	^ 'CSNExported'
]

{ #category : #visiting }
CSNSpecExporter >> prepareExport [
	initializeWidgetsExporter := CSNSpecInitializeWidgetsExporter new mainExporter: self; yourself
]

{ #category : #'private - utilities' }
CSNSpecExporter >> protectString: aString [
	^ aString copyReplaceAll: '''' with: ''''''
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfBLBusinessPage: aBLBuisinessPage [
	^ (self recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage) collect: [ :widget | self computeAcceptedNameForVariableFrom: widget name ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfPage: aBLPage [
	^ (self recursiveLocalWidgetOfPage: aBLPage) reject: #isNil thenCollect: [:widget | self computeAcceptedNameForVariableFrom: widget name ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetOfBLBusinessPage: aBLBusinessPage [
	^ (aBLBusinessPage widgets collect: #localWidgets) flattened
		reject: [ :widget | widget isKindOf: CSNUIPanel ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: CSNUIPanel ]
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNAttribute: aCSNAttribute [
	^ ''
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNBusinessPage: aCSNBusinessPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , (aCSNBusinessPage name capitalized , aCSNBusinessPage mooseID asString)
		instanceVariableNames: '' , ((self recursiveLocalWidgetNameOfBLBusinessPage: aCSNBusinessPage) flatCollect: [ :name | name uncapitalized , ' ' ])
		classVariableNames: ''
		package: self exportedPackageName , '-Components'.
	class class
		compile:
			'open
	<example>
	^ self new openWithSpec'.
	class class
		compile:
			'defaultSpec
	<spec: #default>
	^ SpecColumnLayout composed '
				,
					(aCSNBusinessPage widgets
						flatCollect: [ :widget | ('' , (self visit: widget) removeSuffix: ';') ifEmpty: [ '' ] ifNotEmpty: [ :result | result , ';' , String cr ] ])
				,
					'
				yourself'.
	class instVarNames do: [ :each | self createAccessorForVariable: each inClass: class ].
	class compile: 'title' , String cr , String tab , '^ ' , ('''' , (self protectString: (aCSNBusinessPage title ifNil: [ '' ])) , '''').
	initializeWidgetsExporter exportInitializeWidgetOfBusinessPage: aCSNBusinessPage inClass: class.
	^ self visitCSNWidget: aCSNBusinessPage
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNContainer: aCSNContainer [
	^ (aCSNContainer layout
		ifNotNil: [ self visit: aCSNContainer layout ]
		ifNil: [ self
				visitInsideAContainerWithLocalVariable: 'row' , (self computeAcceptedNameForVariableFrom: aCSNContainer mooseName , aCSNContainer mooseID asString)
				andContainedWidgets: aCSNContainer widgets	"aBLUIContainer widgets flatCollect: [ :widget | '' , (self visit: widget) , ';' ]" ])
		,
			(aCSNContainer attributes
				ifEmpty: [ '' ]
				ifNotEmpty: [ :attributes | 
					(attributes flatCollect: [ :attribute | self visit: attribute ])
						ifNotEmpty: [ :od | 
							od
								removeLast;
								yourself ] ])
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNLCell: aCSLCell [
 	^ aCSLCell widget ifNil: [ '' ] ifNotNil: [ self visit: aCSLCell widget ] 
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNLHorizontalLayout: aCSNLHorizontalLayout [
	| localVariableName |
	localVariableName := 'row'
		, (self computeAcceptedNameForVariableFrom: aCSNLHorizontalLayout mooseName , aCSNLHorizontalLayout mooseID asString).
	^ 'newRow: [ :' , localVariableName
		,
			' |
		'
		,
			(aCSNLHorizontalLayout cell
				flatCollect: [ :cell | 
					localVariableName , ' ' , ('' , (self visit: cell) removeSuffix: ';')
						,
							'.
			' indentBy: 4 ])
		,
			'
			]
		'
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNLLayout: aCSNLLayout [

	^ self visitCSNLVerticalLayout: aCSNLLayout
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNLVerticalLayout: aCSNLVerticalLayout [
	| localVariableName |
	localVariableName := 'col' , (self computeAcceptedNameForVariableFrom: aCSNLVerticalLayout mooseName , aCSNLVerticalLayout mooseID asString).
	^ 'newColumn: [ :' , localVariableName
		,
			' |
		'
		,
			(aCSNLVerticalLayout cell
				flatCollect: [ :cell | 
					localVariableName , ' ' , ('' , (self visit: cell) removeSuffix: ';')
						,
							'.
			' indentBy: 4 ])
		,
			'
		]
	'
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNPage: aCSNPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , (self computeAcceptedNameForClassFrom: aCSNPage name)
		instanceVariableNames: '' , ((self recursiveLocalWidgetNameOfPage: aCSNPage) flatCollect: [ :name | name uncapitalized , ' ' ])
		classVariableNames: ''
		package: self exportedPackageName , '-Page'.
	class class
		compile:
			'open
	<example>
	^ self new openWithSpec'.
	class class
		compile:
			'defaultSpec
	<spec: #default>
	^ SpecColumnLayout composed '
				,
					({aCSNPage widgets . aCSNPage businessPage} flatten
						flatCollect: [ :widget | ('' , (self visit: widget) removeSuffix: ';') ifEmpty: [ '' ] ifNotEmpty: [ :result | result , ';' , String cr ] ])
				,
					'
				yourself'.
	class compile: 'title' , String cr , String tab , '^ ' , ('''' , (self protectString: (aCSNPage title ifNil: [ '' ])) , '''').
	class instVarNames do: [ :each | self createAccessorForVariable: each inClass: class ].
	initializeWidgetsExporter exportInitializeWidgetOfPage: aCSNPage inClass: class.
	^ self visitCSNWidget: aCSNPage
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNUIAbsoluteHeight: aCSNUIAbsoluteHeight [
	^ aCSNUIAbsoluteHeight attributeValue onlyNumbers
		ifEmpty: [ self visitCSNAttribute: aCSNUIAbsoluteHeight ]
		ifNotEmpty: [ aCSNUIAbsoluteHeight name , ': ' , aCSNUIAbsoluteHeight attributeValue onlyNumbers , ';' ]
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNUIAbsoluteWidth: aCSNUIAbsoluteWidth [
	^ aCSNUIAbsoluteWidth attributeValue onlyNumbers
		ifEmpty: [ self visitCSNAttribute: aCSNUIAbsoluteWidth ]
		ifNotEmpty: [ aCSNUIAbsoluteWidth name , ': ' , aCSNUIAbsoluteWidth attributeValue onlyNumbers , ';' ]
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNUIButton: aCSNUIButton [
	"Button work as a basic widget in Spec and not as a container"
	^ self visitCSNWidget: aCSNUIButton
]

{ #category : #visiting }
CSNSpecExporter >> visitCSNWidget: aCSNWidget [
	^ ' add: #' , (self computeAcceptedNameForVariableFrom: aCSNWidget name uncapitalized) , ' ' , (aCSNWidget attributes flatCollect: [ :attribute | self visit: attribute ])
]

{ #category : #visiting }
CSNSpecExporter >> visitInsideAContainerWithLocalVariable: localVariableName andContainedWidgets: containedWidgets [
	localVariableName.
	^ 'newColumn: [ :' , localVariableName
		,
			' |
		'
		,
			(containedWidgets
				flatCollect: [ :widget |
					localVariableName , ' ' , ('' , (self visit: widget) removeSuffix: ';')
						,
							'.
			' indentBy: 4 ])
		,
			'
		]
	'
]

{ #category : #visiting }
CSNSpecExporter >> visitMooseModel: aMooseModel [
	aMooseModel allCSNPage do: [ :phase | self visit: phase ]
]

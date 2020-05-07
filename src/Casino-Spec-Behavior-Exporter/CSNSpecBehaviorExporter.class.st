Class {
	#name : #CSNSpecBehaviorExporter,
	#superclass : #CSNSpecExporter,
	#instVars : [
		'initializePresenterExporter'
	],
	#category : #'Casino-Spec-Behavior-Exporter'
}

{ #category : #accessing }
CSNSpecBehaviorExporter >> initializePresenterExporter [
	^ initializePresenterExporter
]

{ #category : #accessing }
CSNSpecBehaviorExporter >> initializePresenterExporter: anObject [
	initializePresenterExporter := anObject
]

{ #category : #visiting }
CSNSpecBehaviorExporter >> prepareExport [
	super prepareExport.
	initializePresenterExporter := CSNSpecBehaviorInitializePresenterExporter new mainExporter: self; yourself
]

{ #category : #visiting }
CSNSpecBehaviorExporter >> visitCSNBusinessPage: aCSNBusinessPage [
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
	self initializePresenterExporter exportInitializePresenterOfBusinessPage: aCSNBusinessPage inClass: class.
	^ self visitCSNWidget: aCSNBusinessPage
]

{ #category : #visiting }
CSNSpecBehaviorExporter >> visitCSNPage: aCSNPage [
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
	self initializePresenterExporter exportInitializePresenterOfPage: aCSNPage inClass: class.
	^ self visitCSNWidget: aCSNPage
]

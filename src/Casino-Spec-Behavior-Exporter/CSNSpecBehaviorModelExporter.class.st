Class {
	#name : #CSNSpecBehaviorModelExporter,
	#superclass : #CSNBehaviorModelExporter,
	#category : #'Casino-Spec-Behavior-Exporter'
}

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTBooleanLiteral: aFASTBooleanLiteral [
	self <<< aFASTBooleanLiteral value
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTExpressionStatement: aFASTExpressionStatement [
	(self accept: aFASTExpressionStatement expression).
	self <<< '.'
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaAssignementExpression: aFASTJavaAssignementExpression [
	self accept: aFASTJavaAssignementExpression variable.
	self <<< ' := '.
	self accept: aFASTJavaAssignementExpression expression
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaClassProperty: aFASTJavaClassProperty [
	self accept: aFASTJavaClassProperty type.
	self
		<<< ' ';
		<<< aFASTJavaClassProperty fieldName
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaConditionStatement: aFASTJavaConditionStatement [
	aFASTJavaConditionStatement orderedChildren flatCollect: [ :child | self accept: child ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaIfStatement: aFASTJavaIfStatement [
	self accept: aFASTJavaIfStatement condition.
	self <<< 'ifTrue:'.
	self accept: aFASTJavaIfStatement thenPart.	
	self <<< ''.

	aFASTJavaIfStatement elsePart
		ifNotNil: [ self
				crlf;
				<< 'ifFalse: '.
			self accept: aFASTJavaIfStatement elsePart ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaMethodInvocation: aFASTJavaMethodInvocation [
	aFASTJavaMethodInvocation receiver
		ifNotNil: [ :receiver | 
			self accept: receiver.
			self <<< ' ' ].
	self
		<<< (aFASTJavaMethodInvocation mooseName);
		<<< '('.
	aFASTJavaMethodInvocation arguments do: [ :argument | self accept: argument ] separatedBy: [ self <<< ', ' ].
	self <<< ')'.
	
	self errorStream << 'Unknow invocation: ' << (aFASTJavaMethodInvocation mooseName) << '(...) | '
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaNewExpression: aFASTJavaNewExpression [
	self accept: aFASTJavaNewExpression type.
	self <<< ' new'.
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaNullLiteral: aFASTJavaNullLiteral [
	self <<< 'nil'
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaOperationLeftOperand: aFASTJavaOperationLeftOperand [
	^ aFASTJavaOperationLeftOperand orderedChildren flatCollect: [:child | self accept: child ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaOperationRightOperand: aFASTJavaOperationRightOperand [ 
	^ aFASTJavaOperationRightOperand orderedChildren flatCollect: [:child | self accept: child ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaStringLiteral: aFASTJavaStringLiteral [
	self
		<<< '''';
		<<< (aFASTJavaStringLiteral value copyReplaceAll: '''' with: '\''');
		<<< ''''
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaThenPartStatement: aFASTJavaThenPartStatement [
	^ aFASTJavaThenPartStatement orderedChildren flatCollect: [ :child | self accept: child ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaVarDeclStatement: aFASTJavaVarDeclStatement [
	self <<< ''.
	aFASTJavaVarDeclStatement declarators do: [ :declarator | self accept: declarator ] separatedBy: [ self <<< '.'; cr ].
	self <<< '.'
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaVariableDeclarator: aFASTJavaVariableDeclarator [
	self accept: aFASTJavaVariableDeclarator variable.

	aFASTJavaVariableDeclarator expression
		ifNotNil: [ self <<< ' := '.
			self accept: aFASTJavaVariableDeclarator expression ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTJavaWhileStatement: aFASTJavaWhileStatement [
	self <<< '('.
	self accept: aFASTJavaWhileStatement condition.
	self <<< ')'.
	self <<< 'whileTrue:'.
	self accept: aFASTJavaWhileStatement body
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTLiteral: aFASTLiteral [
	self <<< aFASTLiteral value
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTNamedEntity: aFASTNamedEntity [
	self <<< aFASTNamedEntity name
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTStatement: aFASTStatement [
	self indent.
	aFASTStatement orderedChildren do: [ :child | self accept: child ]
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTStatementBlock: aFASTStatementBlock [
	self
		<<< ' [';
		indentPlus;
		crlf.
	aFASTStatementBlock statements
		do: [ :statement | 
			self indent.
			self accept: statement ]
		separatedBy: [ self writeErrorIfSome.
			self crlf ].
	self
		crlf;
		indentMinus;
		<< ']';
		crlf
]

{ #category : #generated }
CSNSpecBehaviorModelExporter >> visitFASTVariableExpression: aFASTVariableExpression [
	self
		<<<
			(aFASTVariableExpression famixVariable
				ifNil: [ aFASTVariableExpression name ]
				ifNotNil: [ :famixVariable | famixVariable uniqueName ])
]

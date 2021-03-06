tests
testReadInPartsFetchInSmallerParts

	| statement rows counter readStream |
	conn supportsCursoredFetch ifFalse: [ self skip ].
	conn beginTransaction.
	
	counter := GAFetchCounter new.
	statement := conn createStatement: 'SELECT code, name, observations FROM signature'.
	statement fetchListener: counter.
	statement fetchSize: 20.
	readStream := statement execute readStream.
	25 timesRepeat: [ rows := readStream next: 9 ].
	self assert: counter fetches equals: 12 "1 create cursor + 10 times * 21 rows + 1 end".
grammar JsonQuery;

query
   : NOT? SP? '(' query ')'                                                                         #parenExp
   | query SP LOGICAL_OPERATOR SP query                                                             #logicalExp
   | attrPath SP 'pr'                                                                               #presentExp
   | attrPath SP op=( EQ | NE | GT | LT | GE | LE | CO | SW | EW | IN ) SP value       #compareExp
   ;

NOT
   : 'not' | 'NOT'
   ;

LOGICAL_OPERATOR
   : 'and' | 'or'
   ;

BOOLEAN
   : 'true' | 'false'
   ;

NULL
   : 'null'
   ;

IN:  'IN' | 'in';
EQ : 'eq' | 'EQ';
NE : 'ne' | 'NE';
GT : 'gt' | 'GT';
LT : 'lt' | 'LT';
GE : 'ge' | 'GE';
LE : 'le' | 'LE';
CO : 'co' | 'CO';
SW : 'sw' | 'SW';
EW : 'ew' | 'EW';

attrPath
   : ATTRNAME subAttr?
   ;

subAttr
   : '.' attrPath
   ;

ATTRNAME
   : ALPHA ATTR_NAME_CHAR* ;

fragment ATTR_NAME_CHAR
   : '-' | '_' | ':' | DIGIT | ALPHA
   ;

fragment DIGIT
   : ('0'..'9')
   ;

fragment ALPHA
   : ( 'A'..'Z' | 'a'..'z' )
   ;

value
   : BOOLEAN           #boolean
   | NULL              #null
   | STRING            #string
   | DOUBLE            #double
   | '-'? INT EXP?     #long
   | listInts          #listOfInts
   | listDoubles       #listOfDoubles
   ;

STRING
   : '"' (ESC | ~ ["\\])* '"'
   ;

fragment ESC
   : '\\' (["\\/bfnrt] | UNICODE)
   ;

fragment UNICODE
   : 'u' HEX HEX HEX HEX
   ;

fragment HEX
   : [0-9a-fA-F]
   ;

DOUBLE
   : '-'? INT '.' [0-9] + EXP?
   ;

listDoubles
   : '[' subListOfDoubles
   ;

subListOfDoubles
   : DOUBLE SP subListOfDoubles
   | DOUBLE ']';

listInts
   : '[' subListOfInts
   ;

subListOfInts
   : INT SP subListOfInts
   | INT ']';

// INT no leading zeros.
INT
   : '0' | [1-9] [0-9]*
   ;

// EXP we use "\-" since "-" means "range" inside [...]
EXP
   : [Ee] [+\-]? INT
   ;

NEWLINE
   : '\n' ;

SP
   : ' ' NEWLINE*
   ;

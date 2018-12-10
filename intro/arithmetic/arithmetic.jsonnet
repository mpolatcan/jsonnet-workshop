/*
    Arithmetic:

    Arithmetic includes numeric operations like multiplication but also 
    various operations on other types. 

    - Use floating point arithmetic, bitwise ops, boolean logic
    - Strings may be concatenated with +, which implicitly converts one 
      operand to string if needed.
    - Two strings can be compared with < (unicode codepoint order).
    - Objects may be combined with + where the right-hand side wins field
      conflict. 
    - Test if a field is in a object with "in".
    - == is deep value equality.
    - Python compatible string formatting is available via "%". When combined
    with ||| this can be used for templating text files. 
*/
{
    concat_array: [1, 2, 3] + [4],
    concat_string: '123' + 4,
    equality: 1 == '1',
    equality2: [{}, { x: 3 - 1 }] == [{}, { x: 2 }],
    ex1: 1 + 2 * 3 / (4 + 5),
    // Bitwise operations first cast to int.
    ex2: self.ex1 | 3,
    // Modulo operator.
    ex3: self.ex1 % 2, 
    // Boolean logic
    ex4: (4 > 3) && (1 <= 3) || false,
    // Mixing objects together
    obj: { a: 1, b: 2 } + { b: 3, c: 4 },
    // Test if a field is in an object
    obj_member: 'foo' in { foo: 1 },
    // String formatting 
    str1: 'The value of self.ex2 is ' + self.ex2 + '.',
    str2: 'The value of self.ex2 is %g.' % self.ex2,
    str3: 'ex1=%0.2f, ex2=%0.2f' % [self.ex1, self.ex2],
    // By passing self, we allow ex1 and ex2 to 
    // be extracted internally. 
    str4: 'ex1=%(ex1)0.2f, ex2=%(ex2)0.2f' % self,
    // Do textual templating of entire files:
    str5: |||
        ex1=%(ex1)0.2f
        ex2=%(ex2)0.2f
    ||| % self 
}

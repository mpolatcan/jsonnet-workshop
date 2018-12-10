/*
    Errors can arise from the language itself (e.g, an array
    overrun) or thrown from Jsonnet cod Stack traces provide
    context for the error.

    - To raise an error: error "foo"
    - To assert a condition before an expression: assert "foo".i
    - A custom failure message: assert "foo" : "message";
    - Assert fields have a property: assert self.f == 10,
    - With custom failure message: assert "foo" : "message",
 */
 // Extend above example to sanity check input 
 local equal_parts(size, ingredients) = 
    local qty = size / std.length(ingredients);

    // Check a pre-condition
    if std.length(ingredients) == 0 then 
        error 'Empty ingredients'
    else [
        { kind: i, qty: qty }
        for i in ingredients
    ];

local subtract(a,b) = 
    assert a > b : 'a must be bigger than b';
    a - b; 

assert std.isFunction(subtract);

{
    test1: equal_parts(1, ['Whiskey']),
    test2: subtract(10,3),
    object: {
        assert self.f < self.g : 'wat',
        f: 1,
        g: 2,
    },
    assert std.isObject(self.object),
}
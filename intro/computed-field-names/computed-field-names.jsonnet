/*
    Computed Field Names
    Jsonnet objects can be used like a std::map or similar datastructures
    from regular languages.

    - Recall that a field lookup can be computed with obj[e],
    - The definition equivalent is {[e]: ...},
    - "self" or object locals cannot be accessed when field names are being
    computed, since the object is not yet constructed.
    - If a field name evaluates to null during object constructions, the field 
    is omitted. 
*/

local Margarita(salted) = {
    ingredients: [
        { kind: 'Tequila Blanco', qty: 2 },
        { kind: 'Lime', qty: 1 },
        { kind: 'Cointreau', qty: 1 },
    ],
    [if salted then 'garnish']: 'Salt',
};

{
    Margarita: Margarita(true),
    'Margarita Unsalted': Margarita(false),
}
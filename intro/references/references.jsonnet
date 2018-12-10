/*
    References:

    Another way to avoid duplication is to refer to naother part of the
    structure.

    - "self" refers to the current object
    - $ refers to the outer-most object
    - ['foo'] looks up a field
    - .f can be used if the field name is an identifier. 
    - [10] looks up an array element
    - Arbitrarily long paths are allowed
    - Array slices like arr[10:20:2] are allowed, like in Python
    - String can be looked up / sliced too, by unicode codepoint.
*/
{
    'Tom Collins': {
        ingredients: [
            { kind: "Farmer's Gin", qty: 1.5 },
            { kind: 'Lemon', qty: 1 },
            { kind: 'Simple Syrup', qty: 0.5 },
            { kind: 'Soda', qty: 2},
            { kind: 'Angostura', qty: 'dash' },
        ],
        garnish: 'Maraschino Cherry',
        served: 'Tall'
    },
    Martini: {
        ingredients: [
            {
                // Use the same gin as the Tom Collins.
                kind: 
                    $['Tom Collins'].ingredients[0].kind,
                qty: 2, 
            },
            { kind: 'Dry White Vermouth', qty: 1 },
        ],
        garnish: 'Olive',
        served: 'Straight Up',
    },
    // Create an alias 
    'Gin Martini': self.Martini,
}

/*
    Syntax:
    Any JSON document is valid Jsonnet program, so we'll focus on what Jsonnet adds
    to JSON. Let's start with an example that does not involve any computation but
    uses new syntax.

    - Fields that happen to be valid identifiers have no quotes
    - Trailing commas at the end of arrays / objects
    - Comments
    - String literals use " or '. The single quote is easier on the eyes but either
    can be used to avoid escaping the other, e.g "Farmer's Gin" instead of 'Farmer\'s Gin'.
    - Text blocks ||| allow verbatim text across multiple lines.
    - Verbatim strings @'foo' and @"foo" are for single lines.
*/
{
    cocktails: {
        // Ingredient quantities are in fl oz
        'Tom Collins': {
            ingredients: [
                { kind: "Farmer's Gin", gty: 1.5 },
                { kind: 'Lemon', qty: 1 },
                { kind: 'Simply Syrup', qty: 0.5 },
                { kind: 'Soda', qty: 2 },
                { kind: 'Angostura', qty: 'dash' },
            ],
            garnish: 'Maraschino Chery',
            served: 'Tall',
            description: |||
                The Tom Collins is essentially gin and
                lemonade. The bitters add complexity.
            |||,
        },
        Manhattan: {
            ingredients: [
                { kind: 'Rye', qty: 2.5 },
                { kind: 'Sweet Red Vermouth', qty: 1 },
                { kind: 'Angostura', qty: 'dash' },
            ],
            garnish: 'Maraschino Cherry',
            served: 'Straight Up',
            description: @'A clear \ red drink.',
        },
    },
}
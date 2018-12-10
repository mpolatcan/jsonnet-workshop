/*
    Top-level arguments:

    Alternatively the same code can be written using top-level arguments,
    where the whole config is written as a function. How does this differ to
    using external variables?

    - Values must be explicitly threaded through files
    - Default values can be provided
    - The config can be imported as a library and called as a function

    Generally, top level arguments are the safer and easier way to parameterize
    an entire config, because the variables are not global and its clear what
    parts of the config are dependent on their environment. However, they do require
    more explicit, threading of the values into other imported code.

    jsonnet --tla-str prefix="Happy Hour " \
            --tla-code brunch=true ...
*/
local lib = import 'library-tla.libsonnet';

/* Here is the top-level function, note brunch now has a 
default value. */
function (prefix, brunch=false) {
    [prefix + 'Pina Colada']: {
        ingredients: [
            { kind: 'Rum', qty: 3},
            { kind: 'Pineapple Juice', qty: 6 },
            { kind: 'Coconut Cream', qty: 2 },
            { kind: 'Ice', qty: 12 },
        ],
        garnish: 'Pineapple slice',
        served: 'Frozen',
    },

    [if brunch then prefix + 'Bloody Mary']: {
        ingredients: [
            { kind: 'Vodka', qty: 1.5 },
            { kind: 'Tomato Juice', qty: 3 },
            { kind: 'Lemon Juice', qty: 1.5 },
            { kind: 'Worcestershire', qty: 0.25 },
            { kind: 'Tobasco Sauce', qty: 0.15 },
        ],
        garnish: 'Celery salt & pepper',
        served: 'Tall'
    },

    [prefix + 'Mimosa']: lib.Mimosa(brunch),
}
/* 
    Jsonnet is hermetic: It always generates the same data no
    matter the execution environment. This is an important property
    but there are times when you want a few carefully chosen parameters
    at the top level. There are two ways to do this, with different properties.

    - External variables, which are accessible anywhere in the 
    config, or any file, using std.extVar("foo").
    - Top-level arguments, where the whole config is expressed as a function.

    External variables:

    The following example binds two external variables. Any jsonnet value can be
    bound to an external variable, even functions.

    - prefix is bound to the string "Happy Hour "
    - brunch is bound to true

    The values are configured when the Jsonnet virtual machine is initialized, by
    passing either 1) Jsonnet code (which evaluates to the value), 2) or a raw string.
    The latter is just a convenience, because escaping a string to pass it as Jsonnet code
    can be tedious. To make this concrete, the above variables can be configured with the 
    following commandline:

    jsonnet --ext-str prefix="Happy Hour " \
            --ext-code brunch=true ... 
*/ 
local lib = import 'library-ext.libsonnet';

{
    [std.extVar('prefix') + 'Pina Colada']: {
        ingredients: [
            { kind: 'Rum', qty: 3},
            { kind: 'Pineapple Juice', qty: 6 },
            { kind: 'Coconut Cream', qty: 2 },
            { kind: 'Ice', qty: 12 },
        ],
        garnish: 'Pineapple slice',
        served: 'Frozen'
    },

    [if std.extVar('brunch') then 
        std.extVar('prefix') + 'Bloody Mary'
    ]: {
        ingredients: [
            { kind: 'Vodka', qty: 1.5 },
            { kind: 'Tomato Juice', qty: 3 },
            { kind: 'Lemon Juice', qty: 1.5 },
            { kind: 'Worcestershire', qty: 0.25 },
            { kind: 'Tobacco Sauce', qty: 0.15 },
        ],
        garnish: 'Celery salt & pepper',
        served: 'Tall',
    },

    [std.extVar('prefix') + 'Mimosa']: lib.Mimosa,
}
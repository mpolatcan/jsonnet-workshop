/* 
    Imports: 

    It's possible to import both code and raw data from other
    files.

    - The "import" construct is like copy/pasting Jsonnet code
    - Files designed for import by convention end with. ".libsonnet"
    - Raw JSON can be imported this way too.
    - The "importstr" construct is for verbatim UTF-8 text.

    Usually, imported Jsonnet content is stashed in a top-level local
    variable. This resembles the way other programming languages handle 
    modules. Jsonnet libraries typically return an object, so that they can
    easily be extended. Neither of these conventions are enforced.
*/
local martinis = import 'martinis.libsonnet';

{
    'Vodka Martini': martinis['Vodka Martini'],
    Manhattan: {
        ingredients: [
            { kind: 'Rye', qty: 2.5 },
            { kind: 'Sweet Red Vermouth', qty: 1 },
            { kind: 'Angostura', qty: 'dash' },
        ],
        garnish: importstr 'garnish.txt',
        served: 'Straight Up'
    },
    Cosmpolitan: martinis.Cosmopolitan,
}
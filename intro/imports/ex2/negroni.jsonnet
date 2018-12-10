/*
    The following example shows how to write libraries of 
    functions. It also shows how to define a local variable 
    in the scope of a function. Try adding the Bee's Knees 
    from above using the utility library.
*/
local utils = import 'utils.libjsonnet';

{
    Negroni: {
        // Divide 3oz among the 3 ingredients
        ingredients: utils.equal_parts(3, [
            'Farmers Gin',
            'Sweet Red Vermouth',
            'Campari',
        ]),
        garnish: 'Orange Peel',
        served: 'On The Rocks',
    },
}
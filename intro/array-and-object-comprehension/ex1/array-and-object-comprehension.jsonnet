/* 
    Array and Object Comprehension 

    What if you want to make an array or object and you don't know many 
    elements / fields they will have run-time ? Jsonnet has Python-style
    array and object comprehension constructs to allow this.

    - Any nesting of for and if can be used
    - The nest behaves like a loop nets, although the body is written first.
*/

local arr = std.range(5, 8);
{
    array_comprehensions: {
        higher: [x + 3 for x in arr],
        lower: [x -3 for x in arr],
        evens: [x for x in arr if x % 2 == 0],
        odds: [x for x in arr if x % 2 == 1],
        evens_and_odds: [
            '%d-%d' % [x, y]
            for x in arr 
            if x % 2 == 0
            for y in arr 
            if y % 2 == 1
        ],
    },
    object_comprehensions: {
        evens: {
            ['f' + x]: true
            for x in arr 
            if x % 2 == 0
        },
        // Use object composition (+) to add in static fields
        mixture: {
            f: 1,
            g: 2,
        } + {
            [x]: 0
            for x in ['a', 'b', 'c']
        },
    },
}
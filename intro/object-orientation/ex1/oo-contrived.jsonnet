/* 
    Object-Orientation:

    In general, object orientation makes it easy to define many 
    variants from a single "base". Unlike Java, C++ and Python, where
    classes extend other classes, in Jsonnet, objects extend other objects.

    - Objects (which we inherit from JSON)
    - The object composition operator +, which merges two objects,
    choosing the right hand side when fields collide
    - The self keyword, a reference to the current object.

    When these features are combined together and with the following new 
    features, thigs get a lot more interesting:

    - Hidden fields, defined with ::, which do not appear in generated JSON
    - The super keyword, which has its usual meaning
    - The +: field syntax for overriding deeply nested fields.
*/
local Base = {
    f: 2,
    g: self.f + 100,
};

local WrapperBase = {
    Base: Base,
};

{
    Derived: Base + {
        f: 5,
        old_f: super.f,
        old_g: super.g,
    },
    WrapperDerived: WrapperBase + {
        Base+: { f: 5 },
    },
}
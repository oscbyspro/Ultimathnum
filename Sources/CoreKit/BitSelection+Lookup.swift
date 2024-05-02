//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Selection x Lookup
//*============================================================================*

extension BitSelection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func size<T>() -> Self where Self == Bit.Size<T> {
        Self()
    }
    
    @inlinable public static func anywhere<T>(_ bit: Bit) -> Self where Self == Bit.Anywhere<T> {
        Self(bit)
    }
    
    @inlinable public static func ascending<T>(_ bit: Bit) -> Self where Self == Bit.Ascending<T> {
        Self(bit)
    }
    
    @inlinable public static func nonascending<T>(_ bit: Bit) -> Self where Self == Bit.Nonascending<T> {
        Self(bit)
    }
    
    @inlinable public static func descending<T>(_ bit: Bit) -> Self where Self == Bit.Descending<T> {
        Self(bit)
    }
    
    @inlinable public static func nondescending<T>(_ bit: Bit) -> Self where Self == Bit.Nondescending<T> {
        Self(bit)
    }
    
    @inlinable public static func appendix<T>() -> Self where Self == Bit.Appendix<T> {
        Self()
    }
    
    @inlinable public static func nonappendix<T>() -> Self where Self == Bit.Nonappendix<T> {
        Self()
    }
}

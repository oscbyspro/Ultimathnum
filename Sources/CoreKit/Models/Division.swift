//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division
//*============================================================================*

@frozen public struct Division<Quotient, Remainder>: Arithmetic {
    
    public typealias Quotient  = Quotient
    
    public typealias Remainder = Remainder
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var quotient:  Quotient
    public var remainder: Remainder
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(quotient: Quotient, remainder: Remainder) {
        self.quotient  = quotient
        self.remainder = remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var components: (quotient: Quotient, remainder: Remainder) {
        consuming get {
            (quotient: self.quotient, remainder: self.remainder)
        }
        
        consuming set {
            (quotient: self.quotient, remainder: self.remainder) = newValue
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equatable
//=----------------------------------------------------------------------------=

extension Division: Equatable where Quotient: Equatable, Remainder: Equatable { }

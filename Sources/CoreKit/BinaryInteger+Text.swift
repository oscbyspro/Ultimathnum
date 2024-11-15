//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Text
//*============================================================================*
//=----------------------------------------------------------------------------=
// TODO: @_unavailableInEmbedded is not a known attribute in Swift 5.9
//=----------------------------------------------------------------------------=

/* @_unavailableInEmbedded */ extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: String) {
        always: do {
            self = try TextInt.decimal.decode(description)
        }   catch  {
            return nil
        }
    }
    
    @inlinable public init(_ description: some StringProtocol, using format: TextInt) throws {
        self = try format.decode(description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        self.description(using: TextInt.decimal)
    }
    
    @inlinable public func description(using format: TextInt) -> String {
        format.encode(self)
    }
}

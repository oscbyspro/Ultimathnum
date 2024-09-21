//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Namespace x Elements
//*============================================================================*

extension Namespace {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: It can be used to load `Swift.BinaryInteger/words`.
    ///
    @inlinable package static func withUnsafeBufferPointerOrCopy<Elements, Value>(
        of sequence: Elements,
        perform action: (UnsafeBufferPointer<Elements.Element>) throws -> Value
    )   rethrows -> Value where Elements: Sequence {
        
        if  let  x = try sequence.withContiguousStorageIfAvailable(action) {
            return x
        }
        
        return try ContiguousArray(sequence).withUnsafeBufferPointer(action)
    }
}

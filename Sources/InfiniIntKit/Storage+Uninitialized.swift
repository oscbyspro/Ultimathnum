//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int Storage x Uninitialized
//*============================================================================*

extension InfiniIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by manual initialization.
    ///
    /// - Parameter count: The number of **uninitialized** elements passed to the `delegate`.
    ///
    /// - Parameter appendix: The bit that extends the bit pattern initialized by the `delegate`.
    ///
    /// - Parameter delegate: A process that manually **initializes each element** passed to it.
    ///
    @inlinable public static func uninitialized(
        count: IX,
        repeating appendix: Bit,
        delegate: (MutableDataInt<Element.Magnitude>.Body) -> Void
    )   -> Self {
        
        let body = Body(unsafeUninitializedCapacity: Int(count)) {
            delegate(MutableDataInt.Body($0.baseAddress!, count: IX(count)))
            $1 = Int(count)
        }
        
        return Self(consume body, repeating: appendix)
    }
}

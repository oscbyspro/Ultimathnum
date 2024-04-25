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
// MARK: * Infini Int x Uninitialized
//*============================================================================*

extension InfiniInt {
    
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
        delegate: (DataInt<Element.Magnitude>.Canvas) -> Void
    )   -> Self {
        
        var storage = Storage.uninitialized(
            count:     count,
            repeating: appendix,
            delegate:  delegate
        )
        
        storage.normalize()
        return Self(unchecked: storage)
    }
}

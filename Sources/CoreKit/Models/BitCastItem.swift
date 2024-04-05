//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Cast Item
//*============================================================================*

/// A wrapper model that conforms to ``BitCastable``.
///
/// Use this wrapper to decouple bit patterns from generic constraints:
///
/// ```swift
/// struct Doge<Such: Generic, Much: Wow>: BitCastable {
///     typealias BitPattern = BitCastItem<(Such.BitPattern, Much.BitPattern)>
/// }
/// ```
///
@frozen public struct BitCastItem<Storage>: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializes
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ storage: Storage) {
        self.storage = storage
    }
}

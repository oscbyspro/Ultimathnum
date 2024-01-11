//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Collection
//*============================================================================*

extension Namespace {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Array Index
    //=------------------------------------------------------------------------=
    
    /// Returns the array-like result of `index(_:offsetBy:limitedBy:)`.
    @inlinable public static func arrayIndex(
    _   index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        let distanceLimit = limit - index
        
        guard distance >= 0 as Int
        ? distance <= distanceLimit || distanceLimit < 0 as Int
        : distance >= distanceLimit || distanceLimit > 0 as Int
        else { return nil }
        
        return index + distance as Int
    }
}

//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Infini Int x Shift x Stdlib
//*============================================================================*

extension InfiniInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(instance: inout Self, distance: some Swift.BinaryInteger) {
        instance = instance << distance
    }
    
    @inlinable public static func <<(instance: consuming Self, distance: some Swift.BinaryInteger) -> Self {
        Self(instance.base << IX(Swift.Int(clamping: distance)))
    }
    
    @inlinable public static func >>=(instance: inout Self, distance: some Swift.BinaryInteger) {
        instance = instance >> distance
    }
    
    @inlinable public static func >>(instance: consuming Self, distance: some Swift.BinaryInteger) -> Self {
        Self(instance.base >> IX(Swift.Int(clamping: distance)))
    }
}

//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Double Int x Shift x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
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

//*============================================================================*
// MARK: * Double Int x Shift x Stdlib x Swift Fixed Width Integer
//*============================================================================*
    
extension DoubleInt.Stdlib {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<=(instance: inout Self, distance: borrowing Self) {
        instance = instance &<< distance
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: borrowing Self) -> Self {
        Self(instance.base &<< distance.base)
    }
    
    @inlinable public static func &>>=(instance: inout Self, distance: borrowing Self) {
        instance = instance &>> distance
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: borrowing Self) -> Self {
        Self(instance.base &>> distance.base)
    }
}

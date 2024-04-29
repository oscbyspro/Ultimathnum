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
// MARK: * Integer Invariants
//*============================================================================*

public struct IntegerInvariants<T> where T: BinaryInteger {
    
    typealias S = T.Signitude
    
    typealias M = T.Magnitude
    
    typealias F = Fallible<T>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let test: Test
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    public init(_ item: T.Type, test: Test) {
        self.test = test
    }
    
    public init(_ item: T.Type, file: StaticString = #file, line: UInt = #line) {
        self.init(item, test: Test(file: file, line: line))
    }
}

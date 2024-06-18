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
    
    typealias T2 = Doublet<T> where T: SystemsInteger

    typealias T3 = Triplet<T> where T: SystemsInteger
    
    typealias S  = T.Signitude
    
    typealias S2 = Doublet<S> where T: SystemsInteger

    typealias S3 = Triplet<S> where T: SystemsInteger
    
    typealias M  = T.Magnitude
    
    typealias M2 = Doublet<M> where T: SystemsInteger

    typealias M3 = Triplet<M> where T: SystemsInteger
    
    typealias F  = Fallible<T>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var shlEsque: T {
        (T.size.isInfinite ? 127 : T(raw: T.size - 1))
    }
    
    @inlinable public static var minEsque: T {
        (T.isSigned ? T(repeating: 1) << shlEsque : T.zero)
    }
    
    @inlinable public static var maxEsque: T {
        (T.isSigned ? minEsque.toggled() : T(repeating: 1))
    }
    
    @inlinable public static var msbEsque: T {
        (T.isSigned ? T(repeating: 1) : 1) << shlEsque
    }
    
    @inlinable public static var botEsque: T {
        (T.isSigned ? msbEsque.toggled() : msbEsque - 1)
    }
    
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

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
import TestKit

//*============================================================================*
// MARK: * Double Int
//*============================================================================*

final class DoubleIntTests: XCTestCase {
    
    typealias X2<Base> = DoubleInt<Base> where Base: SystemsInteger
    
    typealias I8x2 = DoubleInt<I8>
    typealias U8x2 = DoubleInt<U8>
    
    typealias I8x4 = DoubleInt<I8x2>
    typealias U8x4 = DoubleInt<U8x2>
    
    typealias IXx2 = DoubleInt<IX>
    typealias UXx2 = DoubleInt<UX>
    
    typealias IXx4 = DoubleInt<IXx2>
    typealias UXx4 = DoubleInt<UXx2>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    static let types: [any SystemsInteger.Type] = {
        typesWhereIsSigned +
        typesWhereIsUnsigned
    }()
    
    static let typesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        I8x2.self,
        I8x4.self,
        IXx2.self,
        IXx4.self,
    ]
    
    static let typesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        U8x2.self,
        U8x4.self,
        UXx2.self,
        UXx4.self,
    ]
    
    static let bases: [any SystemsInteger.Type] = {
        basesWhereIsSigned +
        basesWhereIsUnsigned
    }()
    
    static let basesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        I8x2.High.self,
        I8x4.High.self,
        IXx2.High.self,
        IXx4.High.self,
    ]
    
    static let basesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        U8x2.High.self,
        U8x4.High.self,
        UXx2.High.self,
        UXx4.High.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).mode(BinaryIntegerID())
            IntegerInvariants(T.self).size(SystemsIntegerID())
            IntegerInvariants(T.self).protocols()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}

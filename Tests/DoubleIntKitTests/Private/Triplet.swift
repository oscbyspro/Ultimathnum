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
// MARK: * Triplet
//*============================================================================*

final class TripletTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    static let bases: [any SystemsInteger.Type] = {
        basesIsSigned +
        basesIsUnsigned
    }()
    
    static let basesIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        IX.self, I8.self, I16.self, I32.self, I64.self,
    ]
    
    static let basesIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        UX.self, U8.self, U16.self, U32.self, U64.self,
    ]
}

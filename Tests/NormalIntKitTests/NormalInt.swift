//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import NormalIntKit
import TestKit

//*============================================================================*
// MARK: * Normal Int
//*============================================================================*

final class NormalIntTests: XCTestCase {
    
    typealias T = NormalInt<UX>
    
    typealias X   = [UX ]
    
    typealias X64 = [U64]
    
    typealias X32 = [U32]
}

//*============================================================================*
// MARK: * Normal Int x Helpers
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    static var min256: Self {
        Self(x64:[ 0,  0,  0,  0] as [U64])
    }
    
    static var msb256: Self {
        Self(x64:[ 0,  0,  0, ~0/2 + 1] as [U64])
    }
    
    static var max256: Self {
        Self(x64:[~0, ~0, ~0, ~0] as [U64])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(x64: [U64]) {
        try! self.init(words: BitCastSequence(ChunkedIntSequence(x64, isSigned: false, as: UX.self)))
    }
    
    init(x32: [U32]) {
        try! self.init(words: BitCastSequence(ChunkedIntSequence(x32, isSigned: false, as: UX.self)))
    }
}

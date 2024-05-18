//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Endianness
//*============================================================================*

final class EndiannessTests: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testValues() {
        Test().yay( Ascending().matchesLittleEndianByteOrder)
        Test().nay(Descending().matchesLittleEndianByteOrder)
    }
    
    func testSystem() {
        #if _endian(little)
        Test().yay( Ascending().matches(endianness: .system))
        Test().nay(Descending().matches(endianness: .system))
        #elseif _endian(big)
        Test().nay( Ascending().matches(endianness: .system))
        Test().yay(Descending().matches(endianness: .system))
        #endif
    }
}

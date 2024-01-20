//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    typealias IXx2 = DoubleInt<IX>
    typealias UXx2 = DoubleInt<UX>
}

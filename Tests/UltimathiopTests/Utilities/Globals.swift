//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import DoubleIntIop
import DoubleIntKit
import InfiniIntIop
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Globals
//*============================================================================*
// Imagine an array of chosen types and a bunch of type filters...
//=----------------------------------------------------------------------------=

let typesAsFiniteIntegerInteroperable: [any FiniteIntegerInteroperable.Type] = {
    typesAsCompactIntegerInteroperable +
    typesAsLenientIntegerInteroperable +
    typesAsNaturalIntegerInteroperable
}()

let typesAsSignedIntegerInteroperable: [any SignedIntegerInteroperable.Type] = {
    typesAsCompactIntegerInteroperable +
    typesAsLenientIntegerInteroperable
}()

let typesAsSystemsIntegerInteroperable: [any SystemsIntegerInteroperable.Type] = {
    typesAsCompactIntegerInteroperable +
    typesAsNaturalIntegerInteroperable
}()

let typesAsLenientIntegerInteroperable: [any LenientIntegerInteroperable.Type] = [
    InfiniInt<I8>.self,
    InfiniInt<IX>.self,
]

let typesAsCompactIntegerInteroperable: [any CompactIntegerInteroperable.Type] = [
    IX.self,  I8 .self, I16.self, I32.self, I64 .self,
    DoubleInt<I8>.self, DoubleInt<DoubleInt<I8>>.self,
    DoubleInt<IX>.self, DoubleInt<DoubleInt<IX>>.self,
]

let typesAsNaturalIntegerInteroperable: [any NaturalIntegerInteroperable.Type] = [
    UX.self,  U8 .self, U16.self, U32.self, U64 .self,
    DoubleInt<U8>.self, DoubleInt<DoubleInt<U8>>.self,
    DoubleInt<UX>.self, DoubleInt<DoubleInt<UX>>.self,
]

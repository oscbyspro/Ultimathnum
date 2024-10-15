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
// MARK: * Global x Types
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Integers
//=----------------------------------------------------------------------------=

public let typesAsCoreInteger: [any CoreInteger.Type] = {
    typesAsCoreIntegersAsSigned +
    typesAsCoreIntegersAsUnsigned
}()

public let typesAsCoreIntegerAsByte: [any CoreInteger.Type] = [
    I8.self,
    U8.self,
]

public let typesAsCoreIntegersAsSigned: [any CoreIntegerAsSigned.Type] = [
    IX.self, I8.self, I16.self, I32.self, I64.self,
]

public let typesAsCoreIntegersAsUnsigned: [any CoreIntegerAsUnsigned.Type] = [
    UX.self, U8.self, U16.self, U32.self, U64.self,
]

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

public let allSwiftBinaryFloatingPointTypes: [any Swift.BinaryFloatingPoint.Type] = [
    Float32.self,
    Float64.self,
]

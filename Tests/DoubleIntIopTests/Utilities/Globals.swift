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

//*============================================================================*
// MARK: * Utilities x Globals
//*============================================================================*
// Imagine an array of chosen types and a bunch of type filters...
//=----------------------------------------------------------------------------=

let typesAsDoubleIntStdlib: [any DoubleIntStdlib.Type] = {
    typesAsDoubleIntStdlibAsSigned +
    typesAsDoubleIntStdlibAsUnsigned
}()

let typesAsDoubleIntStdlibAsSigned: [any (DoubleIntStdlib & Swift.SignedInteger).Type] = [
    DoubleInt<I8>.Stdlib.self, DoubleInt<DoubleInt<I8>>.Stdlib.self,
    DoubleInt<IX>.Stdlib.self, DoubleInt<DoubleInt<IX>>.Stdlib.self,
]

let typesAsDoubleIntStdlibAsUnsigned: [any (DoubleIntStdlib & Swift.UnsignedInteger).Type] = [
    DoubleInt<U8>.Stdlib.self, DoubleInt<DoubleInt<U8>>.Stdlib.self,
    DoubleInt<UX>.Stdlib.self, DoubleInt<DoubleInt<UX>>.Stdlib.self,
]

let typesAsDoubleIntStdlibAsWorkaround: [AnyDoubleIntStdlibType] = typesAsDoubleIntStdlib.map {
    AnyDoubleIntStdlibType(base: $0)
}

let typesAsDoubleIntStdlibAsSignedAsWorkaround: [AnyDoubleIntStdlibTypeAsSigned] = typesAsDoubleIntStdlibAsSigned.map {
    AnyDoubleIntStdlibTypeAsSigned(base: $0)
}

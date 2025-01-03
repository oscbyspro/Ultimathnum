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
// MARK: * Binary Integer
//*============================================================================*

extension IX:   CompactIntegerInteroperable { }
extension I8:   CompactIntegerInteroperable { }
extension I16:  CompactIntegerInteroperable { }
extension I32:  CompactIntegerInteroperable { }
extension I64:  CompactIntegerInteroperable { }

@available(*, unavailable)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension I128: CompactIntegerInteroperable { }

extension UX:   NaturalIntegerInteroperable { }
extension U8:   NaturalIntegerInteroperable { }
extension U16:  NaturalIntegerInteroperable { }
extension U32:  NaturalIntegerInteroperable { }
extension U64:  NaturalIntegerInteroperable { }

@available(*, unavailable)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension U128: NaturalIntegerInteroperable { }

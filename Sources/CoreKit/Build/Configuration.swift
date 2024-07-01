//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Configuration
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Endianness
//=----------------------------------------------------------------------------=

#if _endian(little)

#elseif _endian(big)
#error("unsupported system byte order")
#else
#error("unknown or invalid system byte order")
#endif

//=----------------------------------------------------------------------------=
// MARK: + Text
//=----------------------------------------------------------------------------=

#if $Embedded
public typealias   MaybeCustomStringConvertible = Any
public typealias MaybeLosslessStringConvertible = Any
#else
public typealias   MaybeCustomStringConvertible =   CustomStringConvertible
public typealias MaybeLosslessStringConvertible = LosslessStringConvertible
#endif

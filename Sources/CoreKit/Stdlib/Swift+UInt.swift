//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Swift x UInt
//*============================================================================*

extension UInt:   BitCastable { public typealias BitPattern = Magnitude }

//*============================================================================*
// MARK: * Swift x UInt8
//*============================================================================*

extension UInt8:  BitCastable { public typealias BitPattern = Magnitude }

//*============================================================================*
// MARK: * Swift x UInt16
//*============================================================================*

extension UInt16: BitCastable { public typealias BitPattern = Magnitude }

//*============================================================================*
// MARK: * Swift x UInt32
//*============================================================================*

extension UInt32: BitCastable { public typealias BitPattern = Magnitude }

//*============================================================================*
// MARK: * Swift x UInt64
//*============================================================================*

extension UInt64: BitCastable { public typealias BitPattern = Magnitude }

//*============================================================================*
// MARK: * Swift x UInt128
//*============================================================================*

@available(*, unavailable)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: BitCastable { public typealias BitPattern = Magnitude }

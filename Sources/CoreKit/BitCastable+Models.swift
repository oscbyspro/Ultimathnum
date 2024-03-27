//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable x Models
//*============================================================================*

extension Bool: BitCastable {
    public typealias BitPattern = Self
}

extension Int: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int8: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int16: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int32: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int64: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt8: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt16: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt32: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt64: BitCastable {
    public typealias BitPattern = Magnitude
}

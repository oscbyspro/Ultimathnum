//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Standard Int
//*============================================================================*

@frozen public struct UMNStandardInt<Base: UMNBinaryInteger>: Swift.BinaryInteger {
    
    public typealias IntegerLiteralType = Base.IntegerLiteralType
    
    public typealias Magnitude = UMNStandardInt<Base.Magnitude>
    
    public typealias Words = [UInt]
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: consuming Base) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral value: consuming IntegerLiteralType) {
        fatalError("TODO")
    }
    
    @inlinable public init(_ source: consuming some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init?(exactly source: consuming some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init(clamping source: consuming some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init(truncatingIfNeeded source: consuming some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init(_ source: consuming some BinaryFloatingPoint) {
        fatalError("TODO")
    }
    
    @inlinable public init?(exactly source: consuming some BinaryFloatingPoint) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitWidth: Int {
        fatalError("TODO")
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        fatalError("TODO")
    }
    
    @inlinable public var magnitude: Magnitude {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~ (x: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func - (lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
        
    @inlinable public static func + (lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func *= (lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func * (lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func %= (lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func % (lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func /= (lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func / (lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &= (lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func |= (lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func ^= (lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func <<= (lhs: inout Self, rhs: some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public static func >>= (lhs: inout Self, rhs: some BinaryInteger) {
        fatalError("TODO")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fixed Width Integer
//=----------------------------------------------------------------------------=

extension UMNStandardInt: Swift.FixedWidthInteger where Base: UMNTrivialInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Int {
        fatalError("TODO")
    }
    
    @inlinable public static var max: Self {
        fatalError("TODO")
    }
    
    @inlinable public static var min: Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bigEndian value: Self) {
        fatalError("TODO")
    }
    
    @inlinable public init(littleEndian value: Self) {
        fatalError("TODO")
    }
    
    @inlinable public init(_truncatingBits: UInt) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var nonzeroBitCount: Int {
        fatalError("TODO")
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public var byteSwapped: Self {
        fatalError("TODO")
    }
    
    @inlinable public func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func dividingFullWidth(_ dividend: (high: Self, low: Magnitude)) -> (quotient: Self, remainder: Self) {
        fatalError("TODO")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditional Conformances
//=----------------------------------------------------------------------------=

extension UMNStandardInt: Swift  .SignedNumeric where Base: UMNSigned   { }
extension UMNStandardInt: Swift  .SignedInteger where Base: UMNSigned   { }
extension UMNStandardInt: Swift.UnsignedInteger where Base: UMNUnsigned { }
extension UMNStandardInt: Swift.LosslessStringConvertible where Base: UMNTrivialInteger { }

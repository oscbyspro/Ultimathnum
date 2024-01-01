//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Stdlib Int
//*============================================================================*

@frozen public struct UMNStdlibInt<Base: UMNBinaryInteger>: Swift.BinaryInteger {
    
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
    
    @inlinable public init(integerLiteral: consuming Base.IntegerLiteralType) {
        self.base =  .init(integerLiteral: integerLiteral)
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
    
    @inlinable public var words: [UInt] {
        fatalError("TODO")
    }
    
    @inlinable public var magnitude: UMNStdlibInt<Base.Magnitude> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
        
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func %=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func %(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func /=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func /(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        fatalError("TODO")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fixed Width Integer
//=----------------------------------------------------------------------------=

extension UMNStdlibInt: Swift.FixedWidthInteger where Base: UMNSystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        Self(Base.min)
    }
    
    @inlinable public static var max: Self {
        Self(Base.max)
    }
    
    @inlinable public static var bitWidth: Int {
        MemoryLayout<Base>.size * 8
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bigEndian: consuming Self) {
        fatalError("TODO")
    }
    
    @inlinable public init(littleEndian: consuming Self) {
        fatalError("TODO")
    }
    
    @inlinable public init(_truncatingBits: consuming UInt) {
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
    
    @inlinable public func addingReportingOverflow(_ addend: Self)
    -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func subtractingReportingOverflow(_ subtrahend: Self)
    -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func multipliedReportingOverflow(by multiplier: Self) 
    -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func dividedReportingOverflow(by divisor: Self) 
    -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func remainderReportingOverflow(dividingBy divisor: Self)
    -> (partialValue: Self, overflow: Bool) {
        fatalError("TODO")
    }
    
    @inlinable public func dividingFullWidth(_ dividend: (high: Self, low: Magnitude)) 
    -> (quotient: Self, remainder: Self) {
        fatalError("TODO")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditional Conformances
//=----------------------------------------------------------------------------=

extension UMNStdlibInt: Swift  .SignedNumeric where Base: UMNSignedInteger   { }
extension UMNStdlibInt: Swift  .SignedInteger where Base: UMNSignedInteger   { }
extension UMNStdlibInt: Swift.UnsignedInteger where Base: UMNUnsignedInteger { }
extension UMNStdlibInt: Swift.LosslessStringConvertible where Base: UMNSystemInteger { }

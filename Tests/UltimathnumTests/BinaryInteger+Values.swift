//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Values
//*============================================================================*

@Suite struct BinaryIntegerTestsOnValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/values: min",
        Tag.List.tags(.generic),
        arguments: typesAsEdgyInteger
    )   func min(type: any EdgyInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            try #require(T.min == T(Bit(T.isSigned)).up(Shift.max))
            try #require(T.min.decremented().error)
            try #require(T.min.complement(true).error)
        }
    }
    
    @Test(
        "BinaryInteger/values: max",
        Tag.List.tags(.generic),
        arguments: typesAsEdgyInteger
    )   func max(type: any EdgyInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            try #require(T.max == T(Bit(T.isSigned)).up(Shift.max).toggled())
            try #require(T.max.incremented().error)
        }
    }
    
    @Test(
        "BinaryInteger/values: lsb",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func lsb(type: any BinaryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(T.lsb.lsb == Bit.one)
            try #require(T.lsb.count( Bit.one) == Count(1))
            try #require(T.lsb.quotient (2) == Fallible(0))
            try #require(T.lsb.remainder(2) == 1)
        }
    }
    
    @Test(
        "BinaryInteger/values: msb",
        Tag.List.tags(.generic),
        arguments: typesAsSystemsInteger
    )   func msb(type: any SystemsInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            try #require(T.msb.msb == Bit.one)
            try #require(T.msb.count( Bit.one) == Count(1))
            try #require(T.msb.times(2).error)
        }
    }
    
    @Test(
        "BinaryInteger/values: size of BinaryInteger",
        Tag.List.tags(.generic),
        arguments: typesAsSystemsInteger
    )   func sizeOfBinaryInteger(type: any BinaryInteger.Type) throws {
        
        try whereIs(source: type, destination: IX.self)
        try whereIs(source: type, destination: UX.self)
        
        func whereIs<T, U>(source: T.Type, destination: U.Type) throws where T: BinaryInteger, U: SystemsInteger<UX.BitPattern> {
            if  T.isArbitrary {
                try #require(U(size: T.self) == nil)
            }   else {
                try #require(U(size: T.self).map(Count.init(raw:)) == T.size)
            }
        }
    }
    
    @Test(
        "BinaryInteger/values: size of SystemsInteger",
        Tag.List.tags(.generic),
        arguments: typesAsSystemsInteger
    )   func sizeOfSystemsInteger(type: any SystemsInteger.Type) throws {
        
        try whereIs(source: type, destination: IX.self)
        try whereIs(source: type, destination: UX.self)
        
        func whereIs<T, U>(source: T.Type, destination: U.Type) throws where T: SystemsInteger, U: SystemsInteger<UX.BitPattern> {
            try #require(Count(raw: U(size: T.self)) == T.size)
        }
    }
}

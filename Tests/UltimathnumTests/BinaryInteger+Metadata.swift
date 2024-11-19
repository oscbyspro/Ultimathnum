//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Metadata
//*============================================================================*

@Suite(.tags(.documentation)) struct BinaryIntegerTestsOnMetadata {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/metadata: mode",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func modes(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            #expect( T.isSigned == (T.mode == Signedness  .signed))
            #expect(!T.isSigned == (T.mode == Signedness.unsigned))
        }
    }
    
    @Test(
        "BinaryInteger/metadata: size",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func sizes(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            #expect(T.size.isPowerOf2)
            #expect(T.size >= T.Element  .size)
            #expect(T.size == T.Magnitude.size)
            #expect(T.size == T.Signitude.size)
            
            Ɣexpect(MemoryLayout<T>.self, equals: MemoryLayout<T.Magnitude>.self)
            Ɣexpect(MemoryLayout<T>.self, equals: MemoryLayout<T.Signitude>.self)
            
            if  let size = IX(size: T.self) {
                #expect(size == IX(MemoryLayout<T>.size  ) * 8)
                #expect(size == IX(MemoryLayout<T>.stride) * 8)
                
                #expect(MemoryLayout<T>.size     .isMultiple(of: MemoryLayout<T.Element>.size     ))
                #expect(MemoryLayout<T>.stride   .isMultiple(of: MemoryLayout<T.Element>.stride   ))
                #expect(MemoryLayout<T>.alignment.isMultiple(of: MemoryLayout<T.Element>.alignment))
            }   else {
                #expect(T.size == Count.infinity)
            }
        }
    }
    
    @Test(
        "BinaryInteger/metadata: quadrants",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func quadrants(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            #expect( T.isArbitrary == (T.self is any  ArbitraryInteger.Type))
            #expect(!T.isArbitrary == (T.self is any    SystemsInteger.Type))
            #expect( T.isEdgy      == (T.self is any       EdgyInteger.Type))
            #expect(!T.isEdgy      == (T.self is any (ArbitraryInteger &   SignedInteger).Type))
            #expect( T.isFinite    == (T.self is any     FiniteInteger.Type))
            #expect(!T.isFinite    == (T.self is any (ArbitraryInteger & UnsignedInteger).Type))
            #expect( T.isSigned    == (T.self is any     SignedInteger.Type))
            #expect(!T.isSigned    == (T.self is any   UnsignedInteger.Type))
            
            whereIs(T.Element  .self, isArbitrary: false, isEdgy: true,   isFinite: true, isSigned: T.isSigned)
            whereIs(T.Magnitude.self, isArbitrary: T.isArbitrary, isEdgy: true, isFinite: !T.isArbitrary, isSigned: false)
            whereIs(T.Signitude.self, isArbitrary: T.isArbitrary, isEdgy: !T.isArbitrary, isFinite: true, isSigned: true)
        }
        
        func whereIs<T>(_ type: T.Type, isArbitrary: Bool, isEdgy: Bool, isFinite: Bool, isSigned: Bool) where T: BinaryInteger {
            #expect( T.isArbitrary == isArbitrary)
            #expect( T.isEdgy      == isEdgy     )
            #expect( T.isFinite    == isFinite   )
            #expect( T.isSigned    == isSigned   )
        }
    }
}

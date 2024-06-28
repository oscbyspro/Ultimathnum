//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Shift
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testShift() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self)  .upshiftRepeatingBit()
            IntegerInvariants(T.self).downshiftRepeatingBit()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Ascending
    //=------------------------------------------------------------------------=
    
    func testUpshift() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            //=----------------------------------=
            for value in [large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                Test().upshift(value, 000, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix & ~T(0x0000))
                Test().upshift(value, 001, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0) ^ appendix & ~T(0x0001))
                Test().upshift(value, 002, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0) ^ appendix & ~T(0x0003))
                Test().upshift(value, 003, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F978F80) ^ appendix & ~T(0x0007))
                Test().upshift(value, 004, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00) ^ appendix & ~T(0x000F))
                Test().upshift(value, 005, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E00) ^ appendix & ~T(0x001F))
                Test().upshift(value, 006, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C00) ^ appendix & ~T(0x003F))
                Test().upshift(value, 007, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978F800) ^ appendix & ~T(0x007F))
                Test().upshift(value, 008, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F000) ^ appendix & ~T(0x00FF))
                Test().upshift(value, 009, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E000) ^ appendix & ~T(0x01FF))
                Test().upshift(value, 010, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C000) ^ appendix & ~T(0x03FF))
                Test().upshift(value, 011, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F8000) ^ appendix & ~T(0x07FF))
                Test().upshift(value, 012, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0000) ^ appendix & ~T(0x0FFF))
                Test().upshift(value, 013, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0000) ^ appendix & ~T(0x1FFF))
                Test().upshift(value, 014, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0000) ^ appendix & ~T(0x3FFF))
                Test().upshift(value, 015, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F80000) ^ appendix & ~T(0x7FFF))
                Test().upshift(value, 016, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00000) ^ appendix & ~T(0xFFFF))
                
                infinite: if !T.isSigned {
                    for distance: T in (0...9).lazy.map(~) {
                        Test().upshift(value, distance, T.zero)
                    }
                }
            }
        }
                
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testUpshiftByDistanceTooLargeToAllocateAsIXL() throws {
        throw XCTSkip("req. crash tests")
    }
    
    func testUpshiftByDistanceTooLargeToAllocateAsUXL() throws {
        throw XCTSkip("req. crash tests")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Descending
    //=------------------------------------------------------------------------=
    
    func testDownshift() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            //=----------------------------------=
            for value in [large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                Test().downshift(value, 00000, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix)
                Test().downshift(value, 00001, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F8) ^ appendix)
                Test().downshift(value, 00002, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C) ^ appendix)
                Test().downshift(value, 00003, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E) ^ appendix)
                Test().downshift(value, 00004, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F) ^ appendix)
                Test().downshift(value, 00005, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F) ^ appendix)
                Test().downshift(value, 00006, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7) ^ appendix)
                Test().downshift(value, 00007, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3) ^ appendix)
                Test().downshift(value, 00008, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1) ^ appendix)
                Test().downshift(value, 00009, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978) ^ appendix)
                Test().downshift(value, 00010, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC) ^ appendix)
                Test().downshift(value, 00011, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E) ^ appendix)
                Test().downshift(value, 00012, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F) ^ appendix)
                Test().downshift(value, 00013, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F97) ^ appendix)
                Test().downshift(value, 00014, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCB) ^ appendix)
                Test().downshift(value, 00015, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5) ^ appendix)
                Test().downshift(value, 00016, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2) ^ appendix)
                
                Test().downshift(value, 00126, T(0x00000000000000000000000000000003) ^ appendix)
                Test().downshift(value, 00127, T(0x00000000000000000000000000000001) ^ appendix)
                Test().downshift(value, 00128, T(0x00000000000000000000000000000000) ^ appendix)
                Test().downshift(value, 00129, T(0x00000000000000000000000000000000) ^ appendix)
                
                Test().downshift(value, 99999, T(0x00000000000000000000000000000000) ^ appendix)
                Test().downshift(value, large, T(0x00000000000000000000000000000000) ^ appendix)
                
                infinite: if !T.isSigned {
                    for distance: T in (0...9).lazy.map(~) {
                        Test().downshift(value, distance, appendix)
                    }
                }
            }
        }
                
        for types in Self.types {
            whereIs(types)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpshiftAtEdgeOfElement() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            compact: do {
                Test().upshift( T(IX.max >> 5), 4 as T,  T(IX.max >> 5)  * 16)
                Test().upshift( T(IX.max >> 5), 5 as T,  T(IX.max >> 5)  * 32)
                Test().upshift( T(IX.max >> 5), 6 as T,  T(IX.max >> 5)  * 64)

                Test().upshift(~T(IX.max >> 5), 4 as T, ~T(IX.max >> 5) &* 16)
                Test().upshift(~T(IX.max >> 5), 5 as T, ~T(IX.max >> 5) &* 32)
                Test().upshift(~T(IX.max >> 5), 6 as T, ~T(IX.max >> 5) &* 64)
            }
            
            extended: do {
                Test().upshift( T(UX.max >> 5), 4 as T,  T(UX.max >> 5)  * 16)
                Test().upshift( T(UX.max >> 5), 5 as T,  T(UX.max >> 5)  * 32)
                Test().upshift( T(UX.max >> 5), 6 as T,  T(UX.max >> 5)  * 64)

                Test().upshift(~T(UX.max >> 5), 4 as T, ~T(UX.max >> 5) &* 16)
                Test().upshift(~T(UX.max >> 5), 5 as T, ~T(UX.max >> 5) &* 32)
                Test().upshift(~T(UX.max >> 5), 6 as T, ~T(UX.max >> 5) &* 64)
            }
        }
    
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testDownshiftByNonappendix() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().downshift( T(I8 .max),  6 as T,  1 as T)
            Test().downshift( T(I8 .max),  7 as T,  0 as T)
            Test().downshift( T(I8 .max),  8 as T,  0 as T)

            Test().downshift(~T(I8 .max),  6 as T, ~1 as T)
            Test().downshift(~T(I8 .max),  7 as T, ~0 as T)
            Test().downshift(~T(I8 .max),  8 as T, ~0 as T)
        
            Test().downshift( T(U8 .msb),  7 as T,  1 as T)
            Test().downshift( T(U8 .msb),  8 as T,  0 as T)
            Test().downshift( T(U8 .msb),  9 as T,  0 as T)

            Test().downshift(~T(U8 .msb),  7 as T, ~1 as T)
            Test().downshift(~T(U8 .msb),  8 as T, ~0 as T)
            Test().downshift(~T(U8 .msb),  9 as T, ~0 as T)
            
            Test().downshift( T(I64.max), 62 as T,  1 as T)
            Test().downshift( T(I64.max), 63 as T,  0 as T)
            Test().downshift( T(I64.max), 64 as T,  0 as T)

            Test().downshift(~T(I64.max), 62 as T, ~1 as T)
            Test().downshift(~T(I64.max), 63 as T, ~0 as T)
            Test().downshift(~T(I64.max), 64 as T, ~0 as T)
            
            Test().downshift( T(U64.msb), 63 as T,  1 as T)
            Test().downshift( T(U64.msb), 64 as T,  0 as T)
            Test().downshift( T(U64.msb), 65 as T,  0 as T)

            Test().downshift(~T(U64.msb), 63 as T, ~1 as T)
            Test().downshift(~T(U64.msb), 64 as T, ~0 as T)
            Test().downshift(~T(U64.msb), 65 as T, ~0 as T)
        }
    
        for type in Self.types {
            whereIs(type)
        }
    }
}

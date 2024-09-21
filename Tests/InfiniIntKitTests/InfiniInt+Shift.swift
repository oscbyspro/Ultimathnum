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
    
    func testUpshift() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            //=----------------------------------=
            let large: T = 0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0
            //=----------------------------------=
            for value: T in [large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                Test().upshift(value, 000 as T, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix & ~T(0x0000))
                Test().upshift(value, 001 as T, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0) ^ appendix & ~T(0x0001))
                Test().upshift(value, 002 as T, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0) ^ appendix & ~T(0x0003))
                Test().upshift(value, 003 as T, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F978F80) ^ appendix & ~T(0x0007))
                Test().upshift(value, 004 as T, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00) ^ appendix & ~T(0x000F))
                Test().upshift(value, 005 as T, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E00) ^ appendix & ~T(0x001F))
                Test().upshift(value, 006 as T, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C00) ^ appendix & ~T(0x003F))
                Test().upshift(value, 007 as T, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978F800) ^ appendix & ~T(0x007F))
                Test().upshift(value, 008 as T, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F000) ^ appendix & ~T(0x00FF))
                Test().upshift(value, 009 as T, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E000) ^ appendix & ~T(0x01FF))
                Test().upshift(value, 010 as T, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C000) ^ appendix & ~T(0x03FF))
                Test().upshift(value, 011 as T, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F8000) ^ appendix & ~T(0x07FF))
                Test().upshift(value, 012 as T, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0000) ^ appendix & ~T(0x0FFF))
                Test().upshift(value, 013 as T, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0000) ^ appendix & ~T(0x1FFF))
                Test().upshift(value, 014 as T, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0000) ^ appendix & ~T(0x3FFF))
                Test().upshift(value, 015 as T, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F80000) ^ appendix & ~T(0x7FFF))
                Test().upshift(value, 016 as T, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00000) ^ appendix & ~T(0xFFFF))
                
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
    
    func testDownshiftByMoreThanMaxSignedWordIsUpflush() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            //=----------------------------------=
            let large: T = 0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0
            //=----------------------------------=
            for value: T in [~2, ~1, ~0, 0, 1, 2, large, ~large] {
                Test().upshift(value, large,         T.zero)
                Test().upshift(value, T(IX.max) + 1, T.zero)
                Test().upshift(value, T(IX.max) + 2, T.zero)
                Test().upshift(value, T(IX.max) + 3, T.zero)
                Test().upshift(value, T(IX.max) + 4, T.zero)
                
                if  T.isSigned {
                    Test().downshift(value, T(IX.min),     T.zero)
                    Test().downshift(value, T(IX.min) - 1, T.zero)
                    Test().downshift(value, T(IX.min) - 2, T.zero)
                    Test().downshift(value, T(IX.min) - 3, T.zero)
                }   else {
                    Test().upshift(value, large.toggled(),    T.zero)
                    Test().upshift(value, large.complement(), T.zero)
                }
            }
        }
                
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testDownshift() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            //=----------------------------------=
            let large: T = 0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0
            //=----------------------------------=
            for value: T in [large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                Test().downshift(value, 00000 as T, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix)
                Test().downshift(value, 00001 as T, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F8) ^ appendix)
                Test().downshift(value, 00002 as T, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C) ^ appendix)
                Test().downshift(value, 00003 as T, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E) ^ appendix)
                Test().downshift(value, 00004 as T, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F) ^ appendix)
                Test().downshift(value, 00005 as T, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F) ^ appendix)
                Test().downshift(value, 00006 as T, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7) ^ appendix)
                Test().downshift(value, 00007 as T, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3) ^ appendix)
                Test().downshift(value, 00008 as T, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1) ^ appendix)
                Test().downshift(value, 00009 as T, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978) ^ appendix)
                Test().downshift(value, 00010 as T, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC) ^ appendix)
                Test().downshift(value, 00011 as T, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E) ^ appendix)
                Test().downshift(value, 00012 as T, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F) ^ appendix)
                Test().downshift(value, 00013 as T, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F97) ^ appendix)
                Test().downshift(value, 00014 as T, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCB) ^ appendix)
                Test().downshift(value, 00015 as T, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5) ^ appendix)
                Test().downshift(value, 00016 as T, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2) ^ appendix)
                
                Test().downshift(value, 00126 as T, T(0x00000000000000000000000000000003) ^ appendix)
                Test().downshift(value, 00127 as T, T(0x00000000000000000000000000000001) ^ appendix)
                Test().downshift(value, 00128 as T, T(0x00000000000000000000000000000000) ^ appendix)
                Test().downshift(value, 00129 as T, T(0x00000000000000000000000000000000) ^ appendix)
                
                Test().downshift(value, 99999 as T, T(0x00000000000000000000000000000000) ^ appendix)
                Test().downshift(value, large as T, T(0x00000000000000000000000000000000) ^ appendix)
                
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
    
    func testDownshiftByMoreThanMaxSignedWordIsDownflush() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            //=----------------------------------=
            let large: T = 0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0
            //=----------------------------------=
            for value: T in [~2, ~1, ~0, 0, 1, 2, large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                Test().downshift(value, large,         appendix)
                Test().downshift(value, T(IX.max) + 1, appendix)
                Test().downshift(value, T(IX.max) + 2, appendix)
                Test().downshift(value, T(IX.max) + 3, appendix)
                Test().downshift(value, T(IX.max) + 4, appendix)
                
                if  T.isSigned {
                    Test().upshift(value, T(IX.min),     appendix)
                    Test().upshift(value, T(IX.min) - 1, appendix)
                    Test().upshift(value, T(IX.min) - 2, appendix)
                    Test().upshift(value, T(IX.min) - 3, appendix)
                }   else {
                    Test().downshift(value, large.toggled(),    appendix)
                    Test().downshift(value, large.complement(), appendix)
                }
            }
        }
                
        for type in Self.types {
            whereIs(type)
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
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
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
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
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

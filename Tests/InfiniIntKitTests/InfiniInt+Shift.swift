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
    // MARK: Tests x Ascending
    //=------------------------------------------------------------------------=
    
    #warning("TODO")
    func testUpshift() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            //=----------------------------------=
            for value in [large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                //Test().shift(value, 000, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix & ~T(0x0000), .left,  .smart)
                //Test().shift(value, 001, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0) ^ appendix & ~T(0x0001), .left,  .smart)
                //Test().shift(value, 002, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0) ^ appendix & ~T(0x0003), .left,  .smart)
                //Test().shift(value, 003, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F978F80) ^ appendix & ~T(0x0007), .left,  .smart)
                //Test().shift(value, 004, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00) ^ appendix & ~T(0x000F), .left,  .smart)
                //Test().shift(value, 005, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E00) ^ appendix & ~T(0x001F), .left,  .smart)
                //Test().shift(value, 006, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C00) ^ appendix & ~T(0x003F), .left,  .smart)
                //Test().shift(value, 007, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978F800) ^ appendix & ~T(0x007F), .left,  .smart)
                //Test().shift(value, 008, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F000) ^ appendix & ~T(0x00FF), .left,  .smart)
                //Test().shift(value, 009, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E000) ^ appendix & ~T(0x01FF), .left,  .smart)
                //Test().shift(value, 010, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C000) ^ appendix & ~T(0x03FF), .left,  .smart)
                //Test().shift(value, 011, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F8000) ^ appendix & ~T(0x07FF), .left,  .smart)
                //Test().shift(value, 012, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0000) ^ appendix & ~T(0x0FFF), .left,  .smart)
                //Test().shift(value, 013, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0000) ^ appendix & ~T(0x1FFF), .left,  .smart)
                //Test().shift(value, 014, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0000) ^ appendix & ~T(0x3FFF), .left,  .smart)
                //Test().shift(value, 015, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F80000) ^ appendix & ~T(0x7FFF), .left,  .smart)
                //Test().shift(value, 016, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00000) ^ appendix & ~T(0xFFFF), .left,  .smart)
            }
        }
                
        for element in elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Descending
    //=------------------------------------------------------------------------=
    
    #warning("TODO")
    func testDownshift() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            //=----------------------------------=
            for value in [large, ~large] {
                let appendix = T(repeating: value.appendix)
                
                //Test().shift(value, 000, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix, .right, .smart)
                //Test().shift(value, 001, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F8) ^ appendix, .right, .smart)
                //Test().shift(value, 002, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C) ^ appendix, .right, .smart)
                //Test().shift(value, 003, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E) ^ appendix, .right, .smart)
                //Test().shift(value, 004, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F) ^ appendix, .right, .smart)
                //Test().shift(value, 005, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F) ^ appendix, .right, .smart)
                //Test().shift(value, 006, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7) ^ appendix, .right, .smart)
                //Test().shift(value, 007, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3) ^ appendix, .right, .smart)
                //Test().shift(value, 008, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1) ^ appendix, .right, .smart)
                //Test().shift(value, 009, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978) ^ appendix, .right, .smart)
                //Test().shift(value, 010, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC) ^ appendix, .right, .smart)
                //Test().shift(value, 011, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E) ^ appendix, .right, .smart)
                //Test().shift(value, 012, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F) ^ appendix, .right, .smart)
                //Test().shift(value, 013, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F97) ^ appendix, .right, .smart)
                //Test().shift(value, 014, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCB) ^ appendix, .right, .smart)
                //Test().shift(value, 015, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5) ^ appendix, .right, .smart)
                //Test().shift(value, 016, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2) ^ appendix, .right, .smart)
                
                //Test().shift(value, 126, T(0x00000000000000000000000000000003) ^ appendix, .right, .smart)
                //Test().shift(value, 127, T(0x00000000000000000000000000000001) ^ appendix, .right, .smart)
                //Test().shift(value, 128, T(0x00000000000000000000000000000000) ^ appendix, .right, .smart)
                //Test().shift(value, 129, T(0x00000000000000000000000000000000) ^ appendix, .right, .smart)
            }
        }
                
        for element in elements {
            whereTheBaseTypeIs(element)
        }
    }
}

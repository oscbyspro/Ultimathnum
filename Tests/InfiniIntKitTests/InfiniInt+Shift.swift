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
    
    func testUpshift() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            //=----------------------------------=
            for value in [large, ~large] {
                let appendix  = T(repeating: value.appendix)
                let direction = Test.ShiftDirection.left
                let semantics = Test.ShiftSemantics.smart
                
                Test().shift(value, 000, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix & ~T(0x0000), direction, semantics)
                Test().shift(value, 001, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0) ^ appendix & ~T(0x0001), direction, semantics)
                Test().shift(value, 002, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0) ^ appendix & ~T(0x0003), direction, semantics)
                Test().shift(value, 003, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F978F80) ^ appendix & ~T(0x0007), direction, semantics)
                Test().shift(value, 004, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00) ^ appendix & ~T(0x000F), direction, semantics)
                Test().shift(value, 005, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E00) ^ appendix & ~T(0x001F), direction, semantics)
                Test().shift(value, 006, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C00) ^ appendix & ~T(0x003F), direction, semantics)
                Test().shift(value, 007, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978F800) ^ appendix & ~T(0x007F), direction, semantics)
                Test().shift(value, 008, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F000) ^ appendix & ~T(0x00FF), direction, semantics)
                Test().shift(value, 009, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E000) ^ appendix & ~T(0x01FF), direction, semantics)
                Test().shift(value, 010, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C000) ^ appendix & ~T(0x03FF), direction, semantics)
                Test().shift(value, 011, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F8000) ^ appendix & ~T(0x07FF), direction, semantics)
                Test().shift(value, 012, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0000) ^ appendix & ~T(0x0FFF), direction, semantics)
                Test().shift(value, 013, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E0000) ^ appendix & ~T(0x1FFF), direction, semantics)
                Test().shift(value, 014, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C0000) ^ appendix & ~T(0x3FFF), direction, semantics)
                Test().shift(value, 015, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F80000) ^ appendix & ~T(0x7FFF), direction, semantics)
                Test().shift(value, 016, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F00000) ^ appendix & ~T(0xFFFF), direction, semantics)
                
                infinite: if !T.isSigned {
                    for distance: T in (0...9).lazy.map(~) {
                        Test().shift(value, distance, 00000000, direction, semantics)
                    }
                }
            }
        }
                
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testUpshiftByDistanceTooLargeToAllocateAsIXL() throws {
        throw XCTSkip("Test(\"one bit more than max body size per protocol\").crash(IXL(1) << IXL(IX.max))")
    }
    
    func testUpshiftByDistanceTooLargeToAllocateAsUXL() throws {
        throw XCTSkip("Test(\"one bit more than max body size per protocol\").crash(UXL(1) << UXL(IX.max))")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Descending
    //=------------------------------------------------------------------------=
    
    func testDownshift() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            //=----------------------------------=
            for value in [large, ~large] {
                let appendix  = T(repeating: value.appendix)
                let direction = Test.ShiftDirection.right
                let semantics = Test.ShiftSemantics.smart
                
                Test().shift(value, 00000, T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0) ^ appendix, direction, semantics)
                Test().shift(value, 00001, T(0x7FFF7EFE7DFD7CFC7BFB7AFA79F978F8) ^ appendix, direction, semantics)
                Test().shift(value, 00002, T(0x3FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7C) ^ appendix, direction, semantics)
                Test().shift(value, 00003, T(0x1FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3E) ^ appendix, direction, semantics)
                Test().shift(value, 00004, T(0x0FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F) ^ appendix, direction, semantics)
                Test().shift(value, 00005, T(0x07FFF7EFE7DFD7CFC7BFB7AFA79F978F) ^ appendix, direction, semantics)
                Test().shift(value, 00006, T(0x03FFFBF7F3EFEBE7E3DFDBD7D3CFCBC7) ^ appendix, direction, semantics)
                Test().shift(value, 00007, T(0x01FFFDFBF9F7F5F3F1EFEDEBE9E7E5E3) ^ appendix, direction, semantics)
                Test().shift(value, 00008, T(0x00FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1) ^ appendix, direction, semantics)
                Test().shift(value, 00009, T(0x007FFF7EFE7DFD7CFC7BFB7AFA79F978) ^ appendix, direction, semantics)
                Test().shift(value, 00010, T(0x003FFFBF7F3EFEBE7E3DFDBD7D3CFCBC) ^ appendix, direction, semantics)
                Test().shift(value, 00011, T(0x001FFFDFBF9F7F5F3F1EFEDEBE9E7E5E) ^ appendix, direction, semantics)
                Test().shift(value, 00012, T(0x000FFFEFDFCFBFAF9F8F7F6F5F4F3F2F) ^ appendix, direction, semantics)
                Test().shift(value, 00013, T(0x0007FFF7EFE7DFD7CFC7BFB7AFA79F97) ^ appendix, direction, semantics)
                Test().shift(value, 00014, T(0x0003FFFBF7F3EFEBE7E3DFDBD7D3CFCB) ^ appendix, direction, semantics)
                Test().shift(value, 00015, T(0x0001FFFDFBF9F7F5F3F1EFEDEBE9E7E5) ^ appendix, direction, semantics)
                Test().shift(value, 00016, T(0x0000FFFEFDFCFBFAF9F8F7F6F5F4F3F2) ^ appendix, direction, semantics)
                
                Test().shift(value, 00126, T(0x00000000000000000000000000000003) ^ appendix, direction, semantics)
                Test().shift(value, 00127, T(0x00000000000000000000000000000001) ^ appendix, direction, semantics)
                Test().shift(value, 00128, T(0x00000000000000000000000000000000) ^ appendix, direction, semantics)
                Test().shift(value, 00129, T(0x00000000000000000000000000000000) ^ appendix, direction, semantics)
                
                Test().shift(value, 99999, T(0x00000000000000000000000000000000) ^ appendix, direction, semantics)
                Test().shift(value, large, T(0x00000000000000000000000000000000) ^ appendix, direction, semantics)
                
                infinite: if !T.isSigned {
                    for distance: T in (0...9).lazy.map(~) {
                        Test().shift(value, distance, appendix, direction, semantics)
                    }
                }
            }
        }
                
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}

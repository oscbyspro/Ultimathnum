//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fuzzer Int
//*============================================================================*

final class FuzzerIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMetadata() {
        Test().yay(FuzzerInt.self as Any is any Randomness.Type)
        Test().yay(FuzzerInt.Stdlib.self as Any is any Swift.RandomNumberGenerator.Type)
    }
    
    func testSeeds() {
        var randomness = FuzzerInt(seed: 0)
        
        func expect(_ expectation: U64, line: UInt = #line) {
            var copy    = randomness
            var stdlibX = randomness.stdlib
            var stdlibY = randomness.stdlib()
            
            Test(line: line).same(randomness, copy)
            Test(line: line).same(stdlibX, stdlibY)
            
            Test(line: line).same(randomness .next(),       (expectation), "normal")
            Test(line: line).same(copy.stdlib.next(), UInt64(expectation), "stdlib modify")
            Test(line: line).same(((stdlibX)).next(), UInt64(expectation), "stdlib mutating read")
            Test(line: line).same(((stdlibY)).next(), UInt64(expectation), "stdlib consuming get")
            
            Test(line: line).same(randomness, copy)
            Test(line: line).same(stdlibX, stdlibY)
        }
        
        randomness = .init(seed:  0)
        expect(16294208416658607535)
        expect(07960286522194355700)
        expect(00487617019471545679)
        expect(17909611376780542444)
        
        randomness = .init(seed:  1)
        expect(10451216379200822465)
        expect(13757245211066428519)
        expect(17911839290282890590)
        expect(08196980753821780235)
        
        randomness = .init(seed: ~1)
        expect(17519071339639777313)
        expect(13427082724269423081)
        expect(15047954047655532813)
        expect(02229658653670313015)
        
        randomness = .init(seed: ~0)
        expect(16490336266968443936)
        expect(16834447057089888969)
        expect(04048727598324417001)
        expect(07862637804313477842)
        
        randomness = .init(seed:  0)
        var unique = Set<U64>()
        
        for _ in 0 ..< 10000 {
            unique.insert(randomness.next())
        }
        
        Test().same(unique.count, 10000)
    }
}

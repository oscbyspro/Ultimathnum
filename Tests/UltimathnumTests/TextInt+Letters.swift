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
// MARK: * Text Int x Letters
//*============================================================================*

@Suite(Tag.List.tags(.exhaustive), ParallelizationTrait.serialized)
struct TextIntTestsOnLetters {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("TextInt.Letters: start", arguments: [
            
        (instance: TextInt.Letters.lowercase, start: 97 as U8),
        (instance: TextInt.Letters.uppercase, start: 65 as U8),
            
    ] as [(TextInt.Letters, U8)])
    func start(instance: TextInt.Letters, start: U8) throws {
        #expect(instance.start == start)
        
        let numerals = try TextInt.Numerals(radix: 36, letters: instance)
        #expect(try numerals.decode(start) == 10)
        #expect(try numerals.encode(10) == start)
    }
    
    @Test("TextInt.Letters: uppercase", arguments: [
            
        (instance: TextInt.Letters.lowercase, uppercase: false),
        (instance: TextInt.Letters.uppercase, uppercase: true ),
            
    ] as [(TextInt.Letters, Bool)])
    func uppercase(instance: TextInt.Letters, uppercase: Bool) {
        #expect((instance == TextInt.Letters (uppercase:    uppercase)))
        #expect((instance == TextInt.Letters .uppercase) == uppercase)
    }
}

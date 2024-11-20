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

@Suite(.serialized) struct TextIntTestsOnLetters {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/letters: start",
        Tag.List.tags(.exhaustive),
        arguments: Array<(TextInt.Letters, U8)>.infer([
            
        (TextInt.Letters.lowercase, U8(97)),
        (TextInt.Letters.uppercase, U8(65)),
            
    ])) func start(
        instance: TextInt.Letters, start: U8
    )   throws {
        
        #expect(instance.start == start)
        let numerals = try #require(TextInt.Numerals(radix: 36, letters: instance))
        #expect(numerals.decode(start) == 10)
        #expect(numerals.encode(10) == start)
    }
    
    @Test(
        "TextInt/letters: init(uppercase:)",
        Tag.List.tags(.exhaustive),
        arguments: Array<(TextInt.Letters, Bool)>.infer([
            
        (TextInt.Letters.lowercase, false),
        (TextInt.Letters.uppercase, true ),
            
    ])) func uppercase(
        instance: TextInt.Letters, uppercase: Bool
    )   throws {
        
        #expect((instance == TextInt.Letters (uppercase:    uppercase)))
        #expect((instance == TextInt.Letters .uppercase) == uppercase)
    }
}

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
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Factorial
//*============================================================================*

@Suite("BinaryInteger/factorial()", .serialized)
struct BinaryIntegerTestsOnFactorial {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("element at small natural index", arguments: [
        
        (index:  0 as U8, element:                                    1 as IXL),
        (index:  1 as U8, element:                                    1 as IXL),
        (index:  2 as U8, element:                                    2 as IXL),
        (index:  3 as U8, element:                                    6 as IXL),
        (index:  4 as U8, element:                                   24 as IXL),
        (index:  5 as U8, element:                                  120 as IXL),
        (index:  6 as U8, element:                                  720 as IXL),
        (index:  7 as U8, element:                                 5040 as IXL),
        (index:  8 as U8, element:                                40320 as IXL),
        (index:  9 as U8, element:                               362880 as IXL),
        (index: 10 as U8, element:                              3628800 as IXL),
        (index: 11 as U8, element:                             39916800 as IXL),
        (index: 12 as U8, element:                            479001600 as IXL),
        (index: 13 as U8, element:                           6227020800 as IXL),
        (index: 14 as U8, element:                          87178291200 as IXL),
        (index: 15 as U8, element:                        1307674368000 as IXL),
        (index: 16 as U8, element:                       20922789888000 as IXL),
        (index: 17 as U8, element:                      355687428096000 as IXL),
        (index: 18 as U8, element:                     6402373705728000 as IXL),
        (index: 19 as U8, element:                   121645100408832000 as IXL),
        (index: 20 as U8, element:                  2432902008176640000 as IXL),
        (index: 21 as U8, element:                 51090942171709440000 as IXL),
        (index: 22 as U8, element:               1124000727777607680000 as IXL),
        (index: 23 as U8, element:              25852016738884976640000 as IXL),
        (index: 24 as U8, element:             620448401733239439360000 as IXL),
        (index: 25 as U8, element:           15511210043330985984000000 as IXL),
        (index: 26 as U8, element:          403291461126605635584000000 as IXL),
        (index: 27 as U8, element:        10888869450418352160768000000 as IXL),
        (index: 28 as U8, element:       304888344611713860501504000000 as IXL),
        (index: 29 as U8, element:      8841761993739701954543616000000 as IXL),
        (index: 30 as U8, element:    265252859812191058636308480000000 as IXL),
        (index: 31 as U8, element:   8222838654177922817725562880000000 as IXL),
        (index: 32 as U8, element: 263130836933693530167218012160000000 as IXL),
        
    ] as [(index: U8, element: IXL)])
    func elementAtSmallNaturalIndex(index: U8, element: IXL) throws {
        for type in typesAsBinaryInteger {
            whereIs(type)
        }
                
        for type in typesAsBinaryIntegerAsUnsigned {
            AsUnsignedInteger(type)
        }
                
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #expect(T(clamping: index).factorial() as Optional == T.exactly(element))
        }
        
        func AsUnsignedInteger<T>(_ type: T.Type) where T: UnsignedInteger {
            #expect(T(clamping: index).factorial() as Fallible == T.exactly(element))
        }
    }
    
    /// - Seealso: https://www.wolframalpha.com/input?i=1000%21
    /// - Seealso: https://www.wolframalpha.com/input?i=1024%21
    @Test("element at large natural index", arguments: [
        
        (index: IXL(1000), element: IXL("""
        0000000000000000000000000000000000000000000000000000000040238726\
        0077093773543702433923003985719374864210714632543799910429938512\
        3986290205920442084869694048004799886101971960586316668729948085\
        5890132382966994459099742450408707375991882362772718873251977950\
        5950995276120874975462497043601418278094646496291056393887437886\
        4873371191810458257836478499770124766328898359557354325131853239\
        5846307555740911426241747434934755342864657661166779739666882029\
        1207379143853719588249808126867838374559731746136085379534524221\
        5865932019280908782973084313928444032812315586110369768013573042\
        1616874760967587134831202547858932076716913244842623613141250878\
        0208000261683151027341827977704784635868170164365024153691398281\
        2648102130927612448963599287051149649754199093422215668325720808\
        2133318611681155361583654698404670897560290095053761647584772842\
        1889679646244945160765353408198901385442487984959953319101723355\
        5566021394503997362807501378376153071277619268490343526252000158\
        8853514733161170210396817592151090778801939317811419454525722386\
        5541461062892187960223838971476088506276862967146674697562911234\
        0824392081601537808898939645182632436716167621791689097799119037\
        5403127462228998800519544441428201218736174599264295658174662830\
        2955570299024324153181617210465832036786906117260158783520751516\
        2842255402651704833042261439742869330616908979684825901254583271\
        6822645806652676995865268227280707578139185817888965220816434834\
        4825993266043367660176999612831860788386150279465955131156552036\
        0939881806121385586003014356945272242063446317974605946825731037\
        9008402443243846565724501440282188525247093519062092902313649327\
        3497565513958720559654228749774011413346962715422845862377387538\
        2304838656889764619273838149001407673104466402598994902222217659\
        0433990188601856652648506179970235619389701786004081188972991831\
        1021171229845901641921068884387121855646124960798722908519296819\
        3723886426148396573822911231250241866493531439701374285319266498\
        7533721894069428143411852015801412334482801505139969429015348307\
        7644569099073152433278288269864602789864321139083506217095002597\
        3898635542771967428222487575867657523442202075736305694988250879\
        6892816275384886339690995982628095612145099487170124451646126037\
        9029309120889086942028510640182154399457156805941872748998094254\
        7421735824010636774045957417851608292301353580818400969963725242\
        3056085590370062427124341690900415369010593398383577793941097002\
        7753472000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)!),
        
        (index: IXL(1024), element: IXL("""
        0000000000000000000000000000000000000000000000005418528796058857\
        2830769219446838547380015539635380134444828702706832106120733766\
        0373314098413621458671907918845708980753931994165770187368260454\
        1333337219391083675280127649937697682925169378911657556806596637\
        4794731451840488667767255612518869433525121367727452196343077013\
        3713205796248433128870088436171654690237518390452944732277808402\
        9321587220618538061628060639254353108221868482392871302616909142\
        1136225114468471388858788162925210404629531594994390035788241024\
        3934315037444113890806181406210863953275235375885018598451582229\
        5996545585412427891309024869442986109231533075791316757451464363\
        0402489082044290773456182736903050225279692655307296737099075874\
        7793127635104702469889667961462133026237158973227857814631807156\
        4277676440645910850765647834563244577368538103369817760804987077\
        6704639427260534141677912569773337456803747518667626596166561588\
        4681450263337042522664141862157046825684773360944326737493676674\
        9150989537681129458316266438564790278163857302915426677256656422\
        7682605826439388451491197641967550929020859271315636298329098944\
        1052732125187249527501314071676405516936190781821236701912295767\
        3631170541265899299164820085157817519554669109028387292322245099\
        0638863814777125522778263132238575694881939365888990899367087451\
        6860653098411020299853816281564334981847105777839534742531499622\
        1034888075845137057698397639931039296650460461211666513451311495\
        1365740086905633486785988502560178728498256778731440721652427226\
        2997319791568603629406624740101482697559533155736658800562921274\
        6806572852015704019406922855578006114290557553245497940089398491\
        4681263986075008526329882022471958550534477371159065668282104141\
        7265040658600683844945104354998812886801316551551714673388323340\
        8517638197135913123725486737347835373163415173693875652128997265\
        9796490324120872734869069980299636926507008875838485454754227277\
        1024255049902319275830918157448205196421072837204937293516175341\
        9577754224531524422803913724077178916612030610402558300550338867\
        9005211602540874045462093838436763788665876991279092232371737134\
        3176067483352513629123362885893627132294183565884010418727869354\
        4390770852782885583084270904610750190071849331399155582127523923\
        2987978064963907533384571917382284050186957046362660023526558750\
        2335595489311637509380219119860471335771652403999403296360245577\
        2579636732866543489573257409997105671316232723457667619376514081\
        0399919363390828642051009857745452406810689739249313828736222625\
        7920000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)!),
        
    ] as [(index: IXL, element: IXL)])
    func elementAtLargeNaturalIndex(index: IXL, element: IXL) {
        for type in typesAsSystemsInteger {
            whereIs(type)
        }
        
        for type in typesAsSystemsIntegerAsUnsigned {
            AsUnsignedInteger(type)
        }
        
        whereIs(IXL.self)
        whereIs(UXL.self)
        AsUnsignedInteger(UXL.self)
                
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #expect(T(clamping: index).factorial() as Optional == T.exactly(element))
        }
                
        func AsUnsignedInteger<T>(_ type: T.Type) where T: UnsignedInteger {
            #expect(T(clamping: index).factorial() as Fallible == T.exactly(element))
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorial x Edge Cases
//*============================================================================*

@Suite("BinaryInteger/factorial() - edge cases", .tags(.documentation))
struct BinaryIntegerTestsOnFactorialEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("element at negative index is nil [uniform]", arguments: typesAsBinaryIntegerAsSigned, fuzzers)
    func elementAtNegativeIndexIsNil(type: any SignedInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SignedInteger {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            let expectation = Optional<Fallible<T>>.none
            
            #expect(low .factorial() == expectation)
            #expect(high.factorial() == expectation)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                #expect(random.isNegative)
                #expect(random.factorial() == expectation)
            }
        }
    }
    
    /// Here we check that the infinite even factors overshift the result.
    @Test("element at infinite index is zero with error [uniform]", arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers)
    func elementAtInfiniteIndexIsZeroWithError(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: ArbitraryIntegerAsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            let expectation = Optional(T.zero.veto())
            
            #expect(low .factorial() == expectation)
            #expect(high.factorial() == expectation)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                #expect(random.isInfinite)
                #expect(random.factorial() == expectation)
            }
        }
    }
    
    @Test("element at random index error propagation [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func elementAtRandomIndexErrorPropagation(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        if  let type = type as? any UnsignedInteger.Type {
            AsUnsignedInteger(type)
        }
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let index = T.entropic(through: Shift.max(or: 7), using: &randomness)
                let element: Optional<Fallible<T>> = index.factorial()
                for error in Bool.all {
                    #expect(index.veto(error).factorial() == element?.veto(error))
                }
            }
        }
        
        func AsUnsignedInteger<T>(_ type: T.Type) where T: UnsignedInteger {
            for _ in 0 ..< 32 {
                let index = T.entropic(through: Shift.max(or: 7), using: &randomness)
                let element: Fallible<T> = index.factorial()
                for error in Bool.all {
                    #expect(index.veto(error).factorial() == element.veto(error))
                }
            }
        }
    }
}

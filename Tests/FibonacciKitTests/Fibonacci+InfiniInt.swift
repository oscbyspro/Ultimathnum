//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import FibonacciKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci x Infinit Int
//*============================================================================*

extension FibonacciTests {

    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    private static let infiniIntList: [any BinaryInteger.Type] = [
        InfiniInt<IX >.self, InfiniInt<UX >.self,
        InfiniInt<I8 >.self, InfiniInt<U8 >.self,
        InfiniInt<I16>.self, InfiniInt<U16>.self,
        InfiniInt<I32>.self, InfiniInt<U32>.self,
        InfiniInt<I64>.self, InfiniInt<U64>.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInfiniInt() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Case<T>.checkInstancesNearZeroIndex(Test())
        }
        
        for type in Self.infiniIntList {
            whereIs(type)
        }
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=fibonnaci+28751
    func testInfiniIntIXLPrime3131() {
        guard let item = Test().success({ try Fibonacci<IXL>(28751) }) else { return }
        #if !DEBUG
        Case(item).checkMathInvariants()
        Case(item).checkTextInvariants()
        #endif
        Case(item).element(IXL("""
        0000000179539422936879670273043077421513074187637090531654188941\
        5741714251061429371751580439620520390780557350979774794868208366\
        4166176620878272615316694300157066431179767088884468131326626406\
        6006793087609312815351213411657546695669274095062698689154398219\
        4273493634687995463092807527082580641615117429769927175041405435\
        0295797490359697968749112307931392970248348413038891015623785621\
        6088847611043512273516649762447035351619033256347137730401912564\
        3331923459443385236632710033100206681972486278892253338953989812\
        3946916355990491141327157042882267874194134287364062276578746447\
        9906202330820336469762881009578044941150880449686894920299840694\
        1491825760720059082900953382857229547427350359177762089685919844\
        7618397959101638970146048426296929999043034632587960523515344559\
        3760366379638998785266019668146381119294252066632685499014459540\
        3228626661986220007077177536233318464572108992736543438403328805\
        5574464598751322289974611560904876079017322893499933000150292780\
        9314181521891997450492395408326917003309389028222204533522299269\
        9642000490804899546448343060640047086553849375374919580904272499\
        2861624797203649272053099350900207574531796666472086817602155859\
        1726945528270185394184089768658379449840625960802021947544967032\
        4466186751708025198780714921940794569731981222458468445510099036\
        0443553766379370268117503080771639388168258715530538192587730633\
        8011648767649780378020253215618980934849061793639902195268270484\
        2839829671374952066915706595211206930317379946812934908158184018\
        6632013950586228393873546910724730610623601482513609286385660089\
        5583205661787583142839574359287019169878432307244569229200612045\
        5315250627992995880563363584077006573129537285154494784466671567\
        6932915680429008994407050765199142140297716924995768736291428740\
        5659885583080498298853597502387982203742256599364832940936912262\
        7306295914308130060217932216792472674883590412715203292872224381\
        9052280939272105914017040234667970649280968676984639911487164048\
        6950512688416085851306225825060523983737858111232273015386133906\
        3067106584779968201933848186941851209943130293249538453239817040\
        3166446141432467835847673289873984793187889019124685049346194236\
        9012603600383131016803724007081968761885862426032848180961930077\
        9950227963208023000595795424035960037191281549377793907086267841\
        5354352203190660234784252410121708238590550542287009655613245108\
        4416679066018355796949509138190703862193823826940976741589457419\
        9842183809073744133600807601681164860417876735323999739439826648\
        6396093302983871451192612904135076545912778407507119999762905951\
        0904335217479313753450789666808129764725813866718422907715543747\
        5344763133751758328696596023139757344616559598352109613358123372\
        5336145288103713015016170797186814486644452292159678982593774509\
        0858972188466104850594765553599721902079446786014336284406080746\
        6047070155943090400227067832916854600535823815502930111708409043\
        2646551842931647415209855009938485127601076223545576051292990210\
        2073345189649748973785384281664653132841926472290823737428037653\
        6301390966801847207486995822378225832339748068221848846740932398\
        3959466133500499766954176307273566790793220329043374920481301689\
        7354443162803012925024323638559444813297758478704463046749525448\
        3994253427313816352373748756985250548695717403420035283611811551\
        8903829328845718140654077721662950782418573463754497643481431064\
        3444759787070706038677485548256120377130269594213530852587880736\
        3063990392833728301764457275979490777842591550350013392734278293\
        0393930894524284143461403246004295880475120230584716506627288175\
        5954208405305936426750512693561765614064070467267484067260606449\
        3160788244304650910047777206727593713757409794734146439721983067\
        7409870968970884026847313052795953418080569240543747685844136978\
        5225197858237765766397728263719405697355726278399445515930357298\
        8820946469896191657334557780499195433494664378529806387436512888\
        9384612665032347753991477348768850268462782942582242628537367484\
        9666383666195546877373280285951667514644359014593205613661066790\
        2637643008076793963393319103431361492547474087057096618104945092\
        9068797079145859217618763638460930039892230437159663346142492177\
        3487965404583123116632813844515253796490318415246151607418608028\
        3165345513066792765071386479447739995779779804703780812619628392\
        0818316702529642078660025202341533889455931013711373344622660581\
        7998569624624648319474551095608887152210196761483059300431511310\
        8382114269844714319724855109740243228740858105309781623648408010\
        7923960983889953454879306942395750194186332543209679586920699011\
        6488027814044240538940310045469339495606646708566622415099015800\
        4029612595363304441617897449047010514432607944518064803360908350\
        3221111187440030745261296906933672534423314714794484547420193048\
        0822412634857367963841998731477632114802046883490061951648320782\
        1113969713026065616413746693504606279025231159734952205068924264\
        5445300445311422184567380131890416551079481518026600240603387378\
        1342039627717709671407636367938362954081810163995396023446847021\
        4631560420750186123322823291039949303888078407967268763717208095\
        2543903864295730492482781564450746654358853202741987848049019427\
        6997291932933637411541980129747240034390408819886320767106029202\
        2157076256100758673195322200389179370252504774367560355559349336\
        1421680232486838517875664644500753346409203626845922264415603503\
        6600023866782527437887467155147365535405191710659008737894371890\
        2544238762746656220809565535557780409118203706433673604351735361\
        1800390642391766176484428020897344653285440131973888356373655223\
        9957549790982938642228964935099790778423157577696154898603995912\
        2480143799026707122818026432168253584012508348126651287673108845\
        5775153316563617041325708734461855814522735925258064105229767393\
        9788941361715571270608197036912192258301294845630182802656964927\
        4745384928401986455586018549294785940736001683767865500630792096\
        5443200185649550920854638482906746241812642506927742506108188194\
        9878469667918098704628894843753687311207089697195422433354870257\
        2096820521441917774150069112449092359767362686064167992531585299\
        6612569833761373691337107507656423822097124691089029473989643597\
        4231470719178170567974934919172609491675022209246170315053321249
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=fibonnaci+28751
    func testInfiniIntUXLPrime3131() {
        guard let item = Test().success({ try Fibonacci<UXL>(28751) }) else { return }
        #if !DEBUG
        Case(item).checkMathInvariants()
        Case(item).checkTextInvariants()
        #endif
        Case(item).element(UXL("""
        0000000179539422936879670273043077421513074187637090531654188941\
        5741714251061429371751580439620520390780557350979774794868208366\
        4166176620878272615316694300157066431179767088884468131326626406\
        6006793087609312815351213411657546695669274095062698689154398219\
        4273493634687995463092807527082580641615117429769927175041405435\
        0295797490359697968749112307931392970248348413038891015623785621\
        6088847611043512273516649762447035351619033256347137730401912564\
        3331923459443385236632710033100206681972486278892253338953989812\
        3946916355990491141327157042882267874194134287364062276578746447\
        9906202330820336469762881009578044941150880449686894920299840694\
        1491825760720059082900953382857229547427350359177762089685919844\
        7618397959101638970146048426296929999043034632587960523515344559\
        3760366379638998785266019668146381119294252066632685499014459540\
        3228626661986220007077177536233318464572108992736543438403328805\
        5574464598751322289974611560904876079017322893499933000150292780\
        9314181521891997450492395408326917003309389028222204533522299269\
        9642000490804899546448343060640047086553849375374919580904272499\
        2861624797203649272053099350900207574531796666472086817602155859\
        1726945528270185394184089768658379449840625960802021947544967032\
        4466186751708025198780714921940794569731981222458468445510099036\
        0443553766379370268117503080771639388168258715530538192587730633\
        8011648767649780378020253215618980934849061793639902195268270484\
        2839829671374952066915706595211206930317379946812934908158184018\
        6632013950586228393873546910724730610623601482513609286385660089\
        5583205661787583142839574359287019169878432307244569229200612045\
        5315250627992995880563363584077006573129537285154494784466671567\
        6932915680429008994407050765199142140297716924995768736291428740\
        5659885583080498298853597502387982203742256599364832940936912262\
        7306295914308130060217932216792472674883590412715203292872224381\
        9052280939272105914017040234667970649280968676984639911487164048\
        6950512688416085851306225825060523983737858111232273015386133906\
        3067106584779968201933848186941851209943130293249538453239817040\
        3166446141432467835847673289873984793187889019124685049346194236\
        9012603600383131016803724007081968761885862426032848180961930077\
        9950227963208023000595795424035960037191281549377793907086267841\
        5354352203190660234784252410121708238590550542287009655613245108\
        4416679066018355796949509138190703862193823826940976741589457419\
        9842183809073744133600807601681164860417876735323999739439826648\
        6396093302983871451192612904135076545912778407507119999762905951\
        0904335217479313753450789666808129764725813866718422907715543747\
        5344763133751758328696596023139757344616559598352109613358123372\
        5336145288103713015016170797186814486644452292159678982593774509\
        0858972188466104850594765553599721902079446786014336284406080746\
        6047070155943090400227067832916854600535823815502930111708409043\
        2646551842931647415209855009938485127601076223545576051292990210\
        2073345189649748973785384281664653132841926472290823737428037653\
        6301390966801847207486995822378225832339748068221848846740932398\
        3959466133500499766954176307273566790793220329043374920481301689\
        7354443162803012925024323638559444813297758478704463046749525448\
        3994253427313816352373748756985250548695717403420035283611811551\
        8903829328845718140654077721662950782418573463754497643481431064\
        3444759787070706038677485548256120377130269594213530852587880736\
        3063990392833728301764457275979490777842591550350013392734278293\
        0393930894524284143461403246004295880475120230584716506627288175\
        5954208405305936426750512693561765614064070467267484067260606449\
        3160788244304650910047777206727593713757409794734146439721983067\
        7409870968970884026847313052795953418080569240543747685844136978\
        5225197858237765766397728263719405697355726278399445515930357298\
        8820946469896191657334557780499195433494664378529806387436512888\
        9384612665032347753991477348768850268462782942582242628537367484\
        9666383666195546877373280285951667514644359014593205613661066790\
        2637643008076793963393319103431361492547474087057096618104945092\
        9068797079145859217618763638460930039892230437159663346142492177\
        3487965404583123116632813844515253796490318415246151607418608028\
        3165345513066792765071386479447739995779779804703780812619628392\
        0818316702529642078660025202341533889455931013711373344622660581\
        7998569624624648319474551095608887152210196761483059300431511310\
        8382114269844714319724855109740243228740858105309781623648408010\
        7923960983889953454879306942395750194186332543209679586920699011\
        6488027814044240538940310045469339495606646708566622415099015800\
        4029612595363304441617897449047010514432607944518064803360908350\
        3221111187440030745261296906933672534423314714794484547420193048\
        0822412634857367963841998731477632114802046883490061951648320782\
        1113969713026065616413746693504606279025231159734952205068924264\
        5445300445311422184567380131890416551079481518026600240603387378\
        1342039627717709671407636367938362954081810163995396023446847021\
        4631560420750186123322823291039949303888078407967268763717208095\
        2543903864295730492482781564450746654358853202741987848049019427\
        6997291932933637411541980129747240034390408819886320767106029202\
        2157076256100758673195322200389179370252504774367560355559349336\
        1421680232486838517875664644500753346409203626845922264415603503\
        6600023866782527437887467155147365535405191710659008737894371890\
        2544238762746656220809565535557780409118203706433673604351735361\
        1800390642391766176484428020897344653285440131973888356373655223\
        9957549790982938642228964935099790778423157577696154898603995912\
        2480143799026707122818026432168253584012508348126651287673108845\
        5775153316563617041325708734461855814522735925258064105229767393\
        9788941361715571270608197036912192258301294845630182802656964927\
        4745384928401986455586018549294785940736001683767865500630792096\
        5443200185649550920854638482906746241812642506927742506108188194\
        9878469667918098704628894843753687311207089697195422433354870257\
        2096820521441917774150069112449092359767362686064167992531585299\
        6612569833761373691337107507656423822097124691089029473989643597\
        4231470719178170567974934919172609491675022209246170315053321249
        """))
    }
}

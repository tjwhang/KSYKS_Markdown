#import "../preamble.typ": *

// --- 기초 데이터 ---
#let alphabet_str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#let alphabet = alphabet_str.clusters()

// --- 카이사르 암호 함수 ---
#let caesar_calc(text, shift) = {
    // 입력을 문자열로 변환 (컨텐츠 방지)
    let text_str = if type(text) == content { text.text } else { str(text) }
    let results = ()

    for char in text_str.clusters() {
        let u_char = upper(char) // 함수형 upper 사용
        let idx = alphabet.position(c => c == u_char)

        if idx != none {
            let new_idx = calc.rem-euclid(idx + shift, 26)
            let new_char = alphabet.at(new_idx)
            results.push((char: u_char, num: idx, shifted_num: new_idx, enc: new_char))
        } else {
            results.push((char: char, num: "-", shifted_num: "-", enc: char))
        }
    }
    return results
}

// --- 비쟈네르 암호 함수 ---
#let vigenere_calc(text, key) = {
    let text_str = upper(if type(text) == content { text.text } else { str(text) })
    let key_str = upper(if type(key) == content { key.text } else { str(key) })
    let key_chars = key_str.clusters().filter(c => alphabet.contains(c))
    let results = ()
    let key_idx = 0

    for char in text_str.clusters() {
        let idx = alphabet.position(c => c == char)

        if idx != none {
            // 키에서 현재 시프트 값 가져오기
            let k_char = key_chars.at(calc.rem(key_idx, key_chars.len()))
            let shift = alphabet.position(c => c == k_char)
            let new_idx = calc.rem-euclid(idx + shift, 26)
            let new_char = alphabet.at(new_idx)

            results.push((char: char, key_char: k_char, shift: shift, enc: new_char))
            key_idx += 1
        } else {
            results.push((char: char, key_char: "-", shift: "-", enc: char))
        }
    }
    return results
}

// --- 시각화 함수 (표 생성) ---
#let cipher_table(data, mode: "caesar") = {
    if mode == "caesar" {
        table(
            columns: (auto,) + data.map(_ => 1fr),
            stroke: 0.5pt,
            inset: 7pt, align: center + horizon,
            fill: (x, y) => if x == 0 { gray.lighten(80%) },
            [*평문*], ..data.map(d => d.char),
            [*숫자*], ..data.map(d => [#d.num]),
            [*결과*], ..data.map(d => [*#d.enc*]),
        )
    } else if mode == "vigenere" {
        table(
            columns: (auto,) + data.map(_ => 1fr),
            stroke: 0.5pt,
            inset: 7pt, align: center + horizon,
            fill: (x, y) => if x == 0 { gray.lighten(80%) },
            [*평문*], ..data.map(d => d.char),
            [*키*], ..data.map(d => [#d.key_char]),
            [*암호문*], ..data.map(d => [*#d.enc*]),
        )
    }
}

#let alphabet_reference_table() = {
    let make_row(start, end) = {
        table(
            columns: (auto,) + (1fr,) * (end - start + 1),
            inset: 6pt,
            stroke: 0.5pt,
            align: center + horizon,
            fill: (x, y) => if x == 0 { gray.lighten(80%) },
            [*알파벳*], ..alphabet.slice(start, end + 1).map(c => [*#c*]),
            [*숫자*], ..range(start, end + 1).map(i => [#i])
        )
    }

    // 26자를 13자씩 두 개의 표로 나누어 출력 (가독성 목적)
    make_row(0, 12)
    v(5pt) // 표 사이 간격
    make_row(13, 25)
}


= 양자 암호학

아직 우리에게는 양자컴퓨팅의 이론적 기술을 추가적으로 개발하여 그것이 빠른 시일 내에 실용성을 띠도록 할 수 있는 분야가 있는데, 바로 암호학이다. 어떤 사람들은 우리가 양자 우월성(quantum supremacy)#footnote[양자 컴퓨터가 고전 슈퍼컴퓨터의 성능을 능가하는 상태 또는 그 특이점을 말한다.]을 달성했다고 하는데, 사뭇 과장된 표현으로 다가온다. 반면, 양자 암호학은 지금도 충분히 실용적으로 양자컴퓨팅을 적용 가능한 분야이다.

== 암호학

먼저 암호학에 대해 이야기해보자. 암호학이란 쉽게 말해 비밀 메시지를 주고 받는 것에 대한 기술이자 학문이다. 현재 기록으로는 율리우스 카이사르(Ivlivs Caesar, B.C. 100 \~ B.C. 44)가 역사상 처음으로 암호를 사용했다. 그는 대제국을 통치했으며 전쟁을 많이 했다. 전선으로 비밀 메시지를 그 내용을 들키지 않고 보내기 위해서였다. 암호학은 그 태초부터 수학과 밀접한 연관성이 있었는데, 그의 첫 발상은 아래와 같이 모든 알파벳에 숫자를 매기는 것이었다.

#alphabet_reference_table()

상대에게 보낼 어떤 문자열과 함께 '키'(key)라는 값을 정한다. 암호화를 할 때는 키 만큼 알파벳에 할당된 숫자를 민다. 복호화할때는 키를 알 때 문자열의 각 알파벳의 코드를 가져온 후 키만큼 당기면 된다. 예를 들어 CRYPTOGRAPHY를 키 5로 암호화하는 과정은 다음과 같다.

#cipher_table(caesar_calc("CRYPTOGRAPHY", 5), mode: "caesar")

즉 아래가 성립한다.
$
    "암호문 코드" = "문자코드" + "키" mod 26
$

이 카이사르 암호문은 가장 기초적인 암호화 방식으로, 지금은 아이들의 놀이로 전락한 뚫기 매우 쉬운 체계이지만, 암호라는 개념이 없엇던 고대의 사람들에게는 아주 효과적으로 정보를 은닉할 수 있는 방법이었을 것이다.

카이사르 암호에서 파생된 다른 발상으로는 그냥 순열 코드 방식이 있다. 고정된 키를 두는 것이 아니라, 어떤 글자가 어디에 대응하는지를 미리 정해두는 방식이다. 비슷한 암호는 유명한 추리소설 셜록 홈스에서 'Dancing Men' 암호로 등장한다. 유일한 차이점은 소설에서는 알파벳이 다른 알파벳이 아닌 그림에 대응된다는 것이다. 이런 암호를 뚫기 위해서는 통계학을 이용한다. 알파벳 글자들 간 사용 빈도가 같지 않기 떄문에, 이 빈도 통계를 이용해 어떤 그림이 어떤 알파벳에 대응하는지를 알아내는 것이다. 영어 알파벳 중 가장 자주 등장하는 것은 'e'로, 전체 빈도의 12%를 차지한다고 한다. 그 아래로는 't'가 9%, 'a'가 8%...로 따르고, 가장 드물게 등장하는 'z'는 0.07%의 빈도를 갖는다. 이처럼 'e'와 'z'의 빈도의 차이가 크므로, 가지고 있는 암호문이 충분하다면 가장 극적인 빈도 차이로 몇몇 글자를 찾아놓고 애매한 사이 값들을 유추하여 찾아내는 방식으로 복호화할 수 있다. 이런 작업을 통계학적 분석(statistical analysis)라고 한다.

카이사르 암호의 또 다른 변주로는 비즈네르(Vigenère) 암호가 있다. 비즈네르 암호는 키로 고정된 수를 사용하는게 아니라, 키워드를 설정한다. 그 뒤, 키워드가 평문의 길이를 채우도록 반복하여 쓴 다음 원래 알파벳 코드에 키워드의 알파벳 코드를 더한다. 예를 들어 똑같은 평문 'CRYPTOGRAPHY'를 키워드 'KEYWORD'로 암호화한다고 하자. 그러면 아래와 같이 된다.

#cipher_table(vigenere_calc("CRYPTOGRAPHY", "KEYWORD"), mode: "vigenere")

이 암호는 이전에 본 것들보다는 안전하나, 여전히 통계적 분석에 취약하다. 공격자는 키워드의 길이를 무차별 대입해보며 키워드의 길이만큼 암호문을 쪼개어 아까와 마찬가지로 각각에 대해 통계적 분석을 시행하면, 특히 컴퓨터가 있는 요즘은 일반적인 길이의 암호문에 대해 몇 초 이내로 결과가 나올 것이다.

비즈네르 암호의 변형으로 완전히 안전한 일회성 패드(one time pad) 방식이 있다. 먼저 사용자 간 서로 다른 임의의 문자열이 엄청나게 많이 들어있는 책자같은 것을 교환한다. 이 문자열은 모두 키워드의 역할을 하는데, 이것을 패드(pad)라고 한다. 이때 이 패드들은 길이가 평문보다 같거나 길어야한다. 송신 시 책자의 문자열의 위치를 특정하는 정보를 같이 보내면, 비즈네르 암호와 같은 방식으로 사용할 수 있다. 요점은 각 문자열은 딱 한 번만 사용해야 한다는 것으로, 이것이 통계적 분석과 브루트포스로부터의 취약성을 보완하게 된다. 하지만 이런 방식은 명확한 한계가 있는데, 패드들을 수신자에게 전달할 수 있어야하며 패드가 안전해야 한다는 것과, 둘째로 책자에 패드가 충분히 많아야 한다는 것이다. 그러므로 비밀 요원의 예시를 들어보면 요원은 자기가 본부로부터 지급받은 패드 책자를 필사적으로 지켜야하며, 투입 전에 미리 본부와 메시지를 얼마나 교환할지를 미리 정해두어야 한다. 패드를 재사용하기 시작하면 보안에 균열이 생기게 되기 때문이다.

우리는 현재 인터넷의 시대에 살고 있으며, 통신(telecommunication)은 한 번도 만난 적 없는 주체 간 일어나는 경우가 대부분이다. 우리는 이제 수시로 데이터를 교환하며 통신하기 때문에, 충분히 긴 패드를 미리 만들어둘 수 없다. 따라서 위에서 이야기한 미리 패드를 교환하는 방법은 사용할 수 없으므로 실시간으로 패드를 만들어내면서도 보안을 지켜낼 방법이 필요하다.

여기서 양자 암호학이 빛을 발할 수 있다. 양자 암호학은 일회용 패드를 실시간으로, 안전하게 만들어낼 수 있다. 우리는 일회용 패드 방식의 보안성을 챙기는 동시에, 실시간으로 패드를 주고받을 때도 보안을 챙기고 싶은 것이다. 즉 패드를 공유할 때의 안전성은 양자역학의 방식으로 보장될 수 있다.

== BB'84 프로토콜
우리의 목표는 무작위의 비밀 이진#footnote[현대 디지털 통신은 이진법을 사용하므로 일회성 이진 패드를 사용하고 합의 $mod 26$을 사용하는 대신 합의 $mod 2$를 사용할 것이다.] 패드를 만들어서 두 주체 철수와 영희가 안전하게 공유하도록 만드는 것이다. 이것이 가능하다면 철수와 영희는 비밀스럽지 않은 채널을 통해 완벽히 안전한 통신을 주고받을 수 있다.

이 예시에서는 편광된 광자를 사용하겠다. 우리가 논의할 방식은 BB'84라는 것으로, 베넷(Charles H. Bennet, 1943 \~ )과 브라사드(Gilles Brassard, 1955 \~ )가 1984년 개발한 양자 암호화 프로토콜이다. 영희가 편광된 광자를 생성해 철수에게 보내면 철수가 광자를 편광 필터에 통과시켜 측정한다고 하자. 영희는 아래와 같이 네 가지의 편광된 광자를 만들어 철수에게 보낸다.

$
    arrow.t quad arrow.r quad arrow.tr quad arrow.tl
$
이것들을 임의로, 순서대로 1, 0, 1, 0으로 할당하자.

철수는 수직 편광필터 #sym.plus.square 를 바로 사용하거나 45도 돌려서, #sym.times.square 로 사용함으로써 각 기저 $ket(0)$과 $ket(1)$에 대해 각각 $arrow.t, arrow.r$ 또는 $arrow.tr, arrow.tl$을 정확하게 측정해낼 수 있다. 하지만 두 그룹을 동시에 정확하게 측정해내는 것은 불가능하여, 영희와 맞지 않은 기저를 사용했다면 0또는 1이 반반 확률로 나오게 된다. 철수는 자신이 알맞은 기저를 썼는지 아닌지 알 수 없다. 그래서 측정이 끝나고 나면 철수와 영희는 서로의 기저를 공개하게 되는데, 이로써 서로가 같은 기저를 사용한 부분들만 알아낼 수 있다. 이제 기저가 일치하지 않는 부분들은 버리고 일치하는 부분들의 광자 큐비트만 취하면 이것이 둘만 알고 중간에서는 가로챌 수 없는 새로운 패드가 된다. 직접 예시를 보도록 하자.

영희가 먼저 비트를 정하고 기저를 선택해 편광된 광자를 철수에게 보낸다. 그러면 철수는 그 광자를 자신이 가진 두 개 중 하나의 기저로 측정해 출력값을 확인하고, 자신의 기저를 영희와 함께 공개한다. 둘의 기저가 일치하는 부분의 광자 편광값만 취하면 그것이 바로 새로운 패드가 된다.

// --- 1. 개선된 난수 생성 함수 (0 또는 1 반환) ---
// seed와 index, salt를 조합해 무작위성을 확보합니다.
#let get_rand_bit(seed, index, salt) = {
    let v = calc.sin((seed + index * 13.31 + salt * 41.73) * 1rad) * 10000
    if calc.rem(calc.floor(calc.abs(v)), 2) == 0 { 0 } else { 1 }
}

// --- 2. BB84 시뮬레이션 함수 ---
#let bb84_simulation(length, seed: 123) = {
    let results = ()

    for i in range(length) {
        // 영희(Alice) 설정
        let a_bit = get_rand_bit(seed, i, 1.1)
        let a_basis_num = get_rand_bit(seed, i, 2.2) // 0: +, 1: x

        // 편광 결정 (사용자 정의 규칙 반영)
        let photon = ""
        if a_basis_num == 0 {
            // + 기저
            photon = if a_bit == 1 { $arrow.t$ } else { $arrow.r$ }
        } else {
            // x 기저
            photon = if a_bit == 1 { $arrow.tr$ } else { $arrow.tl$ }
        }

        // 철수(Bob) 설정
        let b_basis_num = get_rand_bit(seed, i, 3.3) // 0: +, 1: x

        // 철수의 측정 결과
        let b_bit = 0
        if a_basis_num == b_basis_num {
            // 기저가 같으면 비트 일치
            b_bit = a_bit
        } else {
            // 기저가 다르면 50% 확률로 결정
            b_bit = get_rand_bit(seed, i, 4.4)
        }

        results.push((
            a_bit: a_bit,
            a_basis: if a_basis_num == 0 { sym.plus.square } else { sym.times.square },
            photon: photon,
            b_basis: if b_basis_num == 0 { sym.plus.square } else { sym.times.square },
            b_bit: b_bit,
            is_match: a_basis_num == b_basis_num,
        ))
    }
    return results
}

// --- 3. 결과 출력용 표 함수 ---
#let bb84_table(data) = {
    table(
        columns: (auto,) + (1fr,) * data.len(),
        inset: 5pt,
        align: center + horizon,
        fill: (x, y) => if x == 0 { gray.lighten(90%) },
        stroke: 0.5pt + gray,
        [*영희 비트*], ..data.map(d => [#d.a_bit]),
        [*영희 기저*], ..data.map(d => [#d.a_basis]),
        [*광자 상태*], ..data.map(d => [#d.photon]),
        [*철수 기저*], ..data.map(d => [#d.b_basis]),
        [*철수 측정*], ..data.map(d => [#d.b_bit]),
        [*기저 일치*], ..data.map(d => if d.is_match [Y] else [N]),
        [*최종 키*], ..data.map(d => if d.is_match [*#d.b_bit*] else [---])
    )
}

#let test_length = 12
#let sim_data = bb84_simulation(test_length, seed: 987)

#bb84_table(sim_data)

공격자가 이 체계를 뚫고 실제 통신 내용을 옅들으려면, 중간에서 광자를 가로채 측정하고 측정한 광자와 정확히 일치하는 광자를 다시 철수에게 보내야 하는데, 양자역학 측정의 특성 상 측정은 확률적이며 설정한 기저에 대해 부분적이므로 영희가 쏜 광자와 정확히 일치하는 광자를 만들어낼 수 없다. 공격자가 사용한 필터가 철수가 사용한 필터와 알맞는지는 알 길이 없기 때문이다. 즉 공격자는 절대 둘의 통신을 옅듣는#footnote[정보보안 용어로 스니핑(sniffing)이라고 한다.] 것만으로는 패드를 알아낼 수 없다. 그러므로 이론적으로 뚫는 것이 불가능하다.

하지만 문제점은 누군가가 중간에서 광자를 가로채 다른 광자로 바꾸어 보내면 통신이 변조될 수 있다는 것이다. 그러므로 이렇게 패드를 만든 후 그 무결성(integrity)를 검사해야한다. 따라서 그들은 패드의 동일한 일정 부분#footnote[매 10번째 비트라던가...]을 떼어 서로에게 공개하여 완벽히 일치하는지 확인한다. 당연히 공개된 문자열들은 실제로 패드가 데이터 송수신에 사용되기 전에 패드에서 삭제되어야 한다.

이렇게 완벽하게 독특하고 안전한 통신을 보호되지 않은 채널에서 수행할 수 있다. 이 방법은 이론적으로 안전하고 그 누구도 중간에서 통신을 가로채어 변조하거나 옅들어 그 내용을 알아낼 수 없다. 하지만 한 가지 문제가 있는데, 광자를 한 개씩 쏘아 보내는 기계가 없다는 것이다. 레이저와 같은 장치는 광자를 뭉텅이로 쏴보내기 때문에 통계적 추정 등을 한다고 해도 100% 정확도로 패드의 무결성을 보장하기 어렵다.

== E'91 프로토콜

또 다른 양자 암호학에 기반한 프로토콜을 살펴보자. 이번 것은 에커트(Artur Conrad Ekert, 1961 \~ )가 1991년에 제안한 것으로, 광자의 얽힘을 이용한다. 어떤 광원이 철수와 영희에게 얽힌 광자 쌍을 쏘아 보낸다고 하자. 이때 그 얽힘 상태는 다음과 같다.
$
    psi = 1/sqrt(2) ket(00) + 1/sqrt(2) ket(11) = 1/sqrt(2) ket(arrow.t arrow.t) + 1/sqrt(2) ket(arrow.r arrow.r)
$
50% 확률로 철수와 영희는 0 또는 1을 측정한다. 이때 두 상태의 측정 결과 간에는 100% 상관관계가 있다. 이 특성은 둘이서 공유하는 무작위의 일회용 비밀 패드를 만들 수 있도록 한다. 얽힌 광자 쌍을 만들어내야하므로, 기술적으로 이 방법은 BB'84 방법보다 구현하기 어렵다. 하지만 앞서 살펴보았듯, 중국의 위성 묵자가 1200 km 가량 떨어진 두 위치에 얽힌 광자를 쏘아보내 비국소적 양자얽힘이 일어난다는 것을 실험적으로 증명했었다#footnote[물론 그 비트레이트는 초당 광자 5 개 정도로 낮으나 여전히 가능하다는 것이 중요하다.].

이 프로토콜을 공격하는 방법 하나에 대해 논의하자. 우리가 논의할 방법은 일반적으로 정보보안에서 중간자 공격(man-in-the-middle attack)이라고 불리는 방식의 일종이다. 여기서는 제 3자인 길동#footnote[사실 정보보안 책의 전통으로는 여기서 등장한 철수와 영희가 각각 Bob과 Alice이고, 중간자인 길동은 Eve이다.]이 얽힌 광자의 시퀀스를 가로채고 얽힘 상태가 아닌 임의의 광자를 철수와 영희에게 보낸다. 즉 상태는 $psi_1 = ket(00)$ 또는 $psi_2 = ket(11)$이며, 길동은 자기가 둘에게 각각 뭘 보냈는지 알고 있다. 이로써 철수와 영희 간 상관관계가 끊어져 서로 다른 측정 관계를 얻게 된다. 그러므로 이 공격을 방어하려면 중간자를 감지할 수 있는 방법이 필요하다.

철수와 영희가 동시에 측정에 사용하는 편광 필터를 각 $alpha$로 회전한다고 해보자. 이 말은 즉 동시에 둘이 기저를 바꿈으로써 관측가능량을 바꿔 고유 상태가 바뀐다는 뜻이 된다. 우리가 이걸 표현할 때는 관측가능량을 다른 방향의 화살표로 바꾸는 것보다 본래 상태에 회전 변환을 가하는 편이 좋을 것이다. $alpha$만큼 회전하는 연산자를 $R_alpha$라고 한다면
$
    R_alpha ket(0) = cos alpha ket(0) + sin alpha ket(1) \
    R_alpha ket(1) = - sin alpha ket(0) + cos alpha ket(1)
$

이때 $psi$는 아래와 같이 된다.
$
    psi & mapsto 1/sqrt(2) R_alpha ket(0) times.o R_alpha ket(0) + 1/sqrt(2) R_alpha ket(1) times.o R_alpha ket(1) \
        & = 1/sqrt(2) (cos alpha ket(0) + sin alpha ket(1)) times.o (cos alpha ket(0) + sin alpha ket(1)) \
        & + 1/sqrt(2) (- sin alpha ket(0) + cos alpha ket(1)) times.o (- sin alpha ket(0) + cos alpha ket(1)) \
$
텐서곱을 풀어 정리하면
$
    & = 1/sqrt(2) (cos^2 alpha + sin^2 alpha) ket(00) + 1/sqrt(2) (cos alpha sin alpha - sin alpha cos alpha) ket(01) \
    & + 1/sqrt(2) (sin alpha cos alpha - cos alpha sin alpha) ket(10) + 1/sqrt(2) (sin^2 alpha + cos^2 alpha) ket(11)
$
로 $ket(01), ket(10)$항은 소거됨을 알 수 있다. $cos^2 alpha + sin^2 alpha = 1$이므로
$
    psi mapsto 1/sqrt(2) ket(00) + 1/sqrt(2) ket(11)
$
와 같이, 편광 필터를 같이 돌려도 얽힘과 측정의 결과는 바뀌지 않는 것을 알 수 있다. 하지만 만약 중간자가 얽힘을 끊고 임의의 광자를 보냈다면, $alpha$에 의존하는 $ket(0)$과 $ket(1)$ 항으로부터 $ket(00), ket(01), ket(10), ket(11)$ 항을 모두 받게 되어 있어 그 중간자를 철수와 영희가 감지해낼 수 있다. 즉 BB'84에서 본 것처럼 두 기저 상태를 만들어두고 동시에 바꾸면서 기저가 같을 때 측정한 값의 일부를 공유해 무결성을 검사할 수 있을 것이다.

양자 암호학의 장점은 기술적 구현이 제대로 되었을 경우 이론적으로 100% 안전하면서도 모든 통신을 보안 조치되지 않은 채널에서 처리할 수 있다는 것에 있다. 단점으로는 철수와 영희 간 얽힌 광자를 받는 등의 물리적 채널을 구현해내야 한다는 것이다. 즉 메리트가 확실히 있으나 현재 기술로 구현이 어려워 미래에 기술이 어떤 식으로 발전하게 될지를 기대하게 만드는 부분이다.

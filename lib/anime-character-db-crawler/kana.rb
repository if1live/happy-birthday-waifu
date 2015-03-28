require 'gimchi'

module AnimeCharacterDB
  class KanaToHangul
    # Reference
    # 일본 이름 발음/표기 검색
    # http://www.hipenpal.com/tool/japanese_names_search_and_converter_in_korean.php
    # 엔하, 위키의 일본어의 한글 표기
    # 표기법을 그대로 따르면 '카'대신 '가'만 남는다.
    # 그래서 '카스가노 소라'를 표현할수 없기 때문에 참고는 하지만 적절히 바꾼다
    # 히라가나/가타카나를 한글에 1:1로 대응시켰다.
    # 가장 무식한 방법이지만 제일 깔끔할거같더라.
    # ょ나 장음은 별도로 구현해야한다
    @@basic_hiragana_table = {
      'あ' => '아', # a
      'い' => '이', # i
      'う' => '우', # u
      'え' => '에', # e
      'お' => '오', # o

      'か' => '카', # ka
      'が' => '가', # ga
      'き' => '키', # ki
      'ぎ' => '기', # gi
      'く' => '쿠', # ku
      'ぐ' => '구', # gu
      'け' => '케', # ke
      'げ' => '게', # ge
      'こ' => '코', # ko
      'ご' => '고', # go
      'さ' => '사', # sa
      'ざ' => '자', # za
      'し' => '시', # shi
      'じ' => '지', # ji
      'す' => '스', # su
      'ず' => '즈', # zu
      'せ' => '세', # se
      'ぜ' => '제', # ze
      'そ' => '소', # so
      'ぞ' => '조', # zo
      'た' => '타', # ta
      'だ' => '다', # da
      'ち' => '치', # chi
      'ぢ' => '디', # di
      'つ' => '츠', # tsu
      'づ' => '드', # du
      'て' => '테', # te
      'で' => '데', # de
      'と' => '토', # to
      'ど' => '도', # do
      'な' => '나', # na
      'に' => '니', # ni
      'ぬ' => '누', # nu
      'ね' => '네', # ne
      'の' => '노', # no
      'は' => '하', # ha
      'ば' => '바', # ba
      'ぱ' => '파', # pa
      'ひ' => '히', # hi
      'び' => '비', # bi
      'ぴ' => '피', # pi
      'ふ' => '후', # hu
      'ぶ' => '부', # bu
      'ぷ' => '푸', # pu
      'へ' => '헤', # he
      'べ' => '베', # be
      'ぺ' => '페', # pe
      'ほ' => '호', # ho
      'ぼ' => '보', # bo
      'ぽ' => '포', # po
      'ま' => '마', # ma
      'み' => '미', # mi
      'む' => '무', # mu
      'め' => '메', # me
      'も' => '모', # mo
      'ら' => '라', # ra
      'り' => '리', # ri
      'る' => '루', # ru
      'れ' => '레', # re
      'ろ' => '로', # ro

      # 첫글자로 등장하는 경우도 있기 때문에
      # 테이블에 있어야한다
      'や' => '야', # ya
      'ゆ' => '유', # yu
      'よ' => '요', # yo
      'ょ' => '요', # yo

      'わ' => '와', # wa
      'ゐ' => '이', # i
      'ゑ' => '에', # e
      'を' => '오', # o
      'ん' => 'ㄴ', # n
    }

    @@postfix_vowel_table = {
      'や' => 'ㅑ', # ya
      'ゆ' => 'ㅠ', # yu
      'よ' => 'ㅛ', # yo
      'ょ' => 'ㅛ', # yo
    }

    # りょうへい 와 같이 합쳐진 다음에 등장하는 う는 무시한다
    # う 이외에도 여러개가 될수 있어서 테이블로 분리
    @@after_merge_skip_table = {
      'う' => '우', # u
    }

    def convert_word(kana)
      char_array = []
      kana.each_char { |x| char_array << x }

      retval_list = []
      i = 0
      while i < char_array.length
        # 인덱스를 건너뛰는 경우가 있기 때문에 each를 쓰지 않는다
        out = nil
        prev_char = char_array[i - 1]
        curr_char = char_array[i]
        next_char = char_array[i + 1]

        # や, ゆ, よ 의 경우는 앞의 글자와 합쳐져서 발음을 결정한다
        # 반대로 말하면 다음 글자에 무엇인지 항상 확인해야한다
        if @@postfix_vowel_table.include? next_char
          kc = Gimchi::Char(@@basic_hiragana_table[curr_char])
          kc.jungsung = @@postfix_vowel_table[next_char]
          out = kc.to_s
          # 인덱스를 1단계 추가 진행.  や, ゆ, よ를 건너뛰는게 목적
          i += 1

        elsif @@postfix_vowel_table.include? prev_char and @@after_merge_skip_table.include? curr_char
          # りょうへい 와 같이 합쳐진 다음에 등장하는 う는 무시
          out = ''

        else
          if @@basic_hiragana_table.include?(curr_char)
            out = @@basic_hiragana_table[curr_char]
          else
            out = curr_char
          end
        end

        retval_list << out

        # end
        i += 1
      end
      retval_list.join('')

    rescue
      # 망해도 코드는 죽지 않도록
      'ERROR'
    end

    def convert(kana)
      token_list = kana.split(' ')
      hangul_list = token_list.map { |x| convert_word(x) }
      hangul_list.join(' ')
    end
  end
end

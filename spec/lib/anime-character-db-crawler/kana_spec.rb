require 'anime-character-db-crawler'

describe AnimeCharacterDB::KanaToHangul do
  let(:subject) { AnimeCharacterDB::KanaToHangul.new }
  describe '#convert' do
    it 'ryo' do expect(subject.convert('りょ')).to eq('료') end

    it 'yosuga-01' do expect(subject.convert('かすがの そら')).to eq('카스가노 소라') end
    it 'yosuga-02' do expect(subject.convert('あまつめ あきら')).to eq('아마츠메 아키라') end
    it 'yosuga-03' do expect(subject.convert('みぎわ かずは')).to eq('미기와 카즈하') end
    it 'yosuga-04' do expect(subject.convert('のぎさか もとか')).to eq('노기사카 모토카') end
    it 'yosuga-05' do expect(subject.convert('なかざと りょうへい')).to eq('나카자토 료헤이') end
    it 'yosuga-06' do expect(subject.convert('くらなが こずえ')).to eq('쿠라나가 코즈에') end
    it 'yosuga-07' do expect(subject.convert('よりひめ なお')).to eq('요리히메 나오') end
    it 'yosuga-08' do expect(subject.convert('いふくべ やひろ')).to eq('이후쿠베 야히로') end
    it 'yosuga-09' do expect(subject.convert('かすがの はるか')).to eq('카스가노 하루카') end
  end
end

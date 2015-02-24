require 'anime-character-db-crawler'

def get_filepath(filename)
  html_dir = File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    'testdata',
    'animecharacterdatabase')
  file_path = File.join(html_dir, filename)
  return file_path
end


describe AnimeCharacterDB::SourceData do
end

describe AnimeCharacterDB::SourceHTMLParser do
  let(:yosuga_no_sora_filepath) { get_filepath 'source-1693-yosuga-no-sora.html' }
  let(:yosuga_no_sora_html) { File.read yosuga_no_sora_filepath }
  let(:cocoro_function_filepath) { get_filepath 'source-103704-cocoro-function.html' }
  let(:cocoro_function_html) { File.read cocoro_function_filepath }

  let(:subject) { AnimeCharacterDB::SourceHTMLParser.new }

  describe '#read' do
    it 'yosuga no sora' do
      data = subject.read yosuga_no_sora_html
    end

    it 'cocoro function' do
      data = subject.read cocoro_function_html
    end
  end



end

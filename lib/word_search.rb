class WordSearch
  def locate_word(sample_word)
    dictionary = File.read('/usr/share/dict/words')
    if dictionary.include?(sample_word)
      "#{sample_word.upcase} is a known word"
    else
      "#{sample_word.upcase} is not a known word"
    end
  end
end
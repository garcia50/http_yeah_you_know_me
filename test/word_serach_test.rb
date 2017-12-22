require 'minitest/autorun'
require 'minitest/pride'
require './lib/word_search'

class WordSearchTest < Minitest::Test
  attr_reader :word_search

  def setup
    @word_search = WordSearch.new
  end

  def test_word_search_class_exist
    assert_instance_of WordSearch, word_search
  end

  def test_correct_phrase_is_returned_when_testing_a_word
    word_search.locate_word("apple")
    assert_equal "APPLE is a known word", word_search.locate_word("apple")
  end

  def test_correct_phrase_is_returned_when_testing_a_word_pt2
    word_search.locate_word("savior")
    assert_equal "SAVIOR is a known word", word_search.locate_word("savior")
  end

  def test_correct_phrase_is_returned_when_testing_a_nonexisting_word
    word_search.locate_word("askjdhf")
    assert_equal "ASKJDHF is not a known word", word_search.locate_word("askjdhf")
  end

  def test_correct_phrase_is_returned_when_testing_a_nonexisting_word_pt2
    word_search.locate_word("salmysavior")
    assert_equal "SALMYSAVIOR is not a known word", word_search.locate_word("salmysavior")
  end
end
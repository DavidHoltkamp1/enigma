require_relative 'test_helper.rb'
require './lib/enigma'
require 'date'
require './lib/shift'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_initializes
    @enigma.stubs(:key => "02715")
    assert_equal "02715", @enigma.key
    @enigma.stubs(:date => "040895")
    assert_equal "040895", @enigma.date

    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]

    assert_equal expected, @enigma.alphabet
    assert_equal 27, @enigma.alphabet.length
  end

  def test_it_can_break_up_message
    expected = [['h', 'e', 'l', 'l'], ['o', ' ', 'w', 'o'], [ 'r', 'l', 'd', '!']]

    assert_equal expected, @enigma.message_chunked("Hello World!")
  end

  def test_it_can_rotate_chunks_of_message
    @enigma.stubs(:key).returns("02715")
    @enigma.stubs(:date).returns("040895")
    final_shift = Shift.generate_shift(@enigma.key, @enigma.date)

    chunk = ['h', 'e', 'l', 'l']
    expected = ['k', 'e', 'd', 'e']
    assert_equal expected, @enigma.encrypt_chunk(chunk, final_shift)

    chunk2 = ['!', '?', '@', '&']
    expected2 = ['!', '?', '@', '&']
    assert_equal expected2, @enigma.encrypt_chunk(chunk2, final_shift)
  end

  def test_encrypt_message
    @enigma.stubs(:key).returns("02715")
    @enigma.stubs(:date).returns("040895")
    final_shift = Shift.generate_shift(@enigma.key, @enigma.date)

    expected = "keder ohulw"

    assert_equal expected, @enigma.encrypt_message("hello world", final_shift)
  end

  def test_it_can_encrypt
    message = "hello world"
    key = "02715"
    date = "040895"

    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @enigma.encrypt(message, key, date)
  end

  def test_it_can_decrypt_chunk
    @enigma.stubs(:key).returns("02715")
    @enigma.stubs(:date).returns("040895")
    final_shift = Shift.generate_shift(@enigma.key, @enigma.date)
    chunk = ['k', 'e', 'd', 'e']
    expected = ['h', 'e', 'l', 'l']

    assert_equal expected, @enigma.decrypt_chunk(chunk, final_shift)

    chunk2 = ['!', '?', '@', '&']
    expected2 = ['!', '?', '@', '&']
    assert_equal expected2, @enigma.decrypt_chunk(chunk2, final_shift)
  end

  def test_it_can_decrypt_message
    @enigma.stubs(:key).returns("02715")
    @enigma.stubs(:date).returns("040895")
    final_shift = Shift.generate_shift(@enigma.key, @enigma.date)

    expected = "hello world"
    assert_equal expected, @enigma.decrypt_message("keder ohulw", final_shift)
  end

  def test_it_can_decrypt
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @enigma.decrypt(message, key, date)
  end

  def test_it_can_encrypt_with_todays_date_and_random_key
    assert_instance_of Hash, @enigma.encrypt("hello world")
    assert_instance_of Hash, @enigma.encrypt("hello world", "02715")
  end

  def test_it_can_decrypt_with_key
    message = "keder ohulw"
    key = "02715"
    assert_instance_of Hash, @enigma.decrypt(message, key)
  end
end

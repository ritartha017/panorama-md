# frozen_string_literal: true

require_relative "utils"

class Markovify # :nodoc:
  include Utils
  private
  attr_accessor :text, :order, :ngrams, :occurences, :transition_hash

  public
  def initialize(options = {})
    @separators = /^#{alphanumeric_chars}+#{rom_diacritics}\s+/
    @text  = options[:text].dup.gsub(@separators, " ").delete "\n"
    @order = options[:order]
    @ngrams = setup(text, order)
    @occurences = perform_occurences(@ngrams)
    @transition_hash = build_transition_hash(@occurences)
  end

  def add_text(text)
    @text << " #{text}"
    setup(self.text, order)
  end

  def get_ngrams
    @ngrams.empty? ? (return "Empty model.") : @ngrams
  end

  def get_order
    @order.nil? ? (return "Empty model.") : @order
  end

  def get_text
    @text.empty? ? (return "Empty model.") : @text
  end

  def get_transition_hash
    @transition_hash.nil? ? (return "Empty model.") : @transition_hash
  end

  # Given a text(string) it will add all the words
  # within the source to the markov ngrams hash.
  # @return [Hash] of ngrams with specificated orden.
  def setup(_text, order)
    txt = split_text(self.text)
    len = txt.size
    ngrams = {}
    (0..len - order).each do |i|
      gram = txt[i...i + order]
      unless txt[i + order...i + 2 * order].empty?
        ngrams[gram] ||= []
        ngrams[gram] << txt[i + order...i + 2 * order]
      end
    end
    ngrams
  end

  def get_separated_tokens(query)
    source = split_text(self.text)
    query = Array(source.sample)
    next_idx = source.find_index(query.join(" ")) + 1
    (1...self.order).each do
      query << source[next_idx]
      source[next_idx]
      next_idx += 1
    end
    query
  end

  # markov_it generates new text of (n_ngrams * n_ngrams) length
  # based on an initial seed of words.
  # @return [String] the words, hopefully forming sentences generated.
  def markov_it(n_ngrams = 20)
    current_gram = get_separated_tokens(self.text)
    result = current_gram

    0.upto(n_ngrams) do
      possibilities = self.ngrams[current_gram]
      break unless possibilities

      nexxt = possibilities.sample
      result << nexxt
      current_gram = nexxt
    end
    result.join(" ")
  end

  def pp_markov_it(ngrams = 20, headline = false)
    res = markov_it(ngrams)
    res.capitalize!
    res += "." if headline == false && res[-1, 1] != "."
    res.dup.gsub(/[^0-9A-Za-z]\s+/, "").delete "." if headline == true
    res = capitalize_letters_after_dots(res)
    res
  end

  # Clear the markov model from the cache.
  def clear_cache
    ngrams.clear
    text.clear
  end

  def perform_occurences(ngrams = self.ngrams)
    occurences = {}
    ngrams.map { |state, _| occurences[state] = {} }

    ngrams.each do |lhs, rhs|
      occurences[lhs] = rhs.tally.map { |k, v| {k => v} }
    end
    occurences
  end

  def build_transition_hash(occurences)
    transition_hash = {}
    favorable_number_of_cases = 0

    sum = occurences.map do |lhs, rhs|
      total_number_of_cases = 0
      rhs.map{ |noccur| total_number_of_cases += noccur.values.sum }
      rhs.map do |i|
        favorable_number_of_cases = i.values.sum
        probability = favorable_number_of_cases/total_number_of_cases.to_f
        transition_hash[Array[lhs, i.keys.flatten]] = probability
      end
    end
    transition_hash
  end
end

# text1 = "The unicorn is a legendary creature that has been described since antiquity as a beast with a single large, pointed, spiraling horn projecting from its forehead.
# #         In European literature and art, the unicorn has for the last thousand years or so been depicted as a white horse-like or goat-like animal with a long straight horn
# #         with spiralling grooves, cloven hooves, and sometimes a goat's beard. In the Middle Ages and Renaissance, it was commonly described as an extremely wild woodland creature,
# #         a symbol of purity and grace, which could be captured only by a virgin. In the encyclopedias, its horn was said to have the power to render poisoned water potable and to heal
# #         sickness. In medieval and Renaissance times, the tusk of the narwhal was sometimes sold as a unicorn horn."
# text1 = "Ministerul Sănătății spune că va crea o comisie de anchetă în legătură cu raportul Curții de Conturi că în Moldova s-ar fi administrat mii de vaccinuri anti-COVID expirate, la o zi după ce dezmințise aceleași informații.
# „Ministerul Sănătății a instituit o comisie de anchetă, care se va deplasa și va supune verificării corectitudinea administrării vaccinurilor în instituțiile medico-sanitare
#  și centrele de vaccinare la care se referă raportul”, se spune într-un comunicat de presă de vineri, 17 decembrie.".encode('utf-8')
# text2 = "eu sunt sunt alo alo alo aici alo eu sunt eu sunt sunt alo alo alo aici alo eu sunt"

# p obj.order
# p obj.text
# p obj.markov_it(setup(text), text)
# ngrams = obj.get_ngrams

# p obj.build_transition_matrix(ngrams)

# obj.clear_cache
# p obj.ngrams{["eu", "sunt"]=>[{["sunt", "alo"]=>2}, {["eu", "sunt"]=>1}]

# obj.add_text(text2)

# occurences = obj.perform_occurences(ngrams)
# pp obj.get_transition_hash
# obj = Markovify.new(text: text1, order: 2)
# pp obj.get_ngrams
# p obj.markov_it(20)


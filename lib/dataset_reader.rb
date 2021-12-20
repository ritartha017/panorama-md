require 'json'

class Dataset
	def self.load_from_json
		File.read('lib/fixtures/dataset.json')
	end

	def self.get_data_hash
		data = load_from_json
		JSON.parse(data)
	end

	def self.get_number_of_articles(data_hh)
		articles_size = 0
		data_hh.map { articles_size += 1 }
		articles_size
	end

	def self.pick_random_article(data_hh)
		articles_size = get_number_of_articles(data_hh)
		idx_random_article = rand 0...articles_size
		article_text = data_hh["#{idx_random_article}"][0]
		article_source = data_hh["#{idx_random_article}"][1]
		[article_text, article_source]
	end
end

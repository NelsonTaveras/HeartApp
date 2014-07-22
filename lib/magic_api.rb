class MTGApi
	include HTTParty
	require_relative 'mtgcard'

	attr_reader :base_url

	def initialize
		@base_url = 'http://api.mtgdb.info/'
	end

	def get_cards_by_set set_id
		request_url = @base_url + 'sets/' + set_id + '/cards'
		response = HTTParty.get(request_url)
		cards = []
		for i in 0..response.length - 1
			id = response[i]['id']
			name = response[i]['name']
			manacost = response[i]['manaCost']
			description = response[i]['description']
			cards.push MTGCard.new(id, name, manacost, description)
		end
		cards
	end

	def can_buy card, w, u, b, r, g
		# How much do i got of each type
		got = Hash.new
		got['W'] = w
		got['U'] = u
		got['B'] = b
		got['R'] = r
		got['G'] = g
		manacost = card.manacost
		idx = 0
		extra = 0 # Required extra cards                                                                                                                                                                                                                                           cxx
		while idx < manacost.length do
			if is_i?(manacost[idx])
				extra = extra * 10
				extra = extra + manacost[idx].to_i
			else
				got[manacost[idx]] = got[manacost[idx]] - 1;
			end
			idx = idx + 1
		end
		f = 1 # set to 1 because right now i can buy the card
		got.each do |k, v|
			if v < 0
				f = 0 # takes more than what i have, can't buy.
			else
				extra = extra - v
			end
		end
		f && extra <= 0
	end

	def can_buy_from_set set_id, w, u, b, r, g
		cards = get_cards_by_set(set_id)
	end

	def is_i? c
       c >= '0' && c <= '9'
    end

end

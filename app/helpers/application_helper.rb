module ApplicationHelper
	def tag_cloud(tags, classes)
		max = tags.sort_by(&:count).last
		tags.each do |tag|
			index = tag.count.to_f / max.count * ( classes.size - 1)
			yield(tag, classes[index.round])
		end
	end

	def avatar_url(user)
		gravatar_id = Digest::MD5::hexdigest(user.email).downcase
		"https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=150"
	end
end

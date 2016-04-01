Given(/^the following movies exist:$/) do |table|
    tables.hashes.each do |movie|
        Movie.create(movie)
    end
end
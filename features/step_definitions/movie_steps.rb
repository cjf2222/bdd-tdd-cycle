Given(/^the following movies exist:$/) do |table|
    table.hashes.each do |movie|
        Movie.create(movie)
    end
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |arg1, arg2|
    assert page.body => /#{arg1}.+Director.+#{arg2}/m
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
    page.body.index(e1).should < page.body.index(e2)
end


When /I (un)check the following ratings: (.*)/ do |uncheck, rating_list|
    ratings = rating.list.split(', ')
    ratings.each do |rating|
        if uncheck
            step "I uncheck \"ratings_" + rating + "\""
        else
            step "I check \"ratings_" + rating + "\""
        end
    end
end

Then /I should see all the movies/ do
    page.body.scan(/<tr>/).length.should equal(Movie.all.length + 1)
end

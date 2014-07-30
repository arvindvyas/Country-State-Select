# CountryStateSelect


## Installation

Add this line to your application's Gemfile:

    gem 'country_state_select'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install country_state_select


##Very easy to create select box just follow below steps

It will create for you a select option, just care about 'id' if you want to update your state field 

    <%= f.select :country_name, CountryStateSelect::Constant::COUNTRIES, {}, id: 'country_id' %>

Create your state like mention below, and take care about id of the select field if you will change this then it will now work as it should be 

    <%= f.text_field :state_name ,:id=> 'state_name'%>

If you want to store country id then use this select option it will store the country id inside the database if you want the state field update with this then you can put id field inside this also like we have mention in previous example  

    <%= f.select(:country_id, options_for_select(Array[*CountryStateSelect::Constant::COUNTRIES.collect {|v,i| [v,
    CountryStateSelect::Constant::COUNTRIES.index(v)] }], :selected => f.object)) %>

If you want to fetch the country name By 'id' then you have to just write 

    <%= CountryStateSelect::Constant::COUNTRIES['PASS THE COUNTRY ID WHICH YOU SAVE HERE'] %>


NOTE :- It will update the state field when there will be India,United Kingdom,Canada and United States so except there country if you select other country then you have to manually enter the state name, we are working on this soon we will cover most of the country 


## Contributing

1. Fork it ( https://github.com/[my-github-username]/country_state_select/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

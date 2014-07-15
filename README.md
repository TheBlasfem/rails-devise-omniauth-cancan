Rails-devise-omniauth-cancan
============

App to getting started with Devise, Omniauth and Cancan

Devise changed for authenticate with username or email, the last one not required in remote authentications. Also, the module confirmable is ready to added in user.rb (it's launching with smtp gmail, check config/environments/development.rb)

Omniauthdemos: Facebook, Twitter, put your app keys in config/initializers/devise.rb

Cancan examples: user can destroy his own post, users can only see posts if is not restricted.

Btw, this code was made thanks the book "Learning Devise for Rails" http://www.packtpub.com/learning-devise-for-rails/book
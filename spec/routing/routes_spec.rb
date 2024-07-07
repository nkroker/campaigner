# spec/routing/routes_spec.rb
require 'rails_helper'

RSpec.describe 'routes for Users', type: :routing do
  it 'routes /users to the users controller' do
    expect(get('/users')).to route_to('users#index')
  end

  it 'routes /users/filter to the users controller' do
    expect(get('/users/filter')).to route_to('users#filter')
  end
end

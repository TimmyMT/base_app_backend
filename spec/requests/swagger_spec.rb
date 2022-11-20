require 'swagger_helper'

describe 'users API' do

  path '/api/v1/users' do

    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: { type: :object, properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            }
          },
        },
        required: [ 'email', 'password', 'password_confirmation' ]
      }

      response '201', "You're registered successfully" do
        run_test!
      end

      response '400', 'Something went wrong, please try again' do
        run_test!
      end
    end
  end
end
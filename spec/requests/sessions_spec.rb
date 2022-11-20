require 'swagger_helper'

describe 'sessions API' do

  path '/api/v1/sessions' do

    post 'Creates a session' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          user: { type: :object, properties: {
              email: { type: :string },
              password: { type: :string }
            }
          },
        },
        required: [ 'email', 'password', 'password_confirmation' ]
      }

      response '201', "Created", document: true do
        example 'application/json', :example_1, {
          user_id: 1,
          token: 'blablabla',  # Token.create(...).token
          expires_in: DateTime.now  # Token.create(...).expires_in
        }

        run_test!
      end

      response '400', 'Bad request' do
        example 'application/json', :example_1, {
          message: "Something went wrong, please try again"
        }
        
        run_test!
      end
    end
  end
end
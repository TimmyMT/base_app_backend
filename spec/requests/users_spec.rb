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

      response '201', "Created" do
        example 'application/json', :example_1, {
          message: "You're registered successfully"
        }

        run_test!
      end

      response '400', "Bad request", document: true do
        example 'application/json', :example_1, {
          message: "Something went wrong, please try again"
        }

        run_test!
      end
    end
  end

  path '/api/v1/users' do
    get 'Return users list' do
      tags 'Users'
      produces 'application/json'
      
      response '200', "Found" do
        schema type: :object, '$ref' => '#/components/schemas/users_array'

        run_test!
      end
    end
  end

  path '/api/v1/users/:id' do
    get 'Return user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', "Found" do
        schema type: :object, '$ref' => '#/components/schemas/user'

        run_test!
      end

      response '400', "Bad request" do
        example 'application/json', :example_1, {
          message: "Something went wrong, please try again"
        }

        run_test!
      end
    end
  end
end
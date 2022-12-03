require 'swagger_helper'

describe 'users API' do
  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            '$ref' => '#/components/schemas/signup_request_data_user'
          }
        }
      }

      response '201', "Created" do
        example 'application/json', :example_1, {
          message: "You're registered successfully"
        }

        run_test!
      end

      response '400', "Bad request", document: true do
        schema type: :object,
        properties: { 
          errors: { 
            '$ref' => '#/components/schemas/invalid_user'
          }
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
        schema '$ref' => '#/components/schemas/users_array'

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    get 'Return user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', "Found" do
        schema '$ref' => '#/components/schemas/user'

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

  path '/api/v1/users/{id}/confirm_account' do
    get 'Confirm account' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', "Found" do
        example 'application/json', :example_1, {
          message: "Welcome to the Sample App! Your email has been confirmed"
        }

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

  path '/api/v1/users/{id}' do
    patch 'Update user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter in: :body, schema: {
        type: :object,
        properties: {
          profile: {
            '$ref' => '#/components/schemas/profile_data_user'
          }
        }
      }

      response '200', "Found" do
        schema '$ref' => '#/components/schemas/user'

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/load_avatar' do
    patch 'Load user avatar' do
      tags 'Users'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter in: :body, schema: {
        '$ref' => '#/components/schemas/avatar_file',
        encoding: {
          avatar: {
            contentType: ['image/png', 'image/jpeg']
          }
        }
      }

      response '200', "Found" do
        schema '$ref' => '#/components/schemas/user'

        run_test!
      end
    end
  end
end

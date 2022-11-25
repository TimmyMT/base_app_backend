require 'swagger_helper'

describe 'sessions API' do
  path '/api/v1/sessions' do
    post 'Creates a session' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
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

      response '201', "Created" do
        schema type: :object, '$ref' => '#/components/schemas/access_token'

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

  path '/api/v1/sessions/refresh' do
    post 'Refresh session' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string },
        },
        required: [ 'token' ]
      }

      response '201', "Created" do
        schema type: :object, '$ref' => '#/components/schemas/access_token'

        run_test!
      end

      response '401', 'Unauthorized' do
        example 'application/json', :example_1, {
          message: "Access denied"
        }
        
        run_test!
      end
    end
  end

  path '/api/v1/sessions/logout' do
    delete 'Delete session' do
      tags 'Sessions'
      consumes 'application/json'

      response '204', "No content" do
        run_test!
      end

      response '401', 'Unauthorized' do
        example 'application/json', :example_1, {
          message: "Access denied"
        }
        
        run_test!
      end
    end
  end
end
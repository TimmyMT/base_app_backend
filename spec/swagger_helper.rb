# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: { # arbitrary name for the security scheme
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          jwt_payload: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              email: { type: 'string', format: 'email' },
              admin: { type: 'boolean' },
              salt: { type: 'string' },
              expires_in: { type: 'string', format: 'date-time' },
            },
            required: %w[id email admin salt expires_in],
          },
          signin_request_data_user: {
            type: 'object',
            properties: {
              email: { type: 'string', format: 'email' },
              password: { type: 'string', format: 'password' },
            },
            required: %w[email password],
          },
          signup_request_data_user: {
            allOf: [
              {
                '$ref': '#/components/schemas/signin_request_data_user'
              },
              {
                type: 'object',
                properties: {
                  password_confirmation: { type: 'string', format: 'password' },
                },
                required: %w[password_confirmation],
              },
            ],
          },
          profile_data_user: {
            type: 'object',
            properties: {
              first_name: { type: 'string' },
              last_name: { type: 'string' },
              age: { type: 'integer' },
              gender: { type: 'string' }
            }
          },
          avatar_file: {
            type: 'object',
            properties: {
              avatar: { type: 'file' }
            }
          },
          user: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              email: { type: 'string', format: 'email' },
              first_name: { type: 'string' },
              last_name: { type: 'string' },
              age: { type: 'integer' },
              gender: { type: 'string' },
              avatar: { type: 'string' }
            },
            required: %w[id email created_at updated_at],
          },
          invalid_user: {
            type: 'object',
            properties: {
              email: { type: 'array', items: { type: 'string' } },
              password: { type: 'array', items: { type: 'string' } },
              
            },
          },
          access_token: {
            type: 'object',
            properties: {
              user_id: { type: 'integer' },
              token: { type: 'string' },
              expires_in: { type: 'string', format: 'date-time' },
              refresh: { type: 'string' }
            },
            required: %w[user_id token expires_in refresh],
          },
          users_array: {
            type: 'array',
            items: { '$ref' => '#/components/schemas/user' }
          }
        }
      },
      security: [
        { 'bearerAuth' => [] }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end

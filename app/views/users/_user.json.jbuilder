json.extract! user, :id, :name, :email, :verified, :session_token, :created_at, :updated_at
json.url user_url(user, format: :json)

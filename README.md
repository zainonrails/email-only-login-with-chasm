# README

Setup email only login with [getchasm.com](https://getchasm.com) API.

Build a passwordless authentication flow using Chasm's API in a Rails App.

<img width="500" alt="Screenshot 2023-04-21 at 1 07 20 AM" src="https://user-images.githubusercontent.com/45653859/233476376-b972e3ba-992f-4169-b3da-f9ca48a65b71.png">
<img width="500" alt="Screenshot 2023-04-21 at 1 45 36 AM" src="https://user-images.githubusercontent.com/45653859/233483786-85042e21-293b-4293-8e7a-4373f077ab8d.png">
<img width="500" alt="Screenshot 2023-04-21 at 1 45 06 AM" src="https://user-images.githubusercontent.com/45653859/233483691-69619047-8e07-40ca-ac9c-7d021872d846.png">
<img width="500" alt="Screenshot 2023-04-21 at 1 46 18 AM" src="https://user-images.githubusercontent.com/45653859/233483917-4de9659e-7b5c-4356-ba39-639f9255b5a1.png">



### Synopsis

This app creates a simple service to call the API to send a magic link to the user via email. Chasm will handle creating, emailing the link and verifying the link. Once the user clicks the link, Chasm will verify it and redirect user to your set callback URL (webhook) along with a JWT token containing payload. On receiving the payload, the app decodes it using `HS256` algorithm and `OTP secret` (from Chasm's Dashboard) and matching the payload with our stored user inf, if it matches then it means the user has been verified and can be given access to the app.

### API call

You need your API key to make the request and pass the recipient email to send the sign in link.

```ruby
    # API call
    
    url = URI("http://api.getchasm.com/v1/links")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = false

    request = Net::HTTP::Post.new(url)
    form_data = [['to', email],['api_key', ENV['CHASM_API_KEY']]]
    request.set_form form_data, 'multipart/form-data'
    response = https.request(request)
    response.read_body
    
    # Response
    
    {
        secret: 'bb9c185e3ab9c3671cb30e9192bd9ceb',
        message: 'Sign in link was successfully sent.'
    }
```

You can use httparty or any other gem to make your calls as well.


### Signature of the redirect URL

*pre-requisite: Add a callback URL in the Webhooks Settings to properly redirection of your users.*

<img width="500" alt="Screenshot 2023-04-21 at 1 47 57 AM" src="https://user-images.githubusercontent.com/45653859/233484258-c8042bde-9f8c-413c-b8b3-83657d724771.png">


`https://www.yoursite.com/callback?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhbmRvbUBlbWFpbC5jb20iLCJzZWNyZXQiOiJiYjljMTg1ZTNhYjljMzY3MWNiMzBlOTE5MmJkOWNlYmJiOWMxODVlM2FiOWMzNjcxY2IzMGU5MTkyYmQ5Y2ViIiwidmVyaWZpZWQiOnRydWV9.mcnvQE_YZCoBe4r0JIisEv5znVJuUXjEF0IYm5Bygpw`

This URL consist of a JWT token that can be decoded using JWT lib for relevant language. 

Chasm uses '**HS256**' algorithm and your **OTP Secret** to encode the token that you will find in your dashboard.

You can decode using the same secret and algorithm. For more info about JWT visit [jwt.io](https://jwt.io)

```ruby
# decoding JWT in ruby

payload = JWT.decode(params[:secret], ENV['CHASM_OTP_SECRET'], 'HS256')[0]

# payload
{
  verified: true,
  email: 'random@email.com',
  secret: 'bb9c185e3ab9c3671cb30e9192bd9ceb'
}
```




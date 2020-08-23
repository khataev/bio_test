email = 'admin@example.com'
User.create email: email, encrypted_password: BCrypt::Password.create(email)

client = Client.create name: 'client 3 name'

Project.create! name: 'Project1', client: client, status: :created
Project.create! name: 'Project2', client: client, status: :in_progress

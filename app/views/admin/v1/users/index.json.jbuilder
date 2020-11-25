json.users do
  json.array! @users, :id, :name, :profile, :email
end

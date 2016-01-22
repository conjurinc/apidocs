alice = user "alice", password: "secret"

group "security_admin" do
  owns do
    variable("dev/redis/password") do |var|
      var.add_value "8912dbp9bu1pub"
    end

    group "dev"

    group "ops"
  end

  add_member alice, admin_option: true
end

group "pubkeys-1.0/key-managers" do
  add_member alice
end

%w(bob charles daniel).each do |login|
  user login, password: "9p8nfsdafbp", ownerid: "cucumber:group:security_admin"
end

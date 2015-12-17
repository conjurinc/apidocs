group "security_admin" do
  owns do
    variable("dev/redis/password") do |var|
      var.add_value "8912dbp9bu1pub"
    end
    
    group "developers"
  end
end

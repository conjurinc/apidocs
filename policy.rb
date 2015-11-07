policy('apidocs-v1') do
  apiary_api_key = variable('/apiary.io/api-key')

  group('/v4/ops') do
    can 'read', apiary_api_key
    can 'execute', apiary_api_key
    can 'update', apiary_api_key
  end

  group('/v4/developers') do
    can 'read', apiary_api_key
    can 'execute', apiary_api_key
  end

  layer('/build-0.1.0/jenkins') do
    can 'execute', apiary_api_key
  end
end

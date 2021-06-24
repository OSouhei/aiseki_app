RSpec::Matchers.define :have_content_type_json do
  match do |response|
    response.content_type == "application/json; charset=utf-8"
  end
end

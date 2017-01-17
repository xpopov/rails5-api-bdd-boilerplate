def stub_microsoft_load
  stub_request(:get, "www.microsoft.com").
  	to_return(File.new(Rails.root + "test/stubs/requests/www.microsoft.com.raw"))
end

def stub_dummy_load
  html_body = File.read(Rails.root + "test/stubs/requests/www.dummy.com.html")
  stub_request(:get, "www.dummy.com").
  	to_return(body: html_body, 
      status: 200, headers: { 'Content-Length' => html_body.length })
end
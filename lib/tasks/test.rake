require 'json'
require 'yaml'

namespace :test do

    desc "Dumps pages data to tests/data/microsoft_page_data.yml"
        task :dump => :environment do
            session = ActionDispatch::Integration::Session.new(Rails.application)
            # Invoke API call
            session.post "/api/pages/store", params: { url: 'https://www.microsoft.com/en-us/'}
            # Get rid of unnecessary attributes and save as YAML
            data = JSON.parse(session.response.body)
            data['url'] = 'http://www.microsoft.com'
            data.except! 'id', 'created_at', 'updated_at'
            File.open(Rails.root + 'test/data/microsoft_page_data.yml', 'w') { |file| file.write(data.to_yaml) }

            # Save CURL RAW output as well
            cmd = "curl -is https://www.microsoft.com/en-us/ > #{Rails.root}/test/stubs/requests/www.microsoft.com.raw"
            puts cmd
            exec cmd
    end
end
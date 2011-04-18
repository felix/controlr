namespace 'db' do
  desc 'Dump db schema for revision control'
  task 'schema' => :environment do
    File.open(File.join(Rails.root,'db','schema.txt'),'w') do |schema|
      DataMapper::Model.descendants.sort{|a,b| a.name <=> b.name}.each do |model|
        schema.write("\n#{model.name}\n")
        model.properties.each{|p| schema.write("#{p.name} => #{p.options.inspect}\n") }
      end
    end
  end
end

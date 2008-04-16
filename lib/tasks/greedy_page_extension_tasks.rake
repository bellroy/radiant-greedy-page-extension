namespace :radiant do
  namespace :extensions do
    namespace :greedy_page do
      
      desc "Runs the migration of the Greedy Page extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          GreedyPageExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          GreedyPageExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Greedy Page to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[GreedyPageExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(GreedyPageExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end

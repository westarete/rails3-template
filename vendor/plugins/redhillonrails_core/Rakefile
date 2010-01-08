require 'rake'
require 'spec/rake/spectask'

desc 'Run the specs'
namespace :spec do
  namespace :plugins do
    Spec::Rake::SpecTask.new(:redhillonrails_core) do |t|
      t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
      t.spec_files = FileList['spec/**/*_spec.rb']
    end
  end
end
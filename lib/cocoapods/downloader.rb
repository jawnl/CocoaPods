module Pod
  class Downloader
    autoload :Git,        'cocoapods/downloader/git'
    autoload :Mercurial,  'cocoapods/downloader/mercurial'
    autoload :Subversion, 'cocoapods/downloader/subversion'

    extend Executable

    def self.for_pod(pod)
      for_target(pod.root, pod.specification.source.dup)
    end
    
    def self.for_dependency(dependency)
      for_target(dependency.pod_root, dependency.external_spec_source)
    end

    attr_reader :target_path, :url, :options

    def initialize(target_path, url, options)
      @target_path, @url, @options = target_path, url, options
      @target_path.mkpath
    end

    def clean
      # implement in sub-classes
    end
    
    private
    
    def self.for_target(target_path, options)
      if url = options.delete(:git)
        Git.new(target_path, url, options)
      elsif url = options.delete(:hg)
        Mercurial.new(target_path, url, options)
      elsif url = options.delete(:svn)
        Subversion.new(target_path, url, options)
      else
        raise "Unsupported download strategy `#{options.inspect}'."
      end
    end
  end
end

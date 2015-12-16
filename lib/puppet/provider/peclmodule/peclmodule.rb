Puppet::Type.type(:peclmodule).provide(:peclmodule) do
  desc 'pecl module'

  commands :pecl => 'pecl'

  #TODO: no esta acabat d'implementar  -_-

  def self.instances
    count=0
    pecl(['list']).split("\n").collect do |package|
      if count > 2
        debug "instance \""+package+"\""
        new(
          :ensure => :present,
          :name => package,
          )
      end
    end
  end

  def self.prefetch(resources)
    resources.keys.each do |name|
      if provider = instances.find{ |db| db.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present || false
  end

  def create
    debug "call create()"
    pecl(['install', resource[:name] ])
  end

  def destroy
    debug "call destroy()"
    pecl(['uninstall', resource[:name] ])
  end

end

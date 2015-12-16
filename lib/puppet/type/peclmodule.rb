Puppet::Type.newtype(:peclmodule) do
  @doc = 'Manage pecl modules'

  ensurable

  autorequire(:package) do
    'php-pear'
    'php5-dev'
  end

  newparam(:name, :namevar => true) do
    desc 'pecl module to manage'

    validate do |value|
      unless value.is_a?(String)
        raise Pupper::Error,
          "not a string, modafuca"
      end
    end
  end
end

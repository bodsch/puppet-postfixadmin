require 'spec_helper'

describe 'postfixadmin' do
  context 'supported operating systems' do
    ['Debian', 'RedHat','gentoo'].each do |osfamily|
      describe "postfixadmin class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('postfixadmin::params') }
        it { should contain_class('postfixadmin::install').that_comes_before('postfixadmin::config') }
        it { should contain_class('postfixadmin::config') }

        it { should contain_package('postfixadmin').with_ensure('present') }
      end
    end
  end

#  context 'unsupported operating system' do
#    describe 'postfixadmin class without any parameters on Solaris/Nexenta' do
#      let(:facts) {{
#        :osfamily        => 'Solaris',
#        :operatingsystem => 'Nexenta',
#      }}
#
#      it { expect { should contain_package('postfixadmin') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
#    end
#  end
end

require 'spec_helper'

describe package('php') {
  it { should be_installed }
}

describe package('mysql') {
  it { should be_installed }
}

describe package('nginx') {
  it { should be_installed }
}

describe port(80) do
  it { should be_listening }
end

describe port(3306) do
  it { should be_listening }
end

describe command('mysql -N -B --user="root" --password="rootpass" --execute="SHOW databases;"') do
  it { should return_stdout /^laraveldb$/ }
end

describe file('/srv/test-app/app/config/database.php') do
  it { should be_file }
  its(:content) { should match /^\s+['"]default['"]\s+=>\s+['"]mysql['"],$/ }
  its(:content) { should match /^\s+['"]driver['"]\s+=>\s+['"]mysql['"],$/ }
  its(:content) { should match /^\s+['"]host['"]\s+=>\s+['"]localhost['"],$/ }
  its(:content) { should match /^\s+['"]database['"]\s+=>\s+['"]laraveldb['"],$/ }
  its(:content) { should match /^\s+['"]username['"]\s+=>\s+['"]root['"],$/ }
  its(:content) { should match /^\s+['"]password['"]\s+=>\s+['"]rootpass['"],$/ }
end

# Check that the demo app is functioning properly
describe command('wget -O- http://127.0.0.1/') do
  it { should return_stdout /Laravel PHP Framework/ }
  it { should return_stderr /200 OK/ }
end